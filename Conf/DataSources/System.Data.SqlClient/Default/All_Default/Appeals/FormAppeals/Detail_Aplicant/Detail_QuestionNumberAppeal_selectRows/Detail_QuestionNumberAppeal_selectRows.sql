  -- DECLARE @AppealRegistrationNumber NVARCHAR(50) = N'0-350';

IF(@AppealRegistrationNumber IS NULL)
BEGIN
	RETURN;
END

DECLARE @Archive NVARCHAR(400) = '['+(SELECT TOP 1 [IP]+'].['+[DatabaseName]+'].' FROM [dbo].[SetingConnetDatabase] WHERE Code = N'Archive');

DECLARE @IsHere BIT = IIF(
   (
      SELECT
         COUNT(1)
      FROM
         dbo.Appeals
      WHERE
         registration_number = @AppealRegistrationNumber
   ) = 0,
   0,
   1
);

IF(@IsHere = 1)
BEGIN
	SET @Archive = SPACE(0);
END

DECLARE @Query NVARCHAR(MAX) =
N'SELECT
     [Questions].[Id],
     [Questions].[registration_number] AS [Номер питання],
     [QuestionStates].[name] AS [Стан питання],
     [QuestionTypes].[name] AS [Тип питання],
     [Organizations].[name] AS [Виконавець],
     [Questions].registration_date AS [Дата та час реєстрації питання],
     [Questions].control_date AS [Дата контролю]
  FROM
   '+@Archive+N'[dbo].[Questions] Questions 
   LEFT JOIN [dbo].[QuestionTypes] QuestionTypes ON [QuestionTypes].Id = [Questions].question_type_id
   LEFT JOIN [dbo].[Objects] Objects ON [Objects].Id = [Questions].[object_id]
   LEFT JOIN [dbo].[Buildings] Buildings ON [Buildings].Id = [Objects].[builbing_id]
   LEFT JOIN [dbo].[Streets] Streets ON [Streets].Id = [Buildings].street_id
   LEFT JOIN [dbo].[StreetTypes] StreetTypes ON [StreetTypes].Id = [Streets].street_type_id
   LEFT JOIN [dbo].[Districts] Districts ON [Districts].Id = [Streets].district_id
   LEFT JOIN [dbo].[QuestionStates] QuestionStates ON [QuestionStates].Id = [Questions].question_state_id
   LEFT JOIN '+@Archive+N'[dbo].[Assignments] Assignments ON [Assignments].Id = [Questions].last_assignment_for_execution_id
   LEFT JOIN [dbo].[AssignmentResults] AssignmentResults ON [AssignmentResults].Id = [Assignments].AssignmentResultsId
   LEFT JOIN [dbo].[Organizations] Organizations ON [Organizations].Id = [Assignments].executor_organization_id
   LEFT JOIN '+@Archive+N'[dbo].[Appeals] Appeals ON [Appeals].Id = [Questions].appeal_id 
  WHERE
   [Appeals].[registration_number] = @AppealRegistrationNumber  ; ' ;

   EXEC sp_executesql @Query, N'@AppealRegistrationNumber NVARCHAR(50)', 
							  @AppealRegistrationNumber = @AppealRegistrationNumber;