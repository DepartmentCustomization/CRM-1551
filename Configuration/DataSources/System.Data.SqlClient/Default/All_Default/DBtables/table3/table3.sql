/*
 declare @organization_id int =2184; --289  6704
 declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
*/
  declare @role nvarchar(500)=
  (select [Roles].name
  from [CRM_1551_Analitics].[dbo].[Positions] with (nolock)
  left join [CRM_1551_Analitics].[dbo].[Roles]  with (nolock) on [Positions].role_id=[Roles].Id
  where [Positions].programuser_id=@user_id)

  --SELECT @role


 
declare @Organization table(Id int);

--------------новейшие разработки
declare @t table (Id int, PId int);
-- declare @OrganizationT_id int =6704;
--declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
declare @OrganizationT table(Id int);
declare @Par table (Id0 int identity(1,1), Id int);
declare @n int =1;
declare @OrganizationTId int;

insert into @Par(Id)
select id from [CRM_1551_Analitics].[dbo].[Organizations]  with (nolock) where parent_organization_id=@Organization_id


--select * from @Par

while @n<=(select max(Id0) from @Par)
	begin
set @OrganizationTId = (select id from @Par where Id0=@n)--@OrganizationT_id;


declare @IdTT table (Id int);

-- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
insert into @IdTT(Id)
select Id from [CRM_1551_Analitics].[dbo].[Organizations]  with (nolock)
where (Id=@OrganizationTId or [parent_organization_id]=@OrganizationTId) and Id not in (select Id from @IdTT)

--  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
while (select count(id) from (select Id from [CRM_1551_Analitics].[dbo].[Organizations]  with (nolock)
where [parent_organization_id] in (select Id from @IdTT) --or Id in (select Id from @IdT)
and Id not in (select Id from @IdTT)) q)!=0
begin

insert into @IdTT
select Id from [CRM_1551_Analitics].[dbo].[Organizations]  with (nolock)
where [parent_organization_id] in (select Id from @IdTT) --or Id in (select Id from @IdT)
and Id not in (select Id from @IdTT)
end 

insert into @OrganizationT (Id)
select Id from @IdTT;

insert into @t (Id, PId)
select Id, @OrganizationTId PId from @OrganizationT

set @n=@n+1

delete from @OrganizationT
delete from @IdTT
	end



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
where ( [parent_organization_id]=@OrganizationId) and Id not in (select Id from @IdT)

--  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
while (select count(id) from (select Id from [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)
where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
and Id not in (select Id from @IdT)) q)!=0
begin

insert into @IdT
select Id from [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)
where [parent_organization_id] in (select Id from @IdT)-- or Id in (select Id from @IdT)
and Id not in (select Id from @IdT)
end 

insert into @Organization (Id)
select Id from @IdT;

--select Id, @organization_id from @Organization

--існуючі доручення в організації
declare @Organizations_is table (Id int);
insert into @Organizations_is(Id)
  select distinct  [executor_organization_id]
  from [CRM_1551_Analitics].[dbo].[Assignments] with (nolock)
  where [executor_organization_id] in (select Id from @Organization)

  declare @Organization_nevkonp table (Id int);

  insert into @Organization_nevkonp (Id)

  select distinct [turn_organization_id]
  from [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] with (nolock)
  where [turn_organization_id] in (select Id from @Organization);
  

  -------------------------------------------------------------------------------------------------------------------------------
 -------------------------------------------------------------------------------------------------------------------------------
  ------------для плана/програми---

if object_id('tempdb..#temp_main_end') is not null drop table #temp_main_end
  select Id
  into #temp_main_end
  from [Assignments] with (nolock) 
  where assignment_state_id=5 and AssignmentResultsId=7 and executor_organization_id in (select id from @Organizations_is)

if object_id('tempdb..#temp_end_state') is not null drop table #temp_end_state
  select [Assignment_History].Id, [Assignment_History].assignment_id, [Assignment_History].assignment_state_id
  into #temp_end_state
  from [Assignment_History] inner join #temp_main_end on [Assignment_History].assignment_id=#temp_main_end.Id
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
  from [Assignment_History]  with (nolock) inner join #temp_main_end on [Assignment_History].assignment_id=#temp_main_end.Id
  inner join [AssignmentResults] on [Assignment_History].AssignmentResultsId=[AssignmentResults].Id
  where [AssignmentResults].code=N'ItIsNotPossibleToPerformThisPeriod' and
  [AssignmentResults].code<>N'WasExplained ' and [Assignment_History].id in
  (select max([Assignment_History].id) id_max
  from [Assignment_History] with (nolock) inner join #temp_main_end on [Assignment_History].assignment_id=#temp_main_end.Id
  where [Assignment_History].AssignmentResultsId<>7
  group by [Assignment_History].assignment_id)



 -----------------основное-----
 if object_id('tempdb..#temp_nadiishlo') is not null drop table #temp_nadiishlo
	select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName
	into #temp_nadiishlo
	from 
	[CRM_1551_Analitics].[dbo].[Assignments] with (nolock)  left join 
	[CRM_1551_Analitics].[dbo].[Questions] with (nolock)  on [Assignments].question_id=[Questions].Id
	left join [CRM_1551_Analitics].[dbo].[Appeals]  with (nolock) on [Questions].appeal_id=[Appeals].Id
	left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock)  on [Appeals].receipt_source_id=[ReceiptSources].Id
	left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock)  on [Questions].question_type_id=[QuestionTypes].Id
	left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
	left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
	left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock)  on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id
	left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock)  on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
	left join [CRM_1551_Analitics].[dbo].[Organizations]  with (nolock) on [Assignments].executor_organization_id=[Organizations].Id
	where 
	(([AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'Registered' and [AssignmentResults].[name]=N'Очікує прийому в роботу') 
	or ([AssignmentResults].code=N'ReturnedToTheArtist' and [AssignmentStates].code=N'Registered'))
	and
	[Assignments].[executor_organization_id] in (select id from @Organizations_is)--=@organization_id
	



if object_id('tempdb..#temp_nevkomp') is not null drop table #temp_nevkomp
 select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName/*,
 case when [ReceiptSources].code=N'UGL' then 1
 when [ReceiptSources].code=N'Website_mob.addition' then 2
 when [QuestionTypes].emergency=N'true' then 3
 when [QuestionTypes].parent_organization_is=N'true' then 5
 else 4
 end navigation*/
 into #temp_nevkomp
   from [CRM_1551_Analitics].[dbo].[Assignments] with (nolock)  left join 
[CRM_1551_Analitics].[dbo].[Questions] with (nolock)  on [Assignments].question_id=[Questions].Id
left join [CRM_1551_Analitics].[dbo].[Appeals]  with (nolock) on [Questions].appeal_id=[Appeals].Id
left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock)  on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock)  on [Questions].question_type_id=[QuestionTypes].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentTypes]  with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock)  on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] with (nolock)  on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock)  on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock)  on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
--left join [CRM_1551_Analitics].[dbo].[Organizations] on [Assignments].executor_organization_id=[Organizations].Id
left join [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)  on [AssignmentConsiderations].turn_organization_id=[Organizations].Id

