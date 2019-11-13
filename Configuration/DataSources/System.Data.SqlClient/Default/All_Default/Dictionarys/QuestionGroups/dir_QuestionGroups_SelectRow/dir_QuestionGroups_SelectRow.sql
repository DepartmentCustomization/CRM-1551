SELECT [Id]
      ,[report_code] as reportCode
      ,[name] as groupName
  FROM [dbo].[QuestionGroups]
  WHERE Id = @Id