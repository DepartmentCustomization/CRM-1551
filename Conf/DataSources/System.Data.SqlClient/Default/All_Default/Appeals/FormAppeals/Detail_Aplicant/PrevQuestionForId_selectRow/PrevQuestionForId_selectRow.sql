-- DECLARE @QuestionId INT = 6690305;

DECLARE @Archive NVARCHAR(MAX) = '['+(SELECT TOP 1 [IP]+'].['+[DatabaseName]+'].' FROM [dbo].[SetingConnetDatabase] WHERE Code = N'Archive');

DECLARE @IsHere BIT = IIF(
   (
      SELECT
         COUNT(1)
      FROM
         dbo.Questions 
      WHERE
         Id = @QuestionId
   ) = 0,
   0,
   1
);

IF(@IsHere = 1)
BEGIN
	SET @Archive = SPACE(1);
END

DECLARE @Query NVARCHAR(MAX) = N'
SELECT
  [Questions].[Id],
  [Questions].[appeal_id],
  [Questions].[registration_number] AS [Номер питання],
  [QuestionTypes].[name] AS [Тип питання],
  [Organizations_Execut].name AS [Виконавець],
  [Questions].[control_date] AS [Дата контролю],
  [QuestionTypes].[name] AS [QuestionTypesName],
  [Objects].Id AS [ObjectId],
  isnull([StreetTypes].shortname, SPACE(0)) + SPACE(1) + isnull([Streets].name, SPACE(0)) + SPACE(1) + isnull([Buildings].name, SPACE(0)) AS [ObjectName],
  [Questions].organization_id,
  [Organizations].name AS organization_name,
  [Questions].question_content,
  [Questions].question_type_id,
  [Questions].[last_assignment_for_execution_id],
  [Questions].[last_assignment_for_execution_id] AS [last_assignment_for_execution_name],
  [Questions].question_state_id,
  [QuestionStates].[name] AS question_state_name,
  [AssignmentResults].name AS result,
  NULL AS last_assignment_for_execution_comment,
  [AssignmentResolutions].[name] AS [AssignmentResolutionsName],
  [Applicants].[full_name] AS [ApplicantPIB],
  [Applicants].[ApplicantAdress]
FROM
  '+@Archive+N'[dbo].[Questions] [Questions]
  LEFT JOIN [dbo].[QuestionTypes] [QuestionTypes] ON [QuestionTypes].Id = [Questions].question_type_id
  LEFT JOIN [dbo].[Objects] [Objects] ON [Objects].Id = [Questions].[object_id]
  LEFT JOIN [dbo].[Buildings] [Buildings] ON [Buildings].Id = [Objects].[builbing_id]
  LEFT JOIN [dbo].[Streets] [Streets] ON [Streets].Id = [Buildings].street_id
  LEFT JOIN [dbo].[StreetTypes] [StreetTypes] ON [StreetTypes].Id = [Streets].street_type_id
  LEFT JOIN [dbo].[Districts] [Districts] ON [Districts].Id = [Streets].district_id
  LEFT JOIN [dbo].[QuestionStates] [QuestionStates] ON [QuestionStates].Id = [Questions].question_state_id
  LEFT JOIN [dbo].[Organizations] [Organizations] ON [Organizations].Id = [Questions].organization_id
  LEFT JOIN '+@Archive+N'[dbo].[Appeals] [Appeals] ON [Appeals].Id = [Questions].[appeal_id]
  LEFT JOIN [dbo].[Applicants] [Applicants] ON [Applicants].Id = [Appeals].[applicant_id] 
  LEFT JOIN '+@Archive+N'[dbo].[Assignments] [Assignments] ON [Assignments].[question_id] = [Questions].[Id]
    AND [Assignments].[main_executor] = 1
  LEFT JOIN [dbo].[AssignmentResolutions] [AssignmentResolutions] ON AssignmentResolutions.Id = Assignments.AssignmentResolutionsId
  LEFT JOIN [dbo].[AssignmentResults] [AssignmentResults] ON [AssignmentResults].Id = [Assignments].AssignmentResultsId
  LEFT JOIN [dbo].[Organizations] [Organizations_Execut] ON [Organizations_Execut].Id = [Assignments].executor_organization_id
WHERE 
  [Questions].[Id] = @QuestionId ;
  ' ;

EXEC sp_executesql @Query, N'@QuestionId INT', @QuestionId = @QuestionId;