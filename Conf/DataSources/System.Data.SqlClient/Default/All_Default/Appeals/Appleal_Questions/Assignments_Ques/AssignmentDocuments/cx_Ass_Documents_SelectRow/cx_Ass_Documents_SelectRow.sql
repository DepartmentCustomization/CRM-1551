--  DECLARE @Id INT = 2196;

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
  [AssignmentConsDocuments].[Id],
  [AssignmentConsDocuments].[assignment_сons_id],
  DocumentTypes.Id AS doc_type_id,
  DocumentTypes.name AS doc_type_name,
  [AssignmentConsDocuments].[name],
  [AssignmentConsDocuments].[content],
  [AssignmentConsDocuments].[add_date],
  [AssignmentConsDocuments].[user_id],
  [AssignmentConsDocuments].[edit_date],
  [AssignmentConsDocuments].[user_edit_id]
FROM
  '+@Archive+N'[dbo].[AssignmentConsDocuments]
  LEFT JOIN DocumentTypes ON DocumentTypes.Id = [AssignmentConsDocuments].doc_type_id
WHERE
  [AssignmentConsDocuments].[Id] = @Id; ';

	EXEC sp_executesql @Query, N'@Id INT', 
								@Id = @Id;