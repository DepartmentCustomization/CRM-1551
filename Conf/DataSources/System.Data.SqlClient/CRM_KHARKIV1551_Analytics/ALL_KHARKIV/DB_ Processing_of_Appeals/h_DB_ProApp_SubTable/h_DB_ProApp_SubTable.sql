--на нижние таблички
  --параметры
  /*
  declare @navigator nvarchar(50)=N'Заходи';--Усі
  declare @column nvarchar(50)=N'overdue';
  declare @user_id nvarchar(128)=N'29796543-b903-48a6-9399-4840f6eac396';*/
  --фильтрация начало
    

  IF object_id('tempdb..#temp_filter_d_qt') IS NOT NULL DROP TABLE #temp_filter_d_qt

  IF object_id('tempdb..#temp_filter_d_qt_all') IS NOT NULL DROP TABLE #temp_filter_d_qt_all

  IF object_id('tempdb..#temp_filter_emergensy_id') IS NOT NULL DROP TABLE #temp_filter_emergensy_id

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

select distinct 1 Id, emergensy_id
into #temp_filter_emergensy_id
from [dbo].[FiltersForControler] f
where f.user_id=@user_id and f.questiondirection_id is  null and f.emergensy_id is not null





declare @filter_d_qt nvarchar(max)=
N'('+stuff((
select distinct N') or ( [Objects].district_id='+ltrim(district_id)+N' and [QuestionTypes].Id in ('+stuff(
(select N', '+ltrim(question_type_id) 
from #temp_filter_d_qt 
where district_id=t.district_id
for xml path('')),1,2,N'')+N')' 
from #temp_filter_d_qt t
for xml path ('')
), 1,6, N'')+N')'

