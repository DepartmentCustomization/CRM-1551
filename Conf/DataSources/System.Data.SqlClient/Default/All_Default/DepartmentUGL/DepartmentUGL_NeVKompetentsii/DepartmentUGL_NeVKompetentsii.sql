--  DECLARE @user_id NVARCHAR(300)=N'871e2902-8915-4a07-95af-101c05092dab';

DECLARE @role NVARCHAR(500) = (
	SELECT
		[Roles].[name]
	FROM
		[dbo].[Positions] [Positions]
		LEFT JOIN [dbo].[Roles] [Roles] ON [Positions].role_id = [Roles].Id 
	WHERE
		[Positions].programuser_id = @user_id
);

DECLARE @quere_code NVARCHAR(max)=N'

with
main as
(
select 
	[Assignments].Id, 
	[Organizations].Id OrganizationsId, 
	[Organizations].name OrganizationsName,
	[Applicants].full_name zayavnyk, [StreetTypes].shortname+N'' ''+Streets.name+N'', ''+[Buildings].name adress, [Questions].registration_number,
	[QuestionTypes].name QuestionType,
	[Applicants].Id zayavnikId, [Questions].Id QuestionId, [Applicants].full_name zayavnikName, 
	case when len([Organizations].[head_name]) > 5 
		then [Organizations].[head_name] + '' ( '' + [Organizations].[short_name] + '')''
		else [Organizations].[short_name] end as vykonavets, 
	[AssignmentConsiderations].short_answer, 
	[Questions].question_content, 
	[Applicants].[ApplicantAdress] adressZ,
	[Organizations2].Id [transfer_to_organization_id],
	[Organizations2].[short_name] [transfer_to_organization_name]
from [Assignments] 
left join [Questions] on [Assignments].question_id=[Questions].Id
left join [Appeals] on [Questions].appeal_id=[Appeals].Id
left join [ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
left join [AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
left join [AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [AssignmentConsiderations] on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
left join [AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id
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
where [AssignmentStates].code in (''Registered'', N''OnCheck'')  
and AssignmentResults.code = (N''NotInTheCompetence'')
and [ReceiptSources].code=N''UGL'')

select 
	Id, 
	registration_number, 
	QuestionType, 
	zayavnikName, 
	adress, 
	vykonavets, 
	QuestionId, 
	zayavnikId, 
	short_answer, 
	question_content, 
	adressZ, 
	[transfer_to_organization_id], 
	[transfer_to_organization_name]
from main 
order by Id desc;
';

EXEC(@quere_code);