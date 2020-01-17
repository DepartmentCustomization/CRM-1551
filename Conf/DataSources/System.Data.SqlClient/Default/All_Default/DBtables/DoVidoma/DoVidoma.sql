/*
declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
declare @organization_id int =2350;
declare @navigation nvarchar(400)=N'Інші доручення';
*/
declare @NavigationTable table(Id nvarchar(400));

if @navigation=N'Усі'
	begin
		insert into @NavigationTable (Id)
		select N'Інші доручення' n union all select N'УГЛ' n union all
		select N'Зауваження' n union all select N'Електронні джерела' n union all select N'Пріоритетне'
	end 
else 
	begin
		insert into @NavigationTable (Id)
		select @navigation
	end;

/*
declare @Organization table(Id int);



declare @OrganizationId int = 
case 
when @organization_id is not null
then @organization_id
else (select Id
  from [CRM_1551_Analitics].[dbo].[Organizations]
  where Id in (select organization_id
  from [CRM_1551_Analitics].[dbo].[Workers]
  where worker_user_id=@user_id))
 end


declare @IdT table (Id int);

-- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
insert into @IdT(Id)
select Id from [CRM_1551_Analitics].[dbo].[Organizations] 
where (Id=@OrganizationId or [parent_organization_id]=@OrganizationId) and Id not in (select Id from @IdT)

--  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
while (select count(id) from (select Id from [CRM_1551_Analitics].[dbo].[Organizations]
where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
and Id not in (select Id from @IdT)) q)!=0
begin

insert into @IdT
select Id from [CRM_1551_Analitics].[dbo].[Organizations]
where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
and Id not in (select Id from @IdT)
end 

insert into @Organization (Id)
select Id from @IdT;
  */
 with

main as
(
select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].name OrganizationsName,
[Applicants].full_name zayavnyk, 
--[StreetTypes].shortname+N' '+Streets.name+N', '+[Buildings].name adress, 
isnull([Districts].name+N' р-н, ', N'')
  +isnull([StreetTypes].shortname, N'')
  +isnull([Streets].name,N'')
  +isnull(N', '+[Buildings].name,N'')
  +isnull(N', п. '+[Questions].[entrance], N'')
  +isnull(N', кв. '+[Questions].flat, N'') adress,
[Questions].registration_number,
[QuestionTypes].name QuestionType,
case when [ReceiptSources].code=N'UGL' then N'УГЛ' 
when [ReceiptSources].code=N'Website_mob.addition' then N'Електронні джерела'
when [QuestionTypes].emergency=N'true' then N'Пріоритетне'
when [QuestionTypes].parent_organization_is=N'true' then N'Зауваження'
else N'Інші доручення'
end navigation,

 case when [AssignmentTypes].code=N'ToAttention' and [AssignmentStates].code=N'Registered' then 1 else 0 end dovidima,
 /*
 case when [AssignmentStates].code=N'NotFulfilled' and [AssignmentResults].code=N'ForWork' then 1 else 0 end naDoopratsiyvanni,
 case when [AssignmentStates].code=N'NotFulfilled' and [AssignmentResults].code=N'ItIsNotPossibleToPerformThisPeriod' then 1 else 0 end neVykonNeMozhl,
 null NotUse,*/ [Applicants].Id zayavnykId, [Questions].Id QuestionId
  , [Applicants].[ApplicantAdress] zayavnyk_adress, [Questions].question_content zayavnyk_zmist
  ,[Organizations3].short_name balans_name

from 
[CRM_1551_Analitics].[dbo].[Assignments] left join 
[CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
left join [CRM_1551_Analitics].[dbo].[Appeals] on [Questions].appeal_id=[Appeals].Id
left join [CRM_1551_Analitics].[dbo].[ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
--left join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [Assignments].Id=[AssignmentConsiderations].assignment_id
left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left join [CRM_1551_Analitics].[dbo].[Organizations] on [Assignments].executor_organization_id=[Organizations].Id
left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].[object_id]=[Objects].Id
left join [CRM_1551_Analitics].[dbo].[Buildings] on [Objects].builbing_id=[Buildings].Id
left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=[Streets].Id
left join [CRM_1551_Analitics].[dbo].[StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
left join [CRM_1551_Analitics].[dbo].[Applicants] on [Appeals].applicant_id=[Applicants].Id
 left join [CRM_1551_Analitics].[dbo].[Districts] on [Buildings].district_id=[Districts].Id

 left join (select [building_id], [executor_id]
  from [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
  where [executor_role_id]=1 /*Балансоутримувач*/) balans on [Buildings].Id=balans.building_id

left join [CRM_1551_Analitics].[dbo].[Organizations] [Organizations3] on balans.executor_id=[Organizations3].Id

--left join [CRM_1551_Analitics].[dbo].[AssignmentRevisions] on [AssignmentResolutions].Id=[AssignmentRevisions].assignment_resolution_id
where [Assignments].[executor_organization_id]=@organization_id
),

nav as 
(
select 1 Id, N'УГЛ' name union all select 2 Id, N'Електронні джерела' name union all select 3	Id, N'Пріоритетне' name union all select 4 Id, N'Інші доручення' name union all select 5 Id, N'Зауваження' name 
)

select Id, registration_number, QuestionType, zayavnyk, adress, zayavnykId, QuestionId--, null vykonavets
, zayavnyk_adress, zayavnyk_zmist, balans_name
 from main where dovidima=1 --navigation, registration_number, from main
and navigation in (select Id from @NavigationTable)
--select nav.name from nav left join main on nav.name=main.navigation