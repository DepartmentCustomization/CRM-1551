SELECT [Id]
      ,[Date]
      ,[Field]
      ,[Old_Value]
      ,[New_Value]
      ,[User]
  FROM [dbo].[QuestionTypes_History]
  where [QuestionTypes_ID] = @Id
  and
   #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only