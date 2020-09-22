  --DECLARE @Id INT = 277; 

IF OBJECT_ID('tempdb..#PurposeQuestions') IS NOT NULL
BEGIN
	DROP TABLE #PurposeQuestions;
END

CREATE TABLE #PurposeQuestions (Id INT, 
							    question_number NVARCHAR(20),
							    question_reg_date DATETIME,
							    question_types_name NVARCHAR(500),
								question_objects_name NVARCHAR(MAX),
								performer_name NVARCHAR(500)
								) WITH (DATA_COMPRESSION = PAGE);
INSERT INTO #PurposeQuestions
SELECT Questions.[Id]
	  , Questions.registration_number AS question_number
      , Questions.[registration_date] AS question_reg_date
	  , QuestionTypes.name AS question_types_name
	  , [Objects].name AS question_objects_name
	  , Organizations.short_name AS performer_name
FROM [dbo].[Events] AS e
	LEFT JOIN [dbo].[EventQuestionsTypes] eqt ON e.Id=eqt.[event_id]
	LEFT JOIN [dbo].[EventObjects] EventObjects ON EventObjects.event_id = e.Id
	INNER JOIN [dbo].[Questions] Questions ON Questions.question_type_id = eqt.question_type_id
		AND Questions.[object_id] = EventObjects.[object_id]
		AND Questions.event_id IS NULL
	LEFT JOIN [dbo].[Assignments] Assignments ON Assignments.Id = Questions.last_assignment_for_execution_id
	LEFT JOIN [dbo].[Organizations] Organizations ON Organizations.Id = Assignments.executor_organization_id
	LEFT JOIN [dbo].[QuestionTypes] QuestionTypes ON QuestionTypes.Id = Questions.question_type_id
	LEFT JOIN [dbo].[Objects] Objects ON [Objects].Id = Questions.[object_id]
	WHERE e.Id = @Id;

DECLARE @temp_CopyData BIT;

SELECT 
	@temp_CopyData = IIF(COUNT(1) = 0, 0, 1)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = N'dbo'
AND TABLE_NAME = N'QuestionsFromCopeWithoutEvent_temp';

IF (@temp_CopyData = 1)
BEGIN
INSERT INTO #PurposeQuestions
SELECT copy_data.[question_id]
	  , copy_data.[registration_number] AS question_number
      , copy_data.[registration_date] AS question_reg_date
	  , QuestionTypes.name AS question_types_name
	  , [Objects].name AS question_objects_name
	  , Organizations.short_name AS performer_name
FROM [dbo].[Events] AS e WITH (NOLOCK)
	LEFT JOIN [dbo].[EventQuestionsTypes] eqt ON e.Id=eqt.[event_id]
	LEFT JOIN [dbo].[EventObjects] EventObjects WITH (NOLOCK) ON EventObjects.event_id = e.Id
	INNER JOIN [dbo].[QuestionsFromCopeWithoutEvent_temp] copy_data ON copy_data.question_type_id = eqt.question_type_id
		AND copy_data.[object_id] = EventObjects.[object_id]
		AND copy_data.event_id IS NULL
	LEFT JOIN [dbo].[Organizations] Organizations ON Organizations.Id = copy_data.executor_organization_id
	LEFT JOIN [dbo].[QuestionTypes] QuestionTypes ON QuestionTypes.Id = copy_data.question_type_id
	LEFT JOIN [dbo].[Objects] Objects WITH (NOLOCK) ON [Objects].Id = copy_data.[object_id]
	WHERE e.Id = @Id; 
END

SELECT 
DISTINCT
	Id, 
	question_number,
	question_reg_date,
	question_types_name,
	question_objects_name,
	performer_name
FROM #PurposeQuestions
ORDER BY 1
OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY;