-- DECLARE @Id INT = 2196;

DECLARE @Archive NVARCHAR(400) = '['+(SELECT TOP 1 [IP]+'].['+[DatabaseName]+'].' FROM [dbo].[SetingConnetDatabase] WHERE Code = N'Archive');

DECLARE @IsHere BIT = IIF(
   (
      SELECT
         COUNT(1)
      FROM
         dbo.AssignmentConsDocuments
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
DECLARE @Query NVARCHAR(MAX) = 
N'SELECT
  [Id],
  [assignment_cons_doc_id],
  [link],
  [create_date],
  [user_id],
  [edit_date],
  [user_edit_id],
  [name],
  [File]
FROM
  '+@Archive+N'[dbo].[AssignmentConsDocFiles]
WHERE
  [assignment_cons_doc_id] = @Id
 AND #filter_columns#
ORDER BY 1 
 OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY ;';

	EXEC sp_executesql @Query, N'@Id INT, @pageOffsetRows BIGINT, @pageLimitRows BIGINT', 
								@Id = @Id,
								@pageOffsetRows = @pageOffsetRows,
								@pageLimitRows = @pageLimitRows;