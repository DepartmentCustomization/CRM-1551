 --DECLARE @event_id INT = 277; 
 --DECLARE @pageOffsetRows BIGINT = 0;
 --DECLARE @pageLimitRows BIGINT = 15;

DECLARE @Archive NVARCHAR(400) = '['+(SELECT TOP 1 [IP]+'].['+[DatabaseName]+'].' FROM [dbo].[SetingConnetDatabase] WHERE Code = N'Archive');

DECLARE @Query NVARCHAR(MAX) = 
N'SELECT
  [Questions].Id,
  [Questions].registration_number,
  [Questions].[registration_date],
  [QuestionStates].name AS QuestionStates,
  [QuestionTypes].name AS QuestionType,
  [Questions].control_date,
  Organizations.short_name
FROM
  '+@Archive+N'[dbo].[Questions] WITH (NOLOCK)
  INNER JOIN [dbo].[Events] WITH (NOLOCK) ON [Events].Id = [Questions].event_id
  LEFT JOIN [dbo].[QuestionStates] ON [Questions].question_state_id = [QuestionStates].Id
  LEFT JOIN [dbo].[QuestionTypes] ON [Questions].question_type_id = [QuestionTypes].Id
  LEFT JOIN '+@Archive+N'[dbo].[Assignments] WITH (NOLOCK) ON Assignments.Id = Questions.last_assignment_for_execution_id
  LEFT JOIN Organizations ON Organizations.Id = Assignments.executor_organization_id
WHERE
  [Events].Id = @event_id
  AND [Questions].Id NOT IN (SELECT [Questions].Id 
			FROM dbo.[Questions] WITH (NOLOCK)
			INNER JOIN [dbo].[Events] WITH (NOLOCK) ON [Events].Id = [Questions].event_id
			WHERE [Events].Id = @event_id)
AND #filter_columns#
ORDER BY
  [Questions].[registration_date] 
OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY ; ' ;

 EXEC sp_executesql @Query, N'@event_id INT, @pageOffsetRows BIGINT, @pageLimitRows BIGINT', 
							 @event_id = @event_id,
							 @pageOffsetRows = @pageOffsetRows,
							 @pageLimitRows = @pageLimitRows;