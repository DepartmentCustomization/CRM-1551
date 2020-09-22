--  DECLARE @Id INT = 5392191 ; 

DECLARE @Archive NVARCHAR(400) = '['+(SELECT TOP 1 [IP]+'].['+[DatabaseName]+'].' FROM [dbo].[SetingConnetDatabase] WHERE Code = N'Archive');

DECLARE @IsHere BIT = IIF(
   (
      SELECT
		COUNT(1)
      FROM
         dbo.Questions
      WHERE
        appeal_id = @Id
   ) = 0,
   0,
   1
);

IF(@IsHere = 1)
BEGIN
	SET @Archive = SPACE(1);
END
DECLARE @Query NVARCHAR(MAX) = 
N'SELECT
  [Questions].[Id],
  [Questions].[registration_number],
  [Questions].[registration_date],
  QuestionStates.[name] AS question_state_name,
  [Questions].[control_date],
  QuestionTypes.[name] AS question_type_name,
  [Questions].[question_content]
FROM
  '+@Archive+N'[dbo].[Questions] [Questions]
  LEFT JOIN '+@Archive+N'[dbo].[Appeals] [Appeals] ON Appeals.Id = Questions.appeal_id
  LEFT JOIN [dbo].[QuestionStates] [QuestionStates] ON QuestionStates.Id = Questions.question_state_id
  LEFT JOIN [dbo].[QuestionTypes] [QuestionTypes] ON QuestionTypes.Id = Questions.question_type_id
WHERE
  Questions.appeal_id = @Id
 AND #filter_columns#
ORDER BY
  registration_date DESC 
OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY ; ' ;

EXEC sp_executesql @Query, N'@Id INT, @pageOffsetRows BIGINT, @pageLimitRows BIGINT', 
							                @Id = @Id,
                              @pageOffsetRows = @pageOffsetRows,
                              @pageLimitRows = @pageLimitRows;