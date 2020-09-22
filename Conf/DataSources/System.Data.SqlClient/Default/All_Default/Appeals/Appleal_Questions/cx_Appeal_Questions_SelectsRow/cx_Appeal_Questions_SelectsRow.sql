--   DECLARE @Id INT = 6696053;

DECLARE @Archive NVARCHAR(400) = '['+(SELECT TOP 1 [IP]+'].['+[DatabaseName]+'].' FROM [dbo].[SetingConnetDatabase] WHERE Code = N'Archive');

DECLARE @IsHere BIT = IIF(
   (
      SELECT
         COUNT(1)
      FROM
         dbo.Questions
      WHERE
         Id = @Id
   ) = 0,
   0,
   1
);

IF(@IsHere = 1)
BEGIN
	SET @Archive = SPACE(0);
END
DECLARE @Part1 NVARCHAR(MAX) = 
N'SELECT
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
	isnull(ObjectTypes.name + N'' : '', N'''') + isnull([Objects].Name + N'' '', N'''') [object_name],
	isnull(Districts.name + N'' р-н.'', N'', '') + isnull(StreetTypes.shortname + N'' '', N'''') + isnull(Streets.name + N'' '', N'''') + isnull(Buildings.name, N'''') address_problem,
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
			'' ( '',
			perfom.[short_name],
			'')''
		),
		perfom.[short_name]
	) AS perfom_name,
	assR.Id AS ass_result_id,
	assR.name AS ass_result_name,
	assRn.Id AS ass_resolution_id,
	assRn.name AS ass_resolution_name,
	Questions.Id AS question_id,
	isnull([User].[FirstName], N'''') + N'' '' + isnull([User].[LastName], N'' '') [user_name],
(
		SELECT
			TOP 1 CASE
				WHEN assignment_state_id = 1 THEN 1
				ELSE 0
			END
		FROM
			'+@Archive+N'dbo.Assignments
		WHERE
			question_id = @Id
			AND main_executor = 1
	) AS flag_is_state,
	Questions.geolocation_lat,
	Questions.geolocation_lon,
	Appeals.receipt_source_id,
	IIF(att.Id IS NOT NULL, 1, 0) AS attention_val
FROM ';
DECLARE @Part2 NVARCHAR(MAX) =
	N''+@Archive+N'[dbo].[Questions] Questions
	LEFT JOIN '+@Archive+N'[dbo].[Appeals] Appeals ON Appeals.Id = Questions.appeal_id
	LEFT JOIN [dbo].[Applicants] Applicants ON Applicants.Id = Appeals.applicant_id
	LEFT JOIN [dbo].[QuestionStates]  QuestionStates ON QuestionStates.Id = Questions.question_state_id 
	LEFT JOIN [dbo].[QuestionTypes] QuestionTypes ON QuestionTypes.Id = Questions.question_type_id
	LEFT JOIN [dbo].[AnswerTypes] AnswerTypes ON AnswerTypes.Id = Questions.answer_form_id
	LEFT JOIN [dbo].[Organizations] Organizations ON Organizations.Id = Questions.organization_id
	LEFT JOIN [dbo].[Objects] [Objects] ON [Objects].Id = Questions.[object_id]
	LEFT JOIN [dbo].[Buildings] Buildings ON Buildings.Id = [Objects].builbing_id
	LEFT JOIN [dbo].[Streets] Streets ON Streets.Id = Buildings.street_id
	LEFT JOIN [dbo].[StreetTypes] StreetTypes ON StreetTypes.Id = Streets.street_type_id
	LEFT JOIN [dbo].[ObjectTypes] ObjectTypes ON ObjectTypes.Id = [Objects].object_type_id
	LEFT JOIN [dbo].[Districts] Districts ON Districts.Id = [Buildings].district_id
	LEFT JOIN '+@Archive+N'[dbo].[Assignments] Assignments ON Assignments.question_id = Questions.Id
	AND Assignments.main_executor = 1 
	LEFT JOIN '+@Archive+N'[dbo].[AssignmentConsiderations] assC ON assC.Id = Assignments.current_assignment_consideration_id
	LEFT JOIN [dbo].[AssignmentResults] assR ON assR.Id = Assignments.AssignmentResultsId
	LEFT JOIN '+@Archive+N'[dbo].[AssignmentResolutions] assRn ON assRn.Id = Assignments.AssignmentResolutionsId
	LEFT JOIN [dbo].[Organizations] perfom ON perfom.Id = Assignments.[executor_organization_id]
	LEFT JOIN [dbo].[AttentionQuestionAndEvent] att ON att.question_id = Questions.Id
	AND att.user_id = @user_id 
	LEFT JOIN [#system_database_name#].[dbo].[User]  [User] ON [Questions].[user_id] = [User].UserId
WHERE
	[Questions].[Id] = @Id ; ';

DECLARE @Query NVARCHAR(MAX) = (SELECT @Part1 + @Part2);
EXEC sp_executesql @Query, N'@Id INT, @user_id NVARCHAR(128)', 
							@Id = @Id,
							@user_id = @user_id;