where 
   [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code<>N'Closed' and [AssignmentResults].code=N'NotInTheCompetence'
   and [AssignmentResolutions].name in (N'Повернуто в 1551', N'Повернуто в батьківську організацію')
   and (case when @role=N'Конролер' and [AssignmentResolutions].name=N'Повернуто в 1551' then 1
   when @role<>N'Конролер' and [AssignmentResolutions].name=N'Повернуто в батьківську організацію'
   then 1 end)=1
   and [AssignmentConsiderations].turn_organization_id in (select id from @Organizations_is)--=@organization_id
 



if object_id('tempdb..#temp_prostr') is not null drop table #temp_prostr
 select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName
 into #temp_prostr
 from 
 [CRM_1551_Analitics].[dbo].[Assignments] with (nolock) left join 
 [CRM_1551_Analitics].[dbo].[Questions] with (nolock)  on [Assignments].question_id=[Questions].Id
 left join [CRM_1551_Analitics].[dbo].[Appeals] with (nolock)  on [Questions].appeal_id=[Appeals].Id
 left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock)  on [Appeals].receipt_source_id=[ReceiptSources].Id
 left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock)  on [Questions].question_type_id=[QuestionTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] with (nolock)  on [Assignments].assignment_type_id=[AssignmentTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock)  on [Assignments].assignment_state_id=[AssignmentStates].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock)  on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
 left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock)  on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
 left join [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)  on [Assignments].executor_organization_id=[Organizations].Id
 where 
 --[AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork' and 
 --[Questions].[control_date]<getutcdate() 
   ([Questions].control_date<=getutcdate() and [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork' )
   and
 [Assignments].[executor_organization_id] in (select id from @Organizations_is)--=@organization_id




 
if object_id('tempdb..#temp_uvaga') is not null drop table #temp_uvaga
 select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName
 into #temp_uvaga
 from [CRM_1551_Analitics].[dbo].[Assignments]  with (nolock) 
 left join [CRM_1551_Analitics].[dbo].[Questions]  with (nolock) on [Assignments].question_id=[Questions].Id
 left join [CRM_1551_Analitics].[dbo].[Appeals] with (nolock)  on [Questions].appeal_id=[Appeals].Id
 left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock)  on [Appeals].receipt_source_id=[ReceiptSources].Id
 left join [CRM_1551_Analitics].[dbo].[QuestionTypes]  with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] with (nolock)  on [Assignments].assignment_type_id=[AssignmentTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock)  on [Assignments].assignment_state_id=[AssignmentStates].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentResults]  with (nolock) on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
 left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock)  on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
 left join [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)  on [Assignments].executor_organization_id=[Organizations].Id
 where 
   [Questions].control_date>=getutcdate()
  and    (DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.25*-1, [Questions].control_date)<getutcdate() and [Questions].control_date>=getutcdate() and [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork')
 and [Assignments].[executor_organization_id] in (select id from @Organizations_is)--=@organization_id
 


 
 
if object_id('tempdb..#temp_vroboti') is not null drop table #temp_vroboti
 select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName
 into #temp_vroboti
 from 
 [CRM_1551_Analitics].[dbo].[Assignments] with (nolock)  left join 
 [CRM_1551_Analitics].[dbo].[Questions] with (nolock)  on [Assignments].question_id=[Questions].Id
 left join [CRM_1551_Analitics].[dbo].[Appeals]  with (nolock) on [Questions].appeal_id=[Appeals].Id
 left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock)  on [Appeals].receipt_source_id=[ReceiptSources].Id
 left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock)  on [Questions].question_type_id=[QuestionTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] with (nolock)  on [Assignments].assignment_type_id=[AssignmentTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock)  on [Assignments].assignment_state_id=[AssignmentStates].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock)  on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
 left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock)  on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
 left join [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)  on [Assignments].executor_organization_id=[Organizations].Id
 where 
   [Questions].control_date>=getutcdate()
 and (DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.75, [Questions].registration_date)>=getutcdate() and [Questions].control_date>=getutcdate() and [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork')
 and [Assignments].[executor_organization_id] in (select id from @Organizations_is)--=@organization_id
 



if object_id('tempdb..#temp_dovidoma') is not null drop table #temp_dovidoma
 select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName
 into #temp_dovidoma
 from 
 [CRM_1551_Analitics].[dbo].[Assignments] with (nolock)  left join 
 [CRM_1551_Analitics].[dbo].[Questions] with (nolock)  on [Assignments].question_id=[Questions].Id
 left join [CRM_1551_Analitics].[dbo].[Appeals] with (nolock)  on [Questions].appeal_id=[Appeals].Id
 left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock)  on [Appeals].receipt_source_id=[ReceiptSources].Id
 left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock)  on [Questions].question_type_id=[QuestionTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] with (nolock)  on [Assignments].assignment_type_id=[AssignmentTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock)  on [Assignments].assignment_state_id=[AssignmentStates].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock)  on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
 left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock)  on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
 left join [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)  on [Assignments].executor_organization_id=[Organizations].Id
 where 
 [AssignmentTypes].code=N'ToAttention' and [AssignmentStates].code=N'Registered'
 and [Assignments].[executor_organization_id] in (select id from @Organizations_is)--=@organization_id
 


 
