 --declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
 --declare @organization_id int =4013;
 --declare @navigation nvarchar(400)=N'Усі';

 declare @role nvarchar(500)=
  (select [Roles].name
  from [CRM_1551_Analitics].[dbo].[Positions]
  left join [CRM_1551_Analitics].[dbo].[Roles] on [Positions].role_id=[Roles].Id
  where [Positions].programuser_id=@user_id)

declare @Organization table(Id int);


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

with
main as
(
  select [Assignments].Id,
case when [ReceiptSources].code=N'UGL' then N'УГЛ' 
when [ReceiptSources].code=N'Website_mob.addition' then N'Електронні джерела'
when [QuestionTypes].emergency=N'true' then N'Пріоритетне'
when [QuestionTypes].parent_organization_is=N'true' then N'Зауваження'
else N'Інші доручення'
end navigation,
[Questions].registration_number, [QuestionTypes].name QuestionType,
[Applicants].full_name zayavnyk, [StreetTypes].shortname+N' '+Streets.name+N', '+[Buildings].name adress_place
 ,[Organizations].name pidlegliy, 
[Applicants].Id zayavnikId, [Questions].Id QuestionId,
[Assignments].Id as Id2
 , [Applicants].[ApplicantAdress] zayavnyk_adress, [Questions].question_content zayavnyk_zmist,
 [AssignmentConsiderations].short_answer comment
  ,[Organizations2].Id [transfer_to_organization_id]
 ,[Organizations2].[short_name] [transfer_to_organization_name]
 ,stuff ((select N', '+[Organizations].short_name
from [ExecutorInRoleForObject] inner join [Organizations] on [ExecutorInRoleForObject].executor_id=[Organizations].Id
where [ExecutorInRoleForObject].object_id=[Buildings].Id--ex.building_id
and [executor_role_id]=1 /*Балансоутримувач*/
for xml path('')),1,2,N'') balans_name

 --,[Organizations3].short_name balans_name
  from [CRM_1551_Analitics].[dbo].[Assignments]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
left join [CRM_1551_Analitics].[dbo].[Appeals] on [Questions].appeal_id=[Appeals].Id
left join [CRM_1551_Analitics].[dbo].[ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
-- left join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [Assignments].Id=[AssignmentConsiderations].assignment_id
left join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
  left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].[object_id]=[Objects].Id

  left join [CRM_1551_Analitics].[dbo].[Applicants] on [Appeals].applicant_id=[Applicants].Id
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Assignments].executor_organization_id=[Organizations].Id

  left join [CRM_1551_Analitics].[dbo].[Buildings] on [Objects].builbing_id=[Buildings].Id
  left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=[Streets].Id
  left join [CRM_1551_Analitics].[dbo].[StreetTypes] on [Streets].street_type_id=[StreetTypes].id
  left join [CRM_1551_Analitics].[dbo].[Organizations] [Organizations2] on [AssignmentConsiderations].[transfer_to_organization_id]=[Organizations2].Id

 -- left join (select  [building_id], [executor_id]
 -- from [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
 -- where [executor_role_id]=1 /*Балансоутримувач*/) balans on [Buildings].Id=balans.building_id

--left join [CRM_1551_Analitics].[dbo].[Organizations] [Organizations3] on balans.executor_id=[Organizations3].Id

  where 
  
--   [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code<>N'Closed' and [AssignmentResults].code=N'NotInTheCompetence'
--   --and ([AssignmentResolutions].code=N'ReturnedIn1551' or [AssignmentResolutions].code=N'ReturnedToParentOrganization')
--   and [AssignmentResolutions].name in (N'Повернуто в 1551', N'Повернуто в батьківську організацію')
--   and (case when @role=N'Конролер' and [AssignmentResolutions].name=N'Повернуто в 1551' then 1
--   when @role<>N'Конролер' and [AssignmentResolutions].name=N'Повернуто в батьківську організацію'
--   then 1 end)=1

--   and [AssignmentConsiderations].turn_organization_id=@organization_id --and executor_organization_id in (select Id from @Organization)
  [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code<>N'Closed' and [AssignmentResults].code=N'NotInTheCompetence'
  and [AssignmentResolutions].name in (N'Повернуто в 1551', N'Повернуто в батьківську організацію')
  and (case when @role=N'Конролер' and [AssignmentResolutions].name=N'Повернуто в 1551' then 1
  when @role<>N'Конролер' and [AssignmentResolutions].name=N'Повернуто в батьківську організацію'
  then 1 end)=1

  and [AssignmentConsiderations].turn_organization_id=@organization_id
  )

  select Id, navigation, registration_number, QuestionType, zayavnyk, adress_place, pidlegliy, zayavnikId, QuestionId, Id2, zayavnyk_adress,
  zayavnyk_zmist, comment, [transfer_to_organization_id], [transfer_to_organization_name], [balans_name]
  from main
  where navigation in (select Id from @NavigationTable)

