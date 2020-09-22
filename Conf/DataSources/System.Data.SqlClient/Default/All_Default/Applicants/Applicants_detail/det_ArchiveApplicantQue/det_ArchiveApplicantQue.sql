-- DECLARE @ApplicantsId INT = 27;

DECLARE @Archive NVARCHAR(400) = '['+(SELECT TOP 1 [IP]+'].['+[DatabaseName]+'].' FROM [dbo].[SetingConnetDatabase] WHERE Code = N'Archive');

DECLARE @Query NVARCHAR(MAX) = 
N'SELECT
  [Questions].Id,
  Questions.registration_number,
  [Questions].[registration_date],
  [QuestionStates].name AS QuestionStates,
  [QuestionTypes].name AS QuestionType,
  [Questions].control_date,
  Organizations.short_name
FROM
  '+@Archive+N'[dbo].[Questions]
  LEFT JOIN '+@Archive+N'[dbo].[Appeals] ON [Questions].appeal_id = [Appeals].Id
  LEFT JOIN [dbo].[Applicants] ON [Applicants].Id = [Appeals].applicant_id
  LEFT JOIN [dbo].[QuestionStates] ON [Questions].question_state_id = [QuestionStates].Id
  LEFT JOIN [dbo].[QuestionTypes] ON [Questions].question_type_id = [QuestionTypes].Id
  LEFT JOIN '+@Archive+N'[dbo].[Assignments] ON Assignments.Id = Questions.last_assignment_for_execution_id
  LEFT JOIN Organizations ON Organizations.Id = Assignments.executor_organization_id
WHERE
  [Applicants].Id = @ApplicantsId
  AND [Questions].Id NOT IN (SELECT
								q.Id
							 FROM dbo.Questions q
							 INNER JOIN dbo.Appeals a ON a.Id = q.appeal_id
							 WHERE a.applicant_id = @ApplicantsId)
  AND #filter_columns#
ORDER BY
  [Questions].[registration_date] 
OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY ; ' ;

 EXEC sp_executesql @Query, N'@ApplicantsId INT, @pageOffsetRows BIGINT, @pageLimitRows BIGINT', 
							 @ApplicantsId = @ApplicantsId,
							 @pageOffsetRows = @pageOffsetRows,
							 @pageLimitRows = @pageLimitRows;