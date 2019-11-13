--declare @organization_id int =2006;
--declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';

 declare @role nvarchar(500)=
   (select [Roles].name
   from [CRM_1551_Analitics].[dbo].[Positions] with (nolock)
   left join [CRM_1551_Analitics].[dbo].[Roles] on [Positions].role_id=[Roles].Id
   where [Positions].programuser_id=@user_id)

 declare @Organization table(Id int);

 declare @OrganizationId int = 
 case 
 when @organization_id is not null
 then @organization_id
 else (select Id
   from [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)
   where Id in (select organization_id
   from [CRM_1551_Analitics].[dbo].[Workers] with (nolock)
   where worker_user_id=@user_id))
  end


 declare @IdT table (Id int);

 -- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
 insert into @IdT(Id)
 select Id from [CRM_1551_Analitics].[dbo].[Organizations]  with (nolock)
 where (Id=@OrganizationId or [parent_organization_id]=@OrganizationId) and Id not in (select Id from @IdT)

 --  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
 while (select count(id) from (select Id from [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)
 where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
 and Id not in (select Id from @IdT)) q)!=0
 begin

 insert into @IdT
 select Id from [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)
 where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
 and Id not in (select Id from @IdT)
 end 

 insert into @Organization (Id)
 select Id from @IdT;



 ------------для плана/програми---
  if object_id('tempdb..#temp_main_end') is not null drop table #temp_main_end
  select Id
  into #temp_main_end
  from [Assignments] with (nolock)
  where assignment_state_id=5 and AssignmentResultsId=7 and executor_organization_id=@organization_id
 
  
  if object_id('tempdb..#temp_end_state') is not null drop table #temp_end_state
  select [Assignment_History].Id, [Assignment_History].assignment_id, [Assignment_History].assignment_state_id
  into #temp_end_state
  from [Assignment_History] with (nolock) inner join #temp_main_end on [Assignment_History].assignment_id=#temp_main_end.Id
  inner join [AssignmentStates] on [Assignment_History].assignment_state_id=[AssignmentStates].Id

  where [AssignmentStates].code=N'OnCheck' and
  [AssignmentStates].code<>N'Closed' and [Assignment_History].id in
  (select max([Assignment_History].id) id_max
  from [Assignment_History]  with (nolock) inner join #temp_main_end on [Assignment_History].assignment_id=#temp_main_end.Id
  where [Assignment_History].assignment_state_id<>5
  group by [Assignment_History].assignment_id)
  

  if object_id('tempdb..#temp_end_result') is not null drop table #temp_end_result
  select [Assignment_History].Id, [Assignment_History].assignment_id, [Assignment_History].AssignmentResultsId
  into #temp_end_result
  from [Assignment_History] with (nolock) inner join #temp_main_end on [Assignment_History].assignment_id=#temp_main_end.Id
  inner join [AssignmentResults] on [Assignment_History].AssignmentResultsId=[AssignmentResults].Id
  where [AssignmentResults].code=N'ItIsNotPossibleToPerformThisPeriod' and
  [AssignmentResults].code<>N'WasExplained ' and [Assignment_History].id in
  (select max([Assignment_History].id) id_max
  from [Assignment_History] with (nolock) inner join #temp_main_end on [Assignment_History].assignment_id=#temp_main_end.Id
  where [Assignment_History].AssignmentResultsId<>7
  group by [Assignment_History].assignment_id)


 -----------------основное-----