if object_id('tempdb..#temp_nadoopr') is not null drop table #temp_nadoopr
 select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName
 into #temp_nadoopr
 from 
 [CRM_1551_Analitics].[dbo].[Assignments] with (nolock)  left join 
 [CRM_1551_Analitics].[dbo].[Questions] with (nolock)  on [Assignments].question_id=[Questions].Id
 left join [CRM_1551_Analitics].[dbo].[Appeals] with (nolock)  on [Questions].appeal_id=[Appeals].Id
 left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock)  on [Appeals].receipt_source_id=[ReceiptSources].Id
 left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock)  on [Questions].question_type_id=[QuestionTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] with (nolock)  on [Assignments].assignment_type_id=[AssignmentTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock)  on [Assignments].assignment_state_id=[AssignmentStates].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock)  on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
 left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock)  on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
 left join [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)  on [Assignments].executor_organization_id=[Organizations].Id
 where 
 [AssignmentStates].code=N'NotFulfilled' and ([AssignmentResults].code=N'ForWork' or [AssignmentResults].code=N'Actually')
 and [Assignments].[executor_organization_id] in (select id from @Organizations_is)--=@organization_idd
 


 
if object_id('tempdb..#temp_plan_p') is not null drop table #temp_plan_p
 select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName
 into #temp_plan_p
 from 
 [CRM_1551_Analitics].[dbo].[Assignments]  with (nolock)
 inner join #temp_end_result on [Assignments].Id=#temp_end_result.assignment_id
 inner join #temp_end_state on [Assignments].Id=#temp_end_state.assignment_id
 
 left join [CRM_1551_Analitics].[dbo].[Questions] with (nolock)  on [Assignments].question_id=[Questions].Id
 left join [CRM_1551_Analitics].[dbo].[Appeals] with (nolock)  on [Questions].appeal_id=[Appeals].Id
 left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock)  on [Appeals].receipt_source_id=[ReceiptSources].Id
 left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock)  on [Questions].question_type_id=[QuestionTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentTypes]  with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock)  on [Assignments].assignment_state_id=[AssignmentStates].Id
 left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock)  on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
 left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock)  on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
 left join [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)  on [Assignments].executor_organization_id=[Organizations].Id



 if object_id('tempdb..#temp_main') is not null drop table #temp_main
 

 select Id, N'nadiyshlo' name, OrganizationsId, OrganizationsName
 into #temp_main
 from #temp_nadiishlo
 union all
 select Id, N'neVKompetentsii' name, OrganizationsId, OrganizationsName
 from #temp_nevkomp
 union all
 select Id, N'prostrocheni' name, OrganizationsId, OrganizationsName
 from #temp_prostr
 union all
 select Id, N'uvaga' name, OrganizationsId, OrganizationsName
 from #temp_uvaga
 union all
 select Id, N'vroboti' name, OrganizationsId, OrganizationsName
 from #temp_vroboti
 union all
 select Id, N'dovidoma' name, OrganizationsId, OrganizationsName
 from #temp_dovidoma
 union all
 select Id, N'naDoopratsiyvanni' name, OrganizationsId, OrganizationsName
 from #temp_nadoopr
 union all
 select Id, N'neVykonNeMozhl' name, OrganizationsId, OrganizationsName
 from #temp_plan_p
 




