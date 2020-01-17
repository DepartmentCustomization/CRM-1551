  SELECT [Id]
		,[name]
  FROM [CRM_1551_Analitics].[dbo].[QuestionTypes]
  where id != 1
  and #filter_columns#
  #sort_columns#
  offset @pageOffsetRows rows fetch next @pageLimitRows rows only  