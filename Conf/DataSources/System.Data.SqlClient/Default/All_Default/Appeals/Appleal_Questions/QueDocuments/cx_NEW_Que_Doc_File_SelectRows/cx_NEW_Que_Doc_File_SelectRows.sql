  -- DECLARE @Id INT = 6690742;

DECLARE @Archive NVARCHAR(400) = '['+(SELECT TOP 1 [IP]+'].['+[DatabaseName]+'].' FROM [dbo].[SetingConnetDatabase] WHERE Code = N'Archive');

DECLARE @IsHere BIT = IIF(
   (
      SELECT
		COUNT(1)
      FROM
         dbo.QuestionDocFiles
      WHERE
        question_id = @Id
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
  Id,
  create_date,
  [name],
  [File]
FROM
  '+@Archive+N'[dbo].[QuestionDocFiles]
WHERE
  question_id = @Id
  AND [File] IS NOT NULL
  AND #filter_columns#
ORDER BY 1 
OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY
;' ;

EXEC sp_executesql @Query, N'@Id INT, @pageOffsetRows BIGINT, @pageLimitRows BIGINT', 
							  @Id = @Id,
                              @pageOffsetRows = @pageOffsetRows,
                              @pageLimitRows = @pageLimitRows;