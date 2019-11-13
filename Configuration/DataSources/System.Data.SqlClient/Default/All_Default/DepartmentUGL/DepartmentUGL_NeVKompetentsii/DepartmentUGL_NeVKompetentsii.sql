/*
declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
*/

  declare @role nvarchar(500)=
  (select [Roles].name
  from [Positions]
  left join [Roles] on [Positions].role_id=[Roles].Id
  where [Positions].programuser_id=@user_id);

------

 -- declare @user_id nvarchar(128)=N'Вася';
  --29796543-b903-48a6-9399-4840f6eac396



declare @quere_code nvarchar(max)=N'

 with

main as
(
select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].name OrganizationsName,
[Applicants].full_name zayavnyk, [StreetTypes].shortname+N'' ''+Streets.name+N'', ''+[Buildings].name adress, [Questions].registration_number,
[QuestionTypes].name QuestionType,

 [Applicants].Id zayavnikId, [Questions].Id QuestionId, [Applicants].full_name zayavnikName
--  , [Organizations].short_name vykonavets
 , case when len([Organizations].[head_name]) > 5 then [Organizations].[head_name] + '' ( '' + [Organizations].[short_name] + '')''
					else [Organizations].[short_name] end as vykonavets
 , [AssignmentConsiderations].short_answer, [Questions].question_content, 
[Applicants].[ApplicantAdress] adressZ

 ,[Organizations2].Id [transfer_to_organization_id]
 ,[Organizations2].[short_name] [transfer_to_organization_name]
 
from 
[Assignments] left join 
[Questions] on [Assignments].question_id=[Questions].Id
left join [Appeals] on [Questions].appeal_id=[Appeals].Id
left join [ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
left join [AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
left join [AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
-- left join [AssignmentConsiderations] on [Assignments].Id=[AssignmentConsiderations].assignment_id
left join [AssignmentConsiderations] on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
left join [AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
left join [AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left join [Organizations] on [Assignments].executor_organization_id=[Organizations].Id
left join [Objects] on [Questions].[object_id]=[Objects].Id
left join [Buildings] on [Objects].builbing_id=[Buildings].Id
left join [Streets] on [Buildings].street_id=[Streets].Id
left join [Applicants] on [Appeals].applicant_id=[Applicants].Id
left join [StreetTypes] on [Streets].street_type_id=[StreetTypes].Id



left join [Organizations] [Organizations2] on [AssignmentConsiderations].[transfer_to_organization_id]=[Organizations2].Id

left join [Buildings] [Buildings5] on [Objects].builbing_id=[Buildings5].Id
left join [Districts] [Districts5] on [Buildings5].district_id=[Districts5].Id
where 
([AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code<>N''Closed'' and [AssignmentResults].code=N''NotInTheCompetence''
  and [AssignmentResolutions].name in (N''Повернуто в 1551'', N''Повернуто в батьківську організацію'') and [AssignmentConsiderations].[turn_organization_id] is not null) 

  and (case when '''+@role+N'''=N''Конролер'' and [AssignmentResolutions].name=N''Повернуто в 1551'' then 1
  when '''+@role+N'''<>N''Конролер'' and [AssignmentResolutions].name=N''Повернуто в батьківську організацію''
  then 1 end)=1

)

select Id, /*navigation, */registration_number, QuestionType, zayavnikName, adress, vykonavets, QuestionId, zayavnikId--zayavnyk, adress, null vykonavets
, short_answer, question_content, adressZ, [transfer_to_organization_id], [transfer_to_organization_name]

 from main 
order by Id desc
'

exec(@quere_code)