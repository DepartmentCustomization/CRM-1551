SELECT [Id],
       [GUID],
       [File],
       [Name]
FROM [dbo].[MyFirstTable_FILESTREAM]
WHERE  [Id] = @Id