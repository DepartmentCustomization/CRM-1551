

  --параметры
  --declare @user_Id nvarchar(128)=N'29796543-b903-48a6-9399-4840f6eac396';

  --фильтрация начало

  IF object_id('tempdb..#temp_filter_d_qt') IS NOT NULL DROP TABLE #temp_filter_d_qt

  IF object_id('tempdb..#temp_filter_d_qt_all') IS NOT NULL DROP TABLE #temp_filter_d_qt_all

  IF object_id('tempdb..#temp_filter_emergensy_id') IS NOT NULL DROP TABLE #temp_filter_emergensy_id

  create table #temp_filter_emergensy_id (Id int, emergensy_id int )

  --select *
  --from [dbo].[FiltersForControler]
  --where user_id=@user_id

  ;with
it as --дети @id
(select t.Id, question_type_id ParentId, name, f.district_id
from [dbo].[QuestionTypes] t
inner join [dbo].[FiltersForControler] f on t.Id=f.questiondirection_id
where f.user_id=@user_id and f.questiondirection_id is not null and f.questiondirection_id<>0
union all
select t.Id, t.question_type_id, t.name, it.district_id
from [dbo].[QuestionTypes] t inner join it on t.question_type_id=it.Id)

--выбраный район и его вопросы с подтипами, если не выбранные все типы вопроса
select distinct 1 Id, Id question_type_id, district_id 
into #temp_filter_d_qt
from it
--order by Id



select distinct 1 Id, district_id
into #temp_filter_d_qt_all
from [dbo].[FiltersForControler] f
where f.user_id=@user_id and f.questiondirection_id is not null and f.questiondirection_id=0

if not exists (select distinct 1 Id, emergensy_id
from [dbo].[FiltersForControler] f
where f.user_id=@user_id and f.questiondirection_id is  null and f.emergensy_id is not null)

begin
	insert into #temp_filter_emergensy_id (Id, emergensy_id)
	select distinct 1 Id, Id emergensy_id
	--into #temp_filter_emergensy_id
	from [CRM_1551_Analitics].[dbo].Emergensy
end

else
	begin
	insert into #temp_filter_emergensy_id (Id, emergensy_id)
select distinct 1 Id, emergensy_id
--into #temp_filter_emergensy_id
from [dbo].[FiltersForControler] f
where f.user_id=@user_id and f.questiondirection_id is  null and f.emergensy_id is not null

end

--select * from #temp_filter_d_qt

--select * from #temp_filter_d_qt_all