if object_id('tempdb..#temp_navig') is not null drop table #temp_navig
select * 
into #temp_navig
from (
		select 1 Id, N'УГЛ' name union all select 2 Id, N'Електронні джерела' union all select 3 Id, N'Пріоритетне' union all 
		select 4 Id, N'Інші доручення' union all select 5 Id, N'Зауваження'
	) as t
	
 if object_id('tempdb..#temp_nadiishlo') is not null drop table #temp_nadiishlo
 select [Assignments].Id,
 case when [ReceiptSources].code=N'UGL' then 1
 when [ReceiptSources].code=N'Website_mob.addition' then 2
 when [QuestionTypes].emergency=N'true' then 3
 when [QuestionTypes].parent_organization_is=N'true' then 5
 else 4
 end navigation
 into #temp_nadiishlo
 from 
 [CRM_1551_Analitics].[dbo].[Assignments]  with (nolock) left join 
 [CRM_1551_Analitics].[dbo].[Questions]  with (nolock) on [Assignments].question_id=[Questions].Id
 left join [CRM_1551_Analitics].[dbo].[Appeals]  with (nolock) on [Questions].appeal_id=[Appeals].Id
 left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
 left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock) on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock) on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id

 where 
 (([AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'Registered' and [AssignmentResults].[name]=N'Очікує прийому в роботу') 
 or ([AssignmentResults].code=N'ReturnedToTheArtist' and [AssignmentStates].code=N'Registered'))
 and
 [Assignments].[executor_organization_id]=@organization_id


if object_id('tempdb..#temp_nevkomp') is not null drop table #temp_nevkomp
   select [Assignments].Id,
 case when [ReceiptSources].code=N'UGL' then 1
 when [ReceiptSources].code=N'Website_mob.addition' then 2
 when [QuestionTypes].emergency=N'true' then 3
 when [QuestionTypes].parent_organization_is=N'true' then 5
 else 4
 end navigation
 into #temp_nevkomp
   from [CRM_1551_Analitics].[dbo].[Assignments] with (nolock) left join 
[CRM_1551_Analitics].[dbo].[Questions] with (nolock) on [Assignments].question_id=[Questions].Id
left join [CRM_1551_Analitics].[dbo].[Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] with (nolock) on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock) on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock) on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
where 
   [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code<>N'Closed' and [AssignmentResults].code=N'NotInTheCompetence'
   and [AssignmentResolutions].name in (N'Повернуто в 1551', N'Повернуто в батьківську організацію')
   and (case when @role=N'Конролер' and [AssignmentResolutions].name=N'Повернуто в 1551' then 1
   when @role<>N'Конролер' and [AssignmentResolutions].name=N'Повернуто в батьківську організацію'
   then 1 end)=1
   and [AssignmentConsiderations].turn_organization_id=@organization_id


 if object_id('tempdb..#temp_prostr') is not null drop table #temp_prostr
 select [Assignments].Id, 
 case when [ReceiptSources].code=N'UGL' then 1
 when [ReceiptSources].code=N'Website_mob.addition' then 2
 when [QuestionTypes].emergency=N'true' then 3
 when [QuestionTypes].parent_organization_is=N'true' then 5
 else 4
 end navigation
 into #temp_prostr
 from 
 [CRM_1551_Analitics].[dbo].[Assignments] with (nolock) left join 
 [CRM_1551_Analitics].[dbo].[Questions] with (nolock) on [Assignments].question_id=[Questions].Id
 left join [CRM_1551_Analitics].[dbo].[Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
 left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
 left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock) on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
 left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock) on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
 where 
 --[AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork' and 
 --[Questions].control_date<=getutcdate()
   ([Questions].control_date<=getutcdate() and [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork' )
 and
 [Assignments].[executor_organization_id]=@organization_id


if object_id('tempdb..#temp_uvaga') is not null drop table #temp_uvaga
 select [Assignments].Id, 
 case when [ReceiptSources].code=N'UGL' then 1
 when [ReceiptSources].code=N'Website_mob.addition' then 2
 when [QuestionTypes].emergency=N'true' then 3
 when [QuestionTypes].parent_organization_is=N'true' then 5
 else 4
 end navigation
 into #temp_uvaga
 from 
 [CRM_1551_Analitics].[dbo].[Assignments] with (nolock) left join 
 [CRM_1551_Analitics].[dbo].[Questions] with (nolock) on [Assignments].question_id=[Questions].Id
 left join [CRM_1551_Analitics].[dbo].[Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
 left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
 left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock) on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
 left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock) on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
 where 
 --[AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork' and 
 --datediff(HH, [Assignments].registration_date, getdate())>[Attention_term_hours]
 --and datediff(HH, [Assignments].registration_date, getdate())<=[execution_term]
 -- DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.25*-1, [Questions].control_date)<getutcdate()
  -- [Questions].control_date>=getutcdate()
   (DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.25*-1, [Questions].control_date)<getutcdate() and [Questions].control_date>=getutcdate() and [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork')
 and [Assignments].[executor_organization_id]=@organization_id
 

if object_id('tempdb..#temp_vroboti') is not null drop table #temp_vroboti
 select [Assignments].Id, 
 case when [ReceiptSources].code=N'UGL' then 1
 when [ReceiptSources].code=N'Website_mob.addition' then 2
 when [QuestionTypes].emergency=N'true' then 3
 when [QuestionTypes].parent_organization_is=N'true' then 5
 else 4
 end navigation
 into #temp_vroboti
 from 
 [CRM_1551_Analitics].[dbo].[Assignments] with (nolock) left join 
 [CRM_1551_Analitics].[dbo].[Questions] with (nolock) on [Assignments].question_id=[Questions].Id
 left join [CRM_1551_Analitics].[dbo].[Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
 left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
 left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock) on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
 left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock) on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
 where 
 --[AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork' and
 --datediff(HH, [Assignments].registration_date, getdate())<=[Attention_term_hours]
-- DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.75, [Questions].registration_date)>=getutcdate()
 -- and [Questions].control_date>=getutcdate()
   [Assignments].[executor_organization_id]=@organization_id
 and (DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.75, [Questions].registration_date)>=getutcdate() and [Questions].control_date>=getutcdate() and [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork')



if object_id('tempdb..#temp_dovidoma') is not null drop table #temp_dovidoma
 select [Assignments].Id, 
 case when [ReceiptSources].code=N'UGL' then 1
 when [ReceiptSources].code=N'Website_mob.addition' then 2
 when [QuestionTypes].emergency=N'true' then 3
 when [QuestionTypes].parent_organization_is=N'true' then 5
 else 4
 end navigation
 into #temp_dovidoma
 from 
 [CRM_1551_Analitics].[dbo].[Assignments] with (nolock) left join 
 [CRM_1551_Analitics].[dbo].[Questions] with (nolock) on [Assignments].question_id=[Questions].Id
 left join [CRM_1551_Analitics].[dbo].[Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
 left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
 left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock) on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
 left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock) on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id

 where 
 [AssignmentTypes].code=N'ToAttention' and [AssignmentStates].code=N'Registered'
 and [Assignments].[executor_organization_id]=@organization_id



if object_id('tempdb..#temp_nadoopr') is not null drop table #temp_nadoopr
 select [Assignments].Id, 
 case when [ReceiptSources].code=N'UGL' then 1
 when [ReceiptSources].code=N'Website_mob.addition' then 2
 when [QuestionTypes].emergency=N'true' then 3
 when [QuestionTypes].parent_organization_is=N'true' then 5
 else 4
 end navigation
 into #temp_nadoopr
 from 
 [CRM_1551_Analitics].[dbo].[Assignments] with (nolock) left join 
 [CRM_1551_Analitics].[dbo].[Questions] with (nolock) on [Assignments].question_id=[Questions].Id
 left join [CRM_1551_Analitics].[dbo].[Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
 left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
 left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock) on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
 left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock) on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id

 where 
 [AssignmentStates].code=N'NotFulfilled' and ([AssignmentResults].code=N'ForWork' or [AssignmentResults].code=N'Actually')
 and [Assignments].[executor_organization_id]=@organization_id



 if object_id('tempdb..#temp_plan_p') is not null drop table #temp_plan_p
 select [Assignments].Id, 
 case when [ReceiptSources].code=N'UGL' then 1
 when [ReceiptSources].code=N'Website_mob.addition' then 2
 when [QuestionTypes].emergency=N'true' then 3
 when [QuestionTypes].parent_organization_is=N'true' then 5
 else 4
 end navigation
 into #temp_plan_p
 from 
 [CRM_1551_Analitics].[dbo].[Assignments]  with (nolock)
 inner join #temp_end_result on [Assignments].Id=#temp_end_result.assignment_id
 inner join #temp_end_state on [Assignments].Id=#temp_end_state.assignment_id
 left join [CRM_1551_Analitics].[dbo].[Questions] with (nolock) on [Assignments].question_id=[Questions].Id
 left join [CRM_1551_Analitics].[dbo].[Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
 left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
 left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock) on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
 left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock) on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id

 --where 
 --[AssignmentStates].code=N'NotFulfilled' and [AssignmentResults].code=N'ItIsNotPossibleToPerformThisPeriod'

 --and [Assignments].[executor_organization_id]=@organization_id


 if object_id('tempdb..#temp_main') is not null drop table #temp_main
 
 select Id, navigation, N'nadiishlo' name
 into #temp_main
 from #temp_nadiishlo
 union all
 select Id, navigation, N'nevkomp' name
 from #temp_nevkomp
 union all
 select Id, navigation, N'prostr' name
 from #temp_prostr
 union all
 select Id, navigation, N'uvaga' name
 from #temp_uvaga
 union all
 select Id, navigation, N'vroboti' name
 from #temp_vroboti
 union all
 select Id, navigation, N'dovidoma' name
 from #temp_dovidoma
 union all
 select Id, navigation, N'nadoopr' name
 from #temp_nadoopr
 union all
 select Id, navigation, N'neVykonNeMozhl' name
 from #temp_plan_p
 


select Id, name [navigation], isnull([nadiishlo], 0) [nadiyshlo], isnull([nevkomp], 0) [neVKompetentsii], 
isnull([prostr], 0) [prostrocheni], isnull([uvaga], 0) [uvaga], isnull([vroboti], 0) [vroboti],
isnull([dovidoma], 0) [dovidoma], isnull([nadoopr], 0) [naDoopratsiyvanni], isnull([neVykonNeMozhl], 0) [neVykonNeMozhl]
from
(select #temp_navig.Id, #temp_navig.name, main.name main_name, cc
from #temp_navig left join 
(select navigation, name, count(Id) cc from #temp_main group by navigation, name) main on #temp_navig.Id=main.navigation) t
pivot
( sum(cc) for main_name in ([nadiishlo], [nevkomp], [prostr], [uvaga], [vroboti], [dovidoma], [nadoopr], [neVykonNeMozhl])
) pvt
