     --DECLARE @Id INT = 2976530; 
    -- DECLARE @user_Id NVARCHAR(128) =N'0e3825fc-8a24-4fb2-97a9-28e1ed53b279'--'dc61a839-2cbc-4822-bfb5-5ca157487ced'; --'0e3825fc-8a24-4fb2-97a9-28e1ed53b279';

DECLARE @sertors NVARCHAR(max)=ISNULL((
SELECT stuff((SELECT N', '+LTRIM([Territories].Id)
  from [dbo].[Positions]
  INNER JOIN [dbo].[PersonExecutorChoose] ON [PersonExecutorChoose].position_id=[Positions].id
  INNER JOIN [dbo].[PersonExecutorChooseObjects] ON [PersonExecutorChooseObjects].person_executor_choose_id=[PersonExecutorChoose].Id
  INNER JOIN [dbo].[Territories] ON [PersonExecutorChooseObjects].object_id=[Territories].object_id
  where [Positions].programuser_id=@user_id  AND [Positions].role_id=8
  FOR XML PATH('')),1,2,N'')
  ),N'0')

  --SELECT @sertors

DECLARE @Archive NVARCHAR(400) = '['+(SELECT TOP 1 [IP]+'].['+[DatabaseName]+'].' FROM [dbo].[SetingConnetDatabase] WHERE Code = N'Archive');

