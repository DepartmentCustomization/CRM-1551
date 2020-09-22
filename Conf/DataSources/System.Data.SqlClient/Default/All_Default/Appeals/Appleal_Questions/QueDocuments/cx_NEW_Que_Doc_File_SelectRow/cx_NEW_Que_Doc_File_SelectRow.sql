 --DECLARE @Id INT = 1070;

DECLARE @ArchiveServer NVARCHAR(400) = '[' +(
	SELECT
		TOP 1 [IP] + ']'
	FROM
		[dbo].[SetingConnetDatabase]
	WHERE
		Code = N'Archive'
);

DECLARE @IsHere BIT = IIF(
	(
		SELECT
			COUNT(1)
		FROM
			dbo.[QuestionDocFiles]
		WHERE
			Id = @Id
	) = 0,
	0,
	1
);
DECLARE @PathToArchive NVARCHAR(MAX);
DECLARE @SqlText NVARCHAR(MAX);

IF(@IsHere = 1) 
BEGIN
SET
	@ArchiveServer = SPACE(0);

IF (
	SELECT
		isnull(IsArchive, 0)
	FROM
		[dbo].[QuestionDocFiles]
	WHERE
		Id = @Id
) = 1 
BEGIN 
SET @PathToArchive = (
	SELECT
		PathToArchive
	FROM
		[dbo].[QuestionDocFiles]
	WHERE
		Id = @Id
);

SET
	@SqlText = N'SELECT
				     [Id],
				     [create_date],
				     [name] AS [Name],
				     [File]
				 FROM [' + @PathToArchive + '].[dbo].[QuestionDocFiles]
				 WHERE Id = ' + rtrim(@Id) + '
				' ;
EXEC sp_executesql @SqlText;
END
ELSE
BEGIN
SET
	@SqlText = N'SELECT
	[Id],
	[create_date],
	[name] AS [Name],
	[File]
FROM
	[dbo].[QuestionDocFiles]
WHERE
	Id = @Id ';

EXEC sp_executesql @SqlText, N'@Id INT', @Id = @Id;
END
END
ELSE IF(@IsHere = 0)
BEGIN 
DECLARE @PathOnArchiveRow TABLE ([Path] NVARCHAR(MAX));

DECLARE @getRowPath NVARCHAR(MAX) = N'
SELECT 
	[PathToArchive]
FROM ' + @ArchiveServer + '.[CRM_1551_Analitics].[dbo].[QuestionDocFiles]
WHERE Id = @Id';

INSERT INTO @PathOnArchiveRow
EXEC sp_executesql @getRowPath, N'@Id INT', @Id = @Id;

SET @PathToArchive = (SELECT [Path] FROM @PathOnArchiveRow);
 
SET
	@SqlText = N'SELECT
	Id,
	create_date,
	[name] AS [Name],
	[File]
FROM
	' + @ArchiveServer + '.[' + @PathToArchive + '].[dbo].[QuestionDocFiles]
WHERE
	Id = @Id ';

EXEC sp_executesql @SqlText, N'@Id INT', @Id = @Id;
END