SELECT Id,
    create_date,
    [name] AS [Name],
    [File]
FROM [dbo].[QuestionDocFiles]
WHERE Id = @Id