DECLARE @IsHere BIT = IIF(
   (
      SELECT
         COUNT(1)
      FROM
         dbo.Assignments
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
N'DECLARE @org1761 TABLE (Id INT);

WITH
cte1
   AS ( SELECT Id,
         [parent_organization_id] ParentId
         FROM [dbo].[Organizations] t
         WHERE Id = 1761
         UNION ALL
         SELECT tp.Id,
         tp.[parent_organization_id] ParentId
         FROM [dbo].[Organizations] tp 
         INNER JOIN cte1 curr ON tp.[parent_organization_id] = curr.Id ),

org_user AS
(
SELECT organizations_id FROM [dbo].[Positions]
WHERE programuser_id = @user_id
)

INSERT INTO @org1761 (Id)
SELECT Id 
FROM cte1 INNER JOIN org_user ON cte1.Id=org_user.organizations_id;

SELECT TOP 1
	[Assignments].[Id]
   ,Questions.registration_number
   ,ReceiptSources.Id AS receipt_source_id
   ,ReceiptSources.name AS receipt_source_name
   ,Questions.registration_date AS que_reg_date
   ,Applicants.full_name
   ,Applicants.ApplicantAdress LiveAddress
   ,[Objects].Id AS [object_id]
   ,ISNULL(ObjectTypes.name + '' : '', N'''') +
	ISNULL([Objects].name + '' '', N'''') [object_name]

   ,ISNULL(sty.shortname + N'' '', N'''') +
	ISNULL(st.name + N'' '', N'''') +
	ISNULL(bl.name, N'''') address_problem

   ,Organizations.Id AS organization_id
   ,Organizations.name AS organization_name
   ,QuestionTypes.Id AS obj_type_id
   ,QuestionTypes.name AS obj_type_name
   ,Questions.question_content
   ,Questions.control_date
   ,[Assignments].[registration_date]
   ,ast.Id AS ass_state_id
   ,ast.name AS ass_state_name
   ,assR.name AS result_name
   ,assR.Id AS result_id
   ,assRn.name AS resolution_name
   ,assRn.Id AS resolution_id
   ,[Assignments].[execution_date]
   ,assC.short_answer
   ,Assignments.question_id
   ,aty.Id AS ass_type_id
   ,aty.name AS ass_type_name
   ,Assignments.main_executor
   ,perf.Id AS performer_id
   ,CASE
		WHEN LEN(perf.[head_name]) > 5 THEN perf.[head_name] + '' ( '' + perf.[short_name] + '')''
		ELSE perf.[short_name]
	END AS performer_name
   ,CASE
		WHEN LEN(responsible.[head_name]) > 5 THEN responsible.[head_name] + '' ( '' + responsible.[short_name] + '')''
		ELSE responsible.[short_name]
	END AS responsible_name
   ,responsible.Id AS responsible
   ,(SELECT
			current_assignment_consideration_id
		FROM '+@Archive+'[dbo].Assignments
		WHERE Id = @Id)
	AS assignmentConsiderations_id
   ,(SELECT
			COUNT(assg.main_executor)
		FROM [dbo].[Assignments] assg
		WHERE assg.question_id = Assignments.question_id
		AND assg.main_executor = 1
		AND assg.close_date IS NULL)
	AS is_aktiv_true
   ,(SELECT TOP 1
			control_comment
		FROM '+@Archive+'[dbo].AssignmentRevisions AS ar
		JOIN '+@Archive+'[dbo].AssignmentConsiderations AS ac
			ON ac.Id = ar.assignment_consideration_іd
		WHERE ac.assignment_id = @Id
		ORDER BY ar.Id DESC)
	AS control_comment
	,ISNULL((SELECT TOP 1 ar.rework_counter
	FROM '+@Archive+'[dbo].[Assignments] a
	INNER JOIN '+@Archive+'[dbo].[AssignmentConsiderations] ac ON a.Id=ac.assignment_id
	INNER JOIN '+@Archive+'[dbo].[AssignmentRevisions] ar ON ar.assignment_consideration_іd=ac.Id
	WHERE a.Id = @Id
	ORDER BY ar.Id DESC),0) rework_counter
   ,assC.[transfer_to_organization_id]

   ,CASE
		WHEN LEN(org_tr.[head_name]) > 5 THEN org_tr.[head_name] + '' ( '' + org_tr.[short_name] + '')''
		ELSE org_tr.[short_name]
	END transfer_name

   ,ast.Id AS old_assignment_state_id
   ,assR.Id AS old_assignment_result_id
   ,assRn.Id AS old_assignment_resolution_id
   ,[Assignments].current_assignment_consideration_id AS current_consid

   ,STUFF((SELECT
			N'','' + [phone_number]
		FROM [dbo].[ApplicantPhones] p
		WHERE p.applicant_id = [ApplicantPhones].[applicant_id]
		FOR XML PATH (''''))
	, 1, 1, N'''') phones ';
DECLARE @Part2 NVARCHAR(MAX) = 
 N',STUFF((SELECT
			N'', '' + [AnswerTypes].name + N''-'' +
			CASE
				WHEN q.[answer_phone] IS NOT NULL THEN q.[answer_phone]
				WHEN q.[answer_post] IS NOT NULL THEN q.[answer_post]
				WHEN q.[answer_mail] IS NOT NULL THEN q.[answer_mail]
			END
		FROM '+@Archive+'[dbo].[Assignments] a
		LEFT JOIN '+@Archive+'[dbo].[Questions] q
			ON a.question_id = q.Id 
		LEFT JOIN [dbo].[AnswerTypes] [AnswerTypes] 
			ON q.answer_form_id = [AnswerTypes].Id
		WHERE a.Id = [Assignments].Id
		FOR XML PATH (''''))
	, 1, 2, N'''') answer
   ,org_bal.short_name bal_name
   ,CASE
		WHEN [ReceiptSources].code = N''UGL'' THEN Appeals.[enter_number]
	END [enter_number]
   ,Assignments.edit_date AS date_in_form
   ,Assignments.executor_person_id

   ,CONCAT(p.[name], '' ('' + p.[position] + '')'') AS executor_person_name

   ,CASE
		WHEN EXISTS(SELECT Id FROM @org1761) THEN 1 
		WHEN orr.editable = N''true'' THEN 1
		WHEN [QuestionsInTerritory].[territory_id] IN ('+@sertors+N') THEN 1
		WHEN orr.editable = N''false'' THEN 2
	END editable
	,[Questions].[geolocation_lat]
	,[Questions].[geolocation_lon]
	,IIF(att.Id IS NOT NULL, 1, 0) AS attention_val
FROM '+@Archive+'[dbo].[Assignments] Assignments
INNER JOIN [dbo].AssignmentStates ast
	ON ast.Id = Assignments.assignment_state_id
INNER JOIN '+@Archive+'[dbo].Questions Questions
	ON Questions.Id = Assignments.question_id
INNER JOIN '+@Archive+'[dbo].Appeals Appeals
	ON Appeals.Id = Questions.appeal_id
LEFT JOIN [dbo].AssignmentTypes aty
	ON aty.Id = Assignments.assignment_type_id
LEFT JOIN [dbo].[QuestionsInTerritory] QuestionsInTerritory
	ON Questions.Id=QuestionsInTerritory.question_id
LEFT JOIN [dbo].QuestionTypes QuestionTypes
	ON QuestionTypes.Id = Questions.question_type_id
LEFT JOIN [dbo].ReceiptSources ReceiptSources
	ON ReceiptSources.Id = Appeals.receipt_source_id
LEFT JOIN [dbo].Applicants Applicants
	ON Applicants.Id = Appeals.applicant_id
LEFT JOIN [dbo].LiveAddress LiveAddress 
	ON LiveAddress.applicant_id = Applicants.Id
		AND LiveAddress.main = 1
LEFT JOIN [dbo].Buildings buil
	ON buil.Id = LiveAddress.building_id
LEFT JOIN [dbo].Streets stre
	ON stre.Id = buil.street_id
LEFT JOIN [dbo].Districts dis
	ON dis.Id = buil.district_id
LEFT JOIN [dbo].StreetTypes StreetTypes
	ON StreetTypes.Id = stre.street_type_id
LEFT JOIN [dbo].Organizations Organizations
	ON Organizations.Id = Questions.organization_id
LEFT JOIN [dbo].[Objects] [Objects] 
	ON [Objects].Id = Questions.[object_id]
LEFT JOIN [dbo].Buildings bl
	ON bl.Id = [Objects].builbing_id
LEFT JOIN [dbo].Streets st
	ON st.Id = bl.street_id
LEFT JOIN [dbo].StreetTypes sty
	ON sty.Id = st.street_type_id
LEFT JOIN [dbo].ObjectTypes [ObjectTypes] 
	ON ObjectTypes.Id = [Objects].object_type_id
LEFT JOIN '+@Archive+'[dbo].AssignmentConsiderations assC
	ON assC.Id = Assignments.current_assignment_consideration_id
LEFT JOIN [dbo].AssignmentResults assR
	ON assR.Id = Assignments.AssignmentResultsId
LEFT JOIN [dbo].AssignmentResolutions assRn
	ON assRn.Id = Assignments.AssignmentResolutionsId
LEFT JOIN '+@Archive+'[dbo].AssignmentRevisions assRev
	ON assRev.assignment_consideration_іd = assC.Id
LEFT JOIN [dbo].Organizations AS perf
	ON perf.Id = Assignments.executor_organization_id
LEFT JOIN [dbo].Organizations AS responsible
	ON responsible.Id = Assignments.organization_id
LEFT JOIN [dbo].Organizations AS org_tr
	ON org_tr.Id = assC.transfer_to_organization_id
LEFT JOIN [dbo].[ApplicantPhones] [ApplicantPhones] 
	ON Applicants.Id = [ApplicantPhones].applicant_id 
LEFT JOIN [dbo].[AttentionQuestionAndEvent] att 
	ON att.assignment_id = Assignments.Id 
	AND att.user_id = @user_Id ';
DECLARE @Part3 NVARCHAR(MAX) =
N'LEFT JOIN (SELECT
		[building_id]
	   ,[executor_id]
	FROM [dbo].[ExecutorInRoleForObject] ExecutorInRoleForObject 
	WHERE [executor_role_id] = 1 /*Балансоутримувач*/) balans
	ON bl.Id = balans.building_id
LEFT JOIN [dbo].[Organizations] org_bal
	ON balans.executor_id = org_bal.Id
LEFT JOIN dbo.[Positions] AS p
	ON p.Id = Assignments.executor_person_id
LEFT JOIN (SELECT DISTINCT
		o.organization_id
	   ,o.editable
	FROM [dbo].[Positions] p
INNER JOIN [dbo].[OrganizationInResponsibilityRights] o
		ON p.Id = o.position_id
WHERE p.[programuser_id] = @user_Id
) orr
	ON perf.Id = orr.organization_id
WHERE Assignments.Id = @Id
AND (CASE WHEN EXISTS(SELECT Id FROM @org1761) THEN 1 

WHEN [QuestionsInTerritory].[territory_id] IN ('+@sertors+N') THEN 1

WHEN orr.editable IS NULL THEN 2 

ELSE 1 END)=1; ' ;

DECLARE @Query NVARCHAR(MAX) = (SELECT @Part1 + @Part2 + @Part3);
EXEC sp_executesql @Query, N'@Id INT, @user_Id NVARCHAR(128)',
							@Id = @Id,
							@user_Id = @user_Id ;