--select * from #temp_filter_emergensy_id

  --фильтрация конец

  IF object_id('tempdb..#temp_emergensy') IS NOT NULL DROP TABLE #temp_emergensy
  
  select [Id], [emergensy_name] name, 
  case when [emergensy_name]=N'Аварійна' then 1
  when [emergensy_name]=N'Термінова' then 2
  when [emergensy_name]=N'Звичайна' then 3 end sort
  into #temp_emergensy
  from [CRM_1551_Analitics].[dbo].[Emergensy] 
  union
  select 0, N'Заходи', 0 sort

  --select * from #temp_emergensy


  IF object_id('tempdb..#temp_arrived') IS NOT NULL DROP TABLE #temp_arrived 

  select N'arrived' name, [QuestionTypes].emergency, count([Assignments].Id) count_id
  into #temp_arrived
  from [CRM_1551_Analitics].[dbo].[Assignments]
  inner join [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
  inner join [dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].object_id=[Objects].Id
  left join #temp_filter_d_qt temp_filter_d_qt on temp_filter_d_qt.district_id=[Objects].district_id and temp_filter_d_qt.question_type_id=[QuestionTypes].Id
  left join #temp_filter_d_qt_all temp_filter_d_qt_all on temp_filter_d_qt_all.district_id=[Objects].district_id
  left join #temp_filter_emergensy_id temp_filter_emergensy_id on temp_filter_emergensy_id.emergensy_id=[QuestionTypes].emergency

  where [Assignments].[assignment_state_id]=1 /*Зареєстровано*/
  and --фильтрация
  (temp_filter_d_qt.Id is not null
  or temp_filter_d_qt_all.Id is not null
  ) and temp_filter_emergensy_id.Id is not null
  group by [QuestionTypes].emergency

  IF object_id('tempdb..#temp_in_work') IS NOT NULL DROP TABLE #temp_in_work 

  select N'in_work' name, [QuestionTypes].emergency, count([Assignments].Id) count_id
  into #temp_in_work 
  from [CRM_1551_Analitics].[dbo].[Assignments]
  inner join [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
  inner join [dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].object_id=[Objects].Id
  left join #temp_filter_d_qt temp_filter_d_qt on temp_filter_d_qt.district_id=[Objects].district_id and temp_filter_d_qt.question_type_id=[QuestionTypes].Id
  left join #temp_filter_d_qt_all temp_filter_d_qt_all on temp_filter_d_qt_all.district_id=[Objects].district_id
  left join #temp_filter_emergensy_id temp_filter_emergensy_id on temp_filter_emergensy_id.emergensy_id=[QuestionTypes].emergency

  where [Assignments].[assignment_state_id]=2 /*В роботі*/
  and --фильтрация
  (temp_filter_d_qt.Id is not null
  or temp_filter_d_qt_all.Id is not null
  ) and temp_filter_emergensy_id.Id is not null
  group by [QuestionTypes].emergency
  union all
  select N'in_work' name, 0 emergency, count([Events].Id) count_id
  from [CRM_1551_Analitics].[dbo].[Events]
  left join [CRM_1551_Analitics].[dbo].[EventObjects] on [Events].Id=[EventObjects].event_id
  left join [CRM_1551_Analitics].[dbo].[Objects] on [EventObjects].object_id=[Objects].Id
  left join [CRM_1551_Analitics].[dbo].[EventQuestionsTypes] on [EventQuestionsTypes].event_id=[Events].Id
  left join [dbo].[QuestionTypes] on [EventQuestionsTypes].question_type_id=[QuestionTypes].Id

  left join #temp_filter_d_qt temp_filter_d_qt on temp_filter_d_qt.district_id=[Objects].district_id and temp_filter_d_qt.question_type_id=[QuestionTypes].Id
  left join #temp_filter_d_qt_all temp_filter_d_qt_all on temp_filter_d_qt_all.district_id=[Objects].district_id
  --left join #temp_filter_emergensy_id temp_filter_emergensy_id on temp_filter_emergensy_id.emergensy_id=[QuestionTypes].emergency
  where [Events].active='true' and [start_date]<getutcdate() and [plan_end_date]>getutcdate()
  and --фильтрация
  (temp_filter_d_qt.Id is not null
  or temp_filter_d_qt_all.Id is not null
  --or temp_filter_emergensy_id.Id is not null
  )

  IF object_id('tempdb..#temp_attention') IS NOT NULL DROP TABLE #temp_attention

  select N'attention' name, [QuestionTypes].emergency, count([Assignments].Id) count_id
  into #temp_attention 
  from [CRM_1551_Analitics].[dbo].[Assignments]
  inner join [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
  inner join [dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].object_id=[Objects].Id
  left join #temp_filter_d_qt temp_filter_d_qt on temp_filter_d_qt.district_id=[Objects].district_id and temp_filter_d_qt.question_type_id=[QuestionTypes].Id
  left join #temp_filter_d_qt_all temp_filter_d_qt_all on temp_filter_d_qt_all.district_id=[Objects].district_id
  left join #temp_filter_emergensy_id temp_filter_emergensy_id on temp_filter_emergensy_id.emergensy_id=[QuestionTypes].emergency

  where getutcdate() between dateadd(HH, [QuestionTypes].Attention_term_hours, [Assignments].registration_date) and [Assignments].execution_date
  and --фильтрация
  (temp_filter_d_qt.Id is not null
  or temp_filter_d_qt_all.Id is not null
  ) and temp_filter_emergensy_id.Id is not null
  group by [QuestionTypes].emergency

  --overdue

  IF object_id('tempdb..#temp_overdue') IS NOT NULL DROP TABLE #temp_overdue

  select N'overdue' name, [QuestionTypes].emergency, count([Assignments].Id) count_id
  into #temp_overdue
  from [CRM_1551_Analitics].[dbo].[Assignments]
  inner join [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
  inner join [dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].object_id=[Objects].Id
  left join #temp_filter_d_qt temp_filter_d_qt on temp_filter_d_qt.district_id=[Objects].district_id and temp_filter_d_qt.question_type_id=[QuestionTypes].Id
  left join #temp_filter_d_qt_all temp_filter_d_qt_all on temp_filter_d_qt_all.district_id=[Objects].district_id
  left join #temp_filter_emergensy_id temp_filter_emergensy_id on temp_filter_emergensy_id.emergensy_id=[QuestionTypes].emergency

  where [Assignments].execution_date<getutcdate()
  and --фильтрация
  (temp_filter_d_qt.Id is not null
  or temp_filter_d_qt_all.Id is not null
  ) and temp_filter_emergensy_id.Id is not null
  group by [QuestionTypes].emergency
  union all
  select N'overdue' name, 0 emergency, count([Events].Id) count_id
  from [CRM_1551_Analitics].[dbo].[Events]
  left join [CRM_1551_Analitics].[dbo].[EventObjects] on [Events].Id=[EventObjects].event_id
  left join [CRM_1551_Analitics].[dbo].[Objects] on [EventObjects].object_id=[Objects].Id
  left join [CRM_1551_Analitics].[dbo].[EventQuestionsTypes] on [EventQuestionsTypes].event_id=[Events].Id
  left join [dbo].[QuestionTypes] on [EventQuestionsTypes].question_type_id=[QuestionTypes].Id

  left join #temp_filter_d_qt temp_filter_d_qt on temp_filter_d_qt.district_id=[Objects].district_id and temp_filter_d_qt.question_type_id=[QuestionTypes].Id
  left join #temp_filter_d_qt_all temp_filter_d_qt_all on temp_filter_d_qt_all.district_id=[Objects].district_id
  --left join #temp_filter_emergensy_id temp_filter_emergensy_id on temp_filter_emergensy_id.emergensy_id=[QuestionTypes].emergency
  where [Events].active='true' and [plan_end_date]<getutcdate()
  and --фильтрация
  (temp_filter_d_qt.Id is not null
  or temp_filter_d_qt_all.Id is not null
  --or temp_filter_emergensy_id.Id is not null
  )

  IF object_id('tempdb..#temp_for_revision') IS NOT NULL DROP TABLE #temp_for_revision

  select N'for_revision' name, [QuestionTypes].emergency, count([Assignments].Id) count_id
  into #temp_for_revision
  from [CRM_1551_Analitics].[dbo].[Assignments]
  inner join [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
  inner join [dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].object_id=[Objects].Id
  left join #temp_filter_d_qt temp_filter_d_qt on temp_filter_d_qt.district_id=[Objects].district_id and temp_filter_d_qt.question_type_id=[QuestionTypes].Id
  left join #temp_filter_d_qt_all temp_filter_d_qt_all on temp_filter_d_qt_all.district_id=[Objects].district_id
  left join #temp_filter_emergensy_id temp_filter_emergensy_id on temp_filter_emergensy_id.emergensy_id=[QuestionTypes].emergency

  where [Assignments].[assignment_state_id]=4 /*Не виконано*/ and [Assignments].AssignmentResultsId=5 /*На доопрацювання*/ /*Зареєстровано переделать на доопрацюванні*/
  and --фильтрация
  (temp_filter_d_qt.Id is not null
  or temp_filter_d_qt_all.Id is not null
  ) and temp_filter_emergensy_id.Id is not null
  group by [QuestionTypes].emergency


  IF object_id('tempdb..#temp_future') IS NOT NULL DROP TABLE #temp_future

  select N'future' name, [QuestionTypes].emergency, count([Assignments].Id) count_id
  into #temp_future
  from [CRM_1551_Analitics].[dbo].[Assignments]
  inner join [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
  inner join [dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].object_id=[Objects].Id
  left join #temp_filter_d_qt temp_filter_d_qt on temp_filter_d_qt.district_id=[Objects].district_id and temp_filter_d_qt.question_type_id=[QuestionTypes].Id
  left join #temp_filter_d_qt_all temp_filter_d_qt_all on temp_filter_d_qt_all.district_id=[Objects].district_id
  left join #temp_filter_emergensy_id temp_filter_emergensy_id on temp_filter_emergensy_id.emergensy_id=[QuestionTypes].emergency

  where [Assignments].registration_date>getutcdate()
  and --фильтрация
  (temp_filter_d_qt.Id is not null
  or temp_filter_d_qt_all.Id is not null
  ) and temp_filter_emergensy_id.Id is not null
  group by [QuestionTypes].emergency
  union all
  select N'future' name, 0 emergency, count([Events].Id) count_id
  from [CRM_1551_Analitics].[dbo].[Events]
  left join [CRM_1551_Analitics].[dbo].[EventObjects] on [Events].Id=[EventObjects].event_id
  left join [CRM_1551_Analitics].[dbo].[Objects] on [EventObjects].object_id=[Objects].Id
  left join [CRM_1551_Analitics].[dbo].[EventQuestionsTypes] on [EventQuestionsTypes].event_id=[Events].Id
  left join [dbo].[QuestionTypes] on [EventQuestionsTypes].question_type_id=[QuestionTypes].Id

  left join #temp_filter_d_qt temp_filter_d_qt on temp_filter_d_qt.district_id=[Objects].district_id and temp_filter_d_qt.question_type_id=[QuestionTypes].Id
  left join #temp_filter_d_qt_all temp_filter_d_qt_all on temp_filter_d_qt_all.district_id=[Objects].district_id
  --left join #temp_filter_emergensy_id temp_filter_emergensy_id on temp_filter_emergensy_id.emergensy_id=[QuestionTypes].emergency
  where [Events].start_date>getutcdate()--active='true' and [plan_end_date]<getutcdate()
  and --фильтрация
  (temp_filter_d_qt.Id is not null
  or temp_filter_d_qt_all.Id is not null
  --or temp_filter_emergensy_id.Id is not null
  )

  IF object_id('tempdb..#temp_without_executor') IS NOT NULL DROP TABLE #temp_without_executor

  select N'without_executor' name, [QuestionTypes].emergency, count([Assignments].Id) count_id
  into #temp_without_executor
  from [CRM_1551_Analitics].[dbo].[Assignments]
  inner join [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
  inner join [dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].object_id=[Objects].Id
  left join #temp_filter_d_qt temp_filter_d_qt on temp_filter_d_qt.district_id=[Objects].district_id and temp_filter_d_qt.question_type_id=[QuestionTypes].Id
  left join #temp_filter_d_qt_all temp_filter_d_qt_all on temp_filter_d_qt_all.district_id=[Objects].district_id
  left join #temp_filter_emergensy_id temp_filter_emergensy_id on temp_filter_emergensy_id.emergensy_id=[QuestionTypes].emergency

  where [Assignments].executor_organization_id=1762
  and --фильтрация
  (temp_filter_d_qt.Id is not null
  or temp_filter_d_qt_all.Id is not null
  ) and temp_filter_emergensy_id.Id is not null
  group by [QuestionTypes].emergency


  
  IF object_id('tempdb..#temp_main') IS NOT NULL DROP TABLE #temp_main

  select emergensy.Id, emergensy.name, 
  isnull(sum(arrived.count_id),0) arrived, 
  isnull(sum(in_work.count_id),0) in_work,
  isnull(sum(attention.count_id),0) attention,
  isnull(sum(overdue.count_id),0) overdue,
  isnull(sum(for_revision.count_id),0) for_revision,
  isnull(sum(future.count_id),0) future,
  isnull(sum(without_executor.count_id),0) without_executor
  into #temp_main
  from #temp_emergensy emergensy 
  left join #temp_arrived arrived on emergensy.Id=arrived.emergency
  left join #temp_in_work in_work on emergensy.Id=in_work.emergency
  left join #temp_attention attention on emergensy.Id=attention.emergency
  left join #temp_overdue overdue on emergensy.Id=overdue.emergency
  left join #temp_for_revision for_revision on emergensy.Id=for_revision.emergency
  left join #temp_future future on emergensy.Id=future.emergency
  left join #temp_without_executor without_executor on emergensy.Id=without_executor.emergency
  group by emergensy.sort, emergensy.name, emergensy.Id
  
  

  select Id, name, arrived, in_work, attention, overdue, for_revision, future, without_executor
  from #temp_main
  union all
  select 4 Id, N'Усього' name, sum(arrived), sum(in_work), sum(attention), sum(overdue), sum(for_revision), sum(future), sum(without_executor)
  from #temp_main