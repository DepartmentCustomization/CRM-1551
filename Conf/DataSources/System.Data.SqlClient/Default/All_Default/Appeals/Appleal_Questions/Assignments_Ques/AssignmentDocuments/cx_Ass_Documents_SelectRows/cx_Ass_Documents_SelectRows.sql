--  DECLARE @Id INT = 1810750;

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
DECLARE @Query NVARCHAR(MAX) = 
N'SELECT
  [AssignmentConsDocuments].[Id],
  dt.name AS doc_type_id,
  [AssignmentConsDocuments].[add_date],
  [AssignmentConsDocuments].[name]
FROM
  '+@Archive+N'[dbo].[AssignmentConsDocuments]
  LEFT JOIN DocumentTypes dt ON dt.Id = [AssignmentConsDocuments].doc_type_id
WHERE
  [AssignmentConsDocuments].[assignment_сons_id] IN (
    SELECT
      Id
    FROM
      '+@Archive+N'[dbo].[AssignmentConsiderations]
    WHERE
      [assignment_id] = @Id
  )
  AND #filter_columns#
      #sort_columns#
  OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY ; ';

	EXEC sp_executesql @Query, N'@Id INT, @pageOffsetRows BIGINT, @pageLimitRows BIGINT ', 
							@Id = @Id,
							@pageOffsetRows = @pageOffsetRows,
                            @pageLimitRows = @pageLimitRows;