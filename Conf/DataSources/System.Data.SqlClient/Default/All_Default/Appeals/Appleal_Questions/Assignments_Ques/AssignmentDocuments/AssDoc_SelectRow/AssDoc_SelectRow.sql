-- DECLARE @Id INT = 2196;

DECLARE @Archive NVARCHAR(400) = '['+(SELECT TOP 1 [IP]+'].['+[DatabaseName]+'].' FROM [dbo].[SetingConnetDatabase] WHERE Code = N'Archive');

DECLARE @IsHere BIT = IIF(
   (
      SELECT
         COUNT(1)
      FROM
         [dbo].[AssignmentConsDocuments]
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
  dt.id AS doc_type_id,
  dt.name AS doc_type_name,
  [AssignmentConsDocuments].[add_date],
  [AssignmentConsDocuments].[name],
  [AssignmentConsDocuments].content
FROM
  '+@Archive+N'[dbo].[AssignmentConsDocuments]
  LEFT JOIN [dbo].DocumentTypes dt ON dt.Id = [AssignmentConsDocuments].doc_type_id
WHERE 
  [AssignmentConsDocuments].[Id] = @Id ; ' ; 

	EXEC sp_executesql @Query, N'@Id INT', 
								@Id = @Id;