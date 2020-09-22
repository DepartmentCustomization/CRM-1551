--  DECLARE @Id INT = 2633;

DECLARE @ArchiveServer NVARCHAR(400) = '['+(SELECT TOP 1 [IP]+']' FROM [dbo].[SetingConnetDatabase] WHERE Code = N'Archive');
DECLARE @SqlText NVARCHAR(MAX);

DECLARE @IsHere BIT = IIF(
   (
      SELECT
         COUNT(1)
      FROM
         dbo.[AssignmentConsDocFiles]
      WHERE
         Id = @Id
   ) = 0,
   0,
   1
);

IF(@IsHere = 1)
BEGIN
	SET @ArchiveServer = SPACE(0);

IF (
  SELECT
    isnull(IsArchive, 0)
  FROM
    [dbo].[AssignmentConsDocFiles]
  WHERE
    Id = @Id
) = 1 
BEGIN 
DECLARE @PathToArchive NVARCHAR(MAX) = (
  SELECT
    PathToArchive
  FROM
    [dbo].[AssignmentConsDocFiles]
  WHERE
    Id = @Id
);

SET
  @SqlText = N'SELECT TOP 1 [Id]
                            ,[assignment_cons_doc_id]
                            ,[link]
                            ,[create_date]
                            ,[user_id]
                            ,[edit_date]
                            ,[user_edit_id]
                            ,[name]
                            ,[File]
				 FROM [' + @PathToArchive + '].[dbo].[AssignmentConsDocFiles]
				 WHERE Id = ' + rtrim(@Id) + '
				';
EXEC sp_executesql @SqlText;
END
ELSE 
BEGIN
SET
  @SqlText = N'SELECT
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
  [dbo].[AssignmentConsDocFiles]
WHERE
  Id = @Id';
EXEC sp_executesql @SqlText, N' @Id INT', @Id = @Id;
END 
END
ELSE IF(@IsHere = 0)
BEGIN 
DECLARE @PathOnArchiveRow TABLE ([Path] NVARCHAR(MAX));

DECLARE @getRowPath NVARCHAR(MAX) = N'
SELECT 
	[PathToArchive]
FROM ' + @ArchiveServer + '.[CRM_1551_Analitics].[dbo].[AssignmentConsDocFiles]
WHERE Id = @Id';

INSERT INTO @PathOnArchiveRow
EXEC sp_executesql @getRowPath, N'@Id INT', @Id = @Id;

SET @PathToArchive = (SELECT [Path] FROM @PathOnArchiveRow);

SET
  @SqlText = N'SELECT
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
  ' + @ArchiveServer + '.[' + @PathToArchive + '].[dbo].[AssignmentConsDocFiles]
WHERE
  Id = @Id';
EXEC sp_executesql @SqlText, N' @Id INT', @Id = @Id;
END