select [OrganizationsId] [OrganizationId], [OrganizationsName] [OrganizationName], [nadiyshlo], 
[neVKompetentsii], [prostrocheni], [uvaga], [vroboti], [dovidoma], [naDoopratsiyvanni], [neVykonNeMozhl]
from #temp_main
pivot
(
count(Id) for name in ([nadiyshlo], [neVKompetentsii], [prostrocheni], [uvaga], [vroboti], [dovidoma], [naDoopratsiyvanni], [neVykonNeMozhl])
) pvt
order by [OrganizationsId]

--   with

--     ------------для плана/програми---
--  main_end as 
--   (
--   select Id
--   from [Assignments] with (nolock) 
--   where assignment_state_id=5 and AssignmentResultsId=7 and executor_organization_id in (select id from @Organizations_is)
--   ), 
--   end_state as
--   (
--   select [Assignment_History].Id, [Assignment_History].assignment_id, [Assignment_History].assignment_state_id
--   from [Assignment_History] inner join main_end on [Assignment_History].assignment_id=main_end.Id
--   inner join [AssignmentStates] on [Assignment_History].assignment_state_id=[AssignmentStates].Id

--   where [AssignmentStates].code=N'OnCheck' and
--   [AssignmentStates].code<>N'Closed' and [Assignment_History].id in
--   (select max([Assignment_History].id) id_max
--   from [Assignment_History]  with (nolock) inner join main_end on [Assignment_History].assignment_id=main_end.Id
--   where [Assignment_History].assignment_state_id<>5
--   group by [Assignment_History].assignment_id)
--   ),
--   end_result as
--   (select [Assignment_History].Id, [Assignment_History].assignment_id, [Assignment_History].AssignmentResultsId
--   from [Assignment_History]  with (nolock) inner join main_end on [Assignment_History].assignment_id=main_end.Id
--   inner join [AssignmentResults] on [Assignment_History].AssignmentResultsId=[AssignmentResults].Id

--   where [AssignmentResults].code=N'ItIsNotPossibleToPerformThisPeriod' and
--   [AssignmentResults].code<>N'WasExplained ' and [Assignment_History].id in
--   (select max([Assignment_History].id) id_max
--   from [Assignment_History] with (nolock) inner join main_end on [Assignment_History].assignment_id=main_end.Id
--   where [Assignment_History].AssignmentResultsId<>7
--   group by [Assignment_History].assignment_id)),


--  -----------------основное-----

--  nadiishlo as
--  (
--  select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName/*,
--  case when [ReceiptSources].code=N'UGL' then 1
--  when [ReceiptSources].code=N'Website_mob.addition' then 2
--  when [QuestionTypes].emergency=N'true' then 3
--  when [QuestionTypes].parent_organization_is=N'true' then 5
--  else 4
--  end navigation*/

--  from 
--  [CRM_1551_Analitics].[dbo].[Assignments] with (nolock)  left join 
--  [CRM_1551_Analitics].[dbo].[Questions] with (nolock)  on [Assignments].question_id=[Questions].Id
--  left join [CRM_1551_Analitics].[dbo].[Appeals]  with (nolock) on [Questions].appeal_id=[Appeals].Id
--  left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock)  on [Appeals].receipt_source_id=[ReceiptSources].Id
--  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock)  on [Questions].question_type_id=[QuestionTypes].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock)  on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock)  on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
--  left join [CRM_1551_Analitics].[dbo].[Organizations]  with (nolock) on [Assignments].executor_organization_id=[Organizations].Id


