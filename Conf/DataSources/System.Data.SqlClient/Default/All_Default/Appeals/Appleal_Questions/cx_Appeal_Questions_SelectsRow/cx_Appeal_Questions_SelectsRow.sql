--declare @Id int = 6690178;
SELECT
	[Questions].[Id],
	[Questions].[registration_number],
	[Questions].[Id] AS ques_id,
	Appeals.registration_number AS app_registration_number,
	Questions.appeal_id,
	Applicants.full_name,
	Applicants.Id AS appl_id,
	QuestionStates.name AS question_state_name,
	QuestionStates.Id AS question_state_id,
	QuestionTypes.Id AS question_type_id,
	QuestionTypes.name AS question_type_name,
	[Questions].[control_date],
	[Questions].[question_content],
	[Objects].Id AS [object_id],
	isnull(ObjectTypes.name + N' : ', N'') + isnull([Objects].Name + ' ', N'') [object_name] 
,
	isnull(Districts.name + N' р-н., ', N'') + isnull(StreetTypes.shortname + N' ', N'') + isnull(Streets.name + N' ', N'') + isnull(Buildings.name, N'') address_problem,
	ObjectTypes.name AS object_type_name,
	Districts.name AS districts_name,
	Districts.Id AS districts_id,
	[Questions].[object_comment],
	[Questions].[application_town_id],
	Organizations.Id AS organization_id,
	Organizations.[short_name] AS organization_name,
	AnswerTypes.Id AS answer_type_id,
	AnswerTypes.name AS answer_type_name,
	[Questions].[answer_phone],
	[Questions].[answer_post],
	[Questions].[answer_mail],
	Questions.event_id,
	[Questions].[registration_date],
	[Questions].[user_id],
	[Questions].[edit_date],
	[Questions].[user_edit_id],
	perfom.Id AS perfom_id 
,
	IIF (
		len(perfom.[head_name]) > 5,
		concat(
			perfom.[head_name],
			' ( ',
			perfom.[short_name],
			')'
		),
		perfom.[short_name]
	) AS perfom_name,
	assR.Id AS ass_result_id,
	assR.name AS ass_result_name,
	assRn.Id AS ass_resolution_id,
	assRn.name AS ass_resolution_name,
	Questions.Id AS question_id,
	isnull([User].[FirstName], N'') + N' ' + isnull([User].[LastName], N' ') [user_name],
(
		SELECT
			top 1 CASE
				WHEN assignment_state_id = 1 THEN 1
				ELSE 0
			END
		FROM
			Assignments
		WHERE
			question_id = @Id
			AND main_executor = 1
	) AS flag_is_state
	,[Questions].[geolocation_lat]
	,[Questions].[geolocation_lon],
	Appeals.receipt_source_id 
FROM
	[dbo].[Questions]
	LEFT JOIN [dbo].[Appeals] ON Appeals.Id = Questions.appeal_id
	LEFT JOIN [dbo].[Applicants] ON Applicants.Id = Appeals.applicant_id
	LEFT JOIN [dbo].[QuestionStates] ON QuestionStates.Id = Questions.question_state_id
	LEFT JOIN [dbo].[QuestionTypes] ON QuestionTypes.Id = Questions.question_type_id
	LEFT JOIN [dbo].[AnswerTypes] ON AnswerTypes.Id = Questions.answer_form_id
	LEFT JOIN [dbo].[Organizations] ON Organizations.Id = Questions.organization_id
	LEFT JOIN [Objects] ON [Objects].Id = Questions.[object_id]
	LEFT JOIN [dbo].[Buildings] ON Buildings.Id = [Objects].builbing_id
	LEFT JOIN [dbo].[Streets] ON Streets.Id = Buildings.street_id
	LEFT JOIN [dbo].[StreetTypes] ON StreetTypes.Id = Streets.street_type_id
	LEFT JOIN [dbo].[ObjectTypes] ON ObjectTypes.Id = [Objects].object_type_id
	LEFT JOIN [dbo].[Districts] ON Districts.Id = [Buildings].district_id
	LEFT JOIN [dbo].[Assignments] ON Assignments.question_id = Questions.Id
	AND Assignments.main_executor = 1 
	LEFT JOIN [dbo].[AssignmentConsiderations] assC ON assC.Id = Assignments.current_assignment_consideration_id
	LEFT JOIN [dbo].[AssignmentResults] assR ON assR.Id = Assignments.AssignmentResultsId
	LEFT JOIN [dbo].[AssignmentResolutions] assRn ON assRn.Id = Assignments.AssignmentResolutionsId
	LEFT JOIN [dbo].[Organizations] perfom ON perfom.Id = Assignments.[executor_organization_id]
	LEFT JOIN [#system_database_name#].[dbo].[User] ON [Questions].[user_id] = [User].UserId
WHERE
	[Questions].[Id] = @Id