declare @filter_d_qt_all nvarchar(max)=
stuff((select distinct N', '+ltrim(district_id) from #temp_filter_d_qt_all for xml path('')), 1, 2, N'')

declare @filter_emergensy_id nvarchar(max)=
stuff((select distinct N', '+ltrim(emergensy_id) from #temp_filter_emergensy_id for xml path('')), 1, 2, N'')


--select @filter_d_qt, @filter_d_qt_all, @filter_emergensy_id

--declare @filters_an nvarchar(max)=isnull(@filter_d_qt,N' or 1=2')+isnull(N' or [Objects].district_id in ('+@filter_d_qt_all+N')', N' or (1=2)')+isnull(N' and ( [QuestionTypes].emergency in ('+@filter_emergensy_id+N'))',N' or 1=2')

declare @filters_an nvarchar(max)=N'(( '+isnull(@filter_d_qt,N' or 1=2')+isnull(N' or [Objects].district_id in ('+@filter_d_qt_all+N')', N' or (1=2)')+N')'+isnull(N' and ( [QuestionTypes].emergency in ('+@filter_emergensy_id+N'))',N' or (1=2)')+N')'


--declare @filters_ev nvarchar(max)=isnull(@filter_d_qt,N' or 1=2')+isnull(N' or [Objects].district_id in ('+@filter_d_qt_all+N')', N' or 1=2')

declare @filters_ev nvarchar(max)=N'( '+isnull(@filter_d_qt,N' or 1=2')+isnull(N' or [Objects].district_id in ('+@filter_d_qt_all+N')', N' or 1=2')+N')'

--select @filters_an, @filters_ev
  --фильтрация конец
  
  declare @navigator_q nvarchar(max)=
  case when @navigator=N'Усі' then (select stuff((select N', '+ltrim(Id)--, emergensy_name name
  from [dbo].[Emergensy]
  for xml path('')), 1, 2, N'')+N', 0')
	   when @navigator=N'Заходи' then N'0'
	   when @navigator is not null 
								  then (select ltrim(Id)--, emergensy_name name
								  from [dbo].[Emergensy]
								  where [emergensy_name]=@navigator)
		end


  --select @navigator_q

  declare @where nvarchar(max)=
  case  when @column=N'arrived'
			then N'[Assignments].[assignment_state_id]=1 ' /*Зареєстровано*/
		when @column=N'in_work'
			then N'[Assignments].[assignment_state_id]=2 ' /*В роботі*/
		when @column=N'attention'
			then N'getutcdate() between dateadd(HH, [QuestionTypes].Attention_term_hours, [Assignments].registration_date) and [Assignments].execution_date'
		when @column=N'overdue'
			then N'[Assignments].execution_date<getutcdate()'
		when @column=N'for_revision'
			then N'[Assignments].[assignment_state_id]=4 /*Не виконано*/ and [Assignments].AssignmentResultsId=5 /*На доопрацювання*/ ' /*Зареєстровано переделать на доопрацюванні*/
	    when @column=N'future'
			then N'[Assignments].registration_date>getutcdate()'
		when @column=N'without_executor'
			then N'[Assignments].executor_organization_id=1762'
		else N'1=2'
		end

  declare @where_event nvarchar(max)=
  case
		when @column=N'in_work'
			then N'[Events].active=''true'' and [start_date]<getutcdate() and [plan_end_date]>getutcdate()'
		when @column=N'overdue'
			then N'[Events].active=''true'' and [plan_end_date]<getutcdate()'
		when @column=N'future'
			then N'[Events].start_date>getutcdate()'
		else N'1=2'
		end

  declare @query1 nvarchar(max)=N'
 
  SELECT
[Assignments].Id,
[Questions].registration_number,
[Assignments].[registration_date],
[QuestionTypes].name QuestionType,
[StreetTypes].shortname + Streets.name + N'', '' + [Buildings].name place_problem,
[Assignments].[execution_date] control_date,
[Organizations].short_name vykonavets,
[AssignmentConsiderations].short_answer comment,
[Applicants].full_name zayavnyk,
[Applicants].[ApplicantAdress] ZayavnykAdress,
[Questions].question_content content
FROM
[CRM_1551_Analitics].[dbo].[Assignments] WITH (nolock)
INNER JOIN [CRM_1551_Analitics].[dbo].[Questions] WITH (nolock) ON [Assignments].question_id = [Questions].Id
INNER JOIN [CRM_1551_Analitics].[dbo].[Appeals] WITH (nolock) ON [Questions].appeal_id = [Appeals].Id
INNER JOIN [CRM_1551_Analitics].[dbo].[ReceiptSources] WITH (nolock) ON [Appeals].receipt_source_id = [ReceiptSources].Id
INNER JOIN [QuestionTypes] WITH (nolock) ON [Questions].question_type_id = [QuestionTypes].Id
LEFT JOIN [CRM_1551_Analitics].[dbo].[Applicants] WITH (nolock) ON [Appeals].applicant_id = [Applicants].Id
LEFT JOIN [CRM_1551_Analitics].[dbo].[Objects] WITH (nolock) ON [Questions].[object_id] = [Objects].Id
LEFT JOIN [CRM_1551_Analitics].[dbo].[Buildings] WITH (nolock) ON [Objects].builbing_id = [Buildings].Id
LEFT JOIN [CRM_1551_Analitics].[dbo].[Streets] WITH (nolock) ON [Buildings].street_id = [Streets].Id
LEFT JOIN [CRM_1551_Analitics].[dbo].[StreetTypes] WITH (nolock) ON [Streets].street_type_id = [StreetTypes].Id
LEFT JOIN [CRM_1551_Analitics].[dbo].[Organizations] WITH (nolock) ON [Assignments].executor_organization_id = [Organizations].Id
LEFT JOIN [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] WITH (nolock) ON [AssignmentConsiderations].Id = Assignments.current_assignment_consideration_id
where [QuestionTypes].emergency in ('+@navigator_q+N') and '+@where+N' and '+@filters_an
--union all

declare @query2 nvarchar(max)=N'

select [Events].[Id]*(-1) Id, 
  LTRIM([Events].Id) registration_number, 
  [Events].[registration_date], 
  [Event_Class].name QuestionType,
  [StreetTypes].shortname + Streets.name + N'', '' + [Buildings].name place_problem,
  [Events].plan_end_date control_date,
  [Organizations].short_name vykonavets,
  [Events].comment,
  null zayavnyk,
  null ZayavnykAdress,
  null content
  from [CRM_1551_Analitics].[dbo].[Events] WITH (nolock)
  left join [CRM_1551_Analitics].[dbo].[Event_Class] WITH (nolock) on [Events].event_class_id=[Event_Class].Id
  left join [CRM_1551_Analitics].[dbo].[EventObjects] WITH (nolock) on [Events].Id=[EventObjects].event_id and [EventObjects].in_form=''true''
  left join [CRM_1551_Analitics].[dbo].[EventQuestionsTypes] on [EventQuestionsTypes].event_id=[Events].Id
  left join [dbo].[QuestionTypes] on [EventQuestionsTypes].question_type_id=[QuestionTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Objects] WITH (nolock) on [EventObjects].object_id=[Objects].Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[Buildings] WITH (nolock) ON [Objects].builbing_id = [Buildings].Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[Streets] WITH (nolock) ON [Buildings].street_id = [Streets].Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[StreetTypes] WITH (nolock) ON [Streets].street_type_id = [StreetTypes].Id
  left join [CRM_1551_Analitics].[dbo].[EventOrganizers] WITH (nolock) on [Events].Id=[EventOrganizers].event_id and [EventOrganizers].main=''true''
  left join [CRM_1551_Analitics].[dbo].[Organizations] WITH (nolock) on [EventOrganizers].organization_id=[Organizations].Id
  where '+@where_event+N' and '+ @filters_ev

  declare @query nvarchar(max)=
  case when charindex(N',',@navigator_q, 1)>0 
		then @query1+N' union all '+@query2
		when @navigator_q=N'0' then @query2
		else @query1 
		end

  --select len(@query)

  exec (@query)

  --select @filters_an, @filters_ev, @navigator_q, @where