--  where 
--  (([AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'Registered' and [AssignmentResults].[name]=N'Очікує прийому в роботу') 
--  or ([AssignmentResults].code=N'ReturnedToTheArtist' and [AssignmentStates].code=N'Registered'))
--  and
--  [Assignments].[executor_organization_id] in (select id from @Organizations_is)--=@organization_id
--  ),

--  nevkomp as
--  (

--   select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName/*,
--  case when [ReceiptSources].code=N'UGL' then 1
--  when [ReceiptSources].code=N'Website_mob.addition' then 2
--  when [QuestionTypes].emergency=N'true' then 3
--  when [QuestionTypes].parent_organization_is=N'true' then 5
--  else 4
--  end navigation*/

--   from [CRM_1551_Analitics].[dbo].[Assignments] with (nolock)  left join 
-- [CRM_1551_Analitics].[dbo].[Questions] with (nolock)  on [Assignments].question_id=[Questions].Id
-- left join [CRM_1551_Analitics].[dbo].[Appeals]  with (nolock) on [Questions].appeal_id=[Appeals].Id
-- left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock)  on [Appeals].receipt_source_id=[ReceiptSources].Id
-- left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock)  on [Questions].question_type_id=[QuestionTypes].Id
-- left join [CRM_1551_Analitics].[dbo].[AssignmentTypes]  with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id
-- left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock)  on [Assignments].assignment_state_id=[AssignmentStates].Id
-- left join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] with (nolock)  on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
-- left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock)  on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
-- left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock)  on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
-- --left join [CRM_1551_Analitics].[dbo].[Organizations] on [Assignments].executor_organization_id=[Organizations].Id
-- left join [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)  on [AssignmentConsiderations].turn_organization_id=[Organizations].Id

-- where 
--   [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code<>N'Closed' and [AssignmentResults].code=N'NotInTheCompetence'
--   and [AssignmentResolutions].name in (N'Повернуто в 1551', N'Повернуто в батьківську організацію')
--   and (case when @role=N'Конролер' and [AssignmentResolutions].name=N'Повернуто в 1551' then 1
--   when @role<>N'Конролер' and [AssignmentResolutions].name=N'Повернуто в батьківську організацію'
--   then 1 end)=1

--   and [AssignmentConsiderations].turn_organization_id in (select id from @Organizations_is)--=@organization_id
--  ),

--  prostr as
--  (
--  select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName/*,
--  case when [ReceiptSources].code=N'UGL' then 1
--  when [ReceiptSources].code=N'Website_mob.addition' then 2
--  when [QuestionTypes].emergency=N'true' then 3
--  when [QuestionTypes].parent_organization_is=N'true' then 5
--  else 4
--  end navigation*/

--  from 
--  [CRM_1551_Analitics].[dbo].[Assignments] with (nolock) left join 
--  [CRM_1551_Analitics].[dbo].[Questions] with (nolock)  on [Assignments].question_id=[Questions].Id
--  left join [CRM_1551_Analitics].[dbo].[Appeals] with (nolock)  on [Questions].appeal_id=[Appeals].Id
--  left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock)  on [Appeals].receipt_source_id=[ReceiptSources].Id
--  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock)  on [Questions].question_type_id=[QuestionTypes].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] with (nolock)  on [Assignments].assignment_type_id=[AssignmentTypes].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock)  on [Assignments].assignment_state_id=[AssignmentStates].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock)  on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
--  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock)  on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
--  left join [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)  on [Assignments].executor_organization_id=[Organizations].Id


