
SELECT
	Id,
	[name] AS [Name],
	[File]
FROM [dbo].[EventFiles]
WHERE Id = @Id
