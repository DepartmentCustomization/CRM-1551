-- SELECT Id,
--     create_date,
--     [name] AS [Name],
--     [File]
-- FROM [dbo].[QuestionDocFiles]
-- WHERE Id = @Id

--declare @Id int = 1148


if (SELECT isnull(IsArchive,0) FROM [dbo].[QuestionDocFiles] WHERE Id = @Id) = 1
begin
	declare @PathToArchive nvarchar(max) = (SELECT PathToArchive FROM [dbo].[QuestionDocFiles] WHERE Id = @Id)
	declare @SqlText nvarchar(max)
	set @SqlText = N'
				 SELECT TOP 1 Id,
				     create_date,
				     [name] AS [Name],
				     [File]
				 FROM ['+@PathToArchive+'].[dbo].[QuestionDocFiles]
				 WHERE Id = '+rtrim(@Id)+'
				'
	exec sp_executesql  @SqlText
end
else
begin
	SELECT Id,
	    create_date,
	    [name] AS [Name],
	    [File]
	FROM [dbo].[QuestionDocFiles]
	WHERE Id = @Id
end