--  where 
--  --[AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork' and 
--  --[Questions].[control_date]<getutcdate() 
--   ([Questions].control_date<=getutcdate() and [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork' )
--   and
--  [Assignments].[executor_organization_id] in (select id from @Organizations_is)--=@organization_id
--  ),

--  uvaga as
--  (
--  select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName/*,
--  case when [ReceiptSources].code=N'UGL' then 1
--  when [ReceiptSources].code=N'Website_mob.addition' then 2
--  when [QuestionTypes].emergency=N'true' then 3
--  when [QuestionTypes].parent_organization_is=N'true' then 5
--  else 4
--  end navigation*/

--  from 
--  [CRM_1551_Analitics].[dbo].[Assignments]  with (nolock) left join 
--  [CRM_1551_Analitics].[dbo].[Questions]  with (nolock) on [Assignments].question_id=[Questions].Id
--  left join [CRM_1551_Analitics].[dbo].[Appeals] with (nolock)  on [Questions].appeal_id=[Appeals].Id
--  left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock)  on [Appeals].receipt_source_id=[ReceiptSources].Id
--  left join [CRM_1551_Analitics].[dbo].[QuestionTypes]  with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] with (nolock)  on [Assignments].assignment_type_id=[AssignmentTypes].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock)  on [Assignments].assignment_state_id=[AssignmentStates].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentResults]  with (nolock) on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
--  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock)  on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
--  left join [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)  on [Assignments].executor_organization_id=[Organizations].Id


--  where 
-- -- [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork' and 

--  --datediff(HH, [Assignments].registration_date, getdate())>[Attention_term_hours]
--  --and datediff(HH, [Assignments].registration_date, getdate())<=[execution_term]
--  --DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.25*-1, [Questions].control_date)<getutcdate()
--   [Questions].control_date>=getutcdate()
--   and    (DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.25*-1, [Questions].control_date)<getutcdate() and [Questions].control_date>=getutcdate() and [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork')


--  and [Assignments].[executor_organization_id] in (select id from @Organizations_is)--=@organization_id
--  ),

--  vroboti as
--  (
--  select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName

--  from 
--  [CRM_1551_Analitics].[dbo].[Assignments] with (nolock)  left join 
--  [CRM_1551_Analitics].[dbo].[Questions] with (nolock)  on [Assignments].question_id=[Questions].Id
--  left join [CRM_1551_Analitics].[dbo].[Appeals]  with (nolock) on [Questions].appeal_id=[Appeals].Id
--  left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock)  on [Appeals].receipt_source_id=[ReceiptSources].Id
--  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock)  on [Questions].question_type_id=[QuestionTypes].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] with (nolock)  on [Assignments].assignment_type_id=[AssignmentTypes].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock)  on [Assignments].assignment_state_id=[AssignmentStates].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock)  on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
--  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock)  on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
--  left join [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)  on [Assignments].executor_organization_id=[Organizations].Id


--  where 
-- -- [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork' and
--  --datediff(HH, [Assignments].registration_date, getdate())<=[Attention_term_hours]
-- -- DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.75, [Questions].registration_date)>=getutcdate()
--   [Questions].control_date>=getutcdate()
--  and (DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.75, [Questions].registration_date)>=getutcdate() and [Questions].control_date>=getutcdate() and [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork')

--  and [Assignments].[executor_organization_id] in (select id from @Organizations_is)--=@organization_id
--  ),

--  dovidoma as
--  (
--  select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName

--  from 
--  [CRM_1551_Analitics].[dbo].[Assignments] with (nolock)  left join 
--  [CRM_1551_Analitics].[dbo].[Questions] with (nolock)  on [Assignments].question_id=[Questions].Id
--  left join [CRM_1551_Analitics].[dbo].[Appeals] with (nolock)  on [Questions].appeal_id=[Appeals].Id
--  left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock)  on [Appeals].receipt_source_id=[ReceiptSources].Id
--  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock)  on [Questions].question_type_id=[QuestionTypes].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] with (nolock)  on [Assignments].assignment_type_id=[AssignmentTypes].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock)  on [Assignments].assignment_state_id=[AssignmentStates].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock)  on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
--  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock)  on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
--  left join [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)  on [Assignments].executor_organization_id=[Organizations].Id


--  where 
--  [AssignmentTypes].code=N'ToAttention' and [AssignmentStates].code=N'Registered'
--  and [Assignments].[executor_organization_id] in (select id from @Organizations_is)--=@organization_id
--  ),

--  nadoopr as
--  (
--  select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName

--  from 
--  [CRM_1551_Analitics].[dbo].[Assignments] with (nolock)  left join 
--  [CRM_1551_Analitics].[dbo].[Questions] with (nolock)  on [Assignments].question_id=[Questions].Id
--  left join [CRM_1551_Analitics].[dbo].[Appeals] with (nolock)  on [Questions].appeal_id=[Appeals].Id
--  left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock)  on [Appeals].receipt_source_id=[ReceiptSources].Id
--  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock)  on [Questions].question_type_id=[QuestionTypes].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] with (nolock)  on [Assignments].assignment_type_id=[AssignmentTypes].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock)  on [Assignments].assignment_state_id=[AssignmentStates].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock)  on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
--  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock)  on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
--  left join [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)  on [Assignments].executor_organization_id=[Organizations].Id

--  where 
--  [AssignmentStates].code=N'NotFulfilled' and ([AssignmentResults].code=N'ForWork' or [AssignmentResults].code=N'Actually')
--  and [Assignments].[executor_organization_id] in (select id from @Organizations_is)--=@organization_idd
--  ),

--  plan_p as
--  (
--  select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName

--  from 
--  [CRM_1551_Analitics].[dbo].[Assignments] 
--  inner join end_result on [Assignments].Id=end_result.assignment_id
--  inner join end_state on [Assignments].Id=end_state.assignment_id
 
--  left join [CRM_1551_Analitics].[dbo].[Questions] with (nolock)  on [Assignments].question_id=[Questions].Id
--  left join [CRM_1551_Analitics].[dbo].[Appeals] with (nolock)  on [Questions].appeal_id=[Appeals].Id
--  left join [CRM_1551_Analitics].[dbo].[ReceiptSources] with (nolock)  on [Appeals].receipt_source_id=[ReceiptSources].Id
--  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock)  on [Questions].question_type_id=[QuestionTypes].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentTypes]  with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] with (nolock)  on [Assignments].assignment_state_id=[AssignmentStates].Id
--  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] with (nolock)  on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
--  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] with (nolock)  on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
--  left join [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)  on [Assignments].executor_organization_id=[Organizations].Id
--  ),

--  main as 
--  (
--  select Id, N'nadiyshlo' name, OrganizationsId, OrganizationsName
--  from nadiishlo
--  union all
--  select Id, N'neVKompetentsii' name, OrganizationsId, OrganizationsName
--  from nevkomp
--  union all
--  select Id, N'prostrocheni' name, OrganizationsId, OrganizationsName
--  from prostr
--  union all
--  select Id, N'uvaga' name, OrganizationsId, OrganizationsName
--  from uvaga
--  union all
--  select Id, N'vroboti' name, OrganizationsId, OrganizationsName
--  from vroboti
--  union all
--  select Id, N'dovidoma' name, OrganizationsId, OrganizationsName
--  from dovidoma
--  union all
--  select Id, N'naDoopratsiyvanni' name, OrganizationsId, OrganizationsName
--  from nadoopr
--  union all
--  select Id, N'neVykonNeMozhl' name, OrganizationsId, OrganizationsName
--  from plan_p
--  )


-- select [OrganizationsId] [OrganizationId], [OrganizationsName] [OrganizationName], [nadiyshlo], 
-- [neVKompetentsii], [prostrocheni], [uvaga], [vroboti], [dovidoma], [naDoopratsiyvanni], [neVykonNeMozhl]
-- from main
-- pivot
-- (
-- count(Id) for name in ([nadiyshlo], [neVKompetentsii], [prostrocheni], [uvaga], [vroboti], [dovidoma], [naDoopratsiyvanni], [neVykonNeMozhl])
-- ) pvt
-- order by [OrganizationsId]
