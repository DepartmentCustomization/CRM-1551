SELECT [Id]
       ,[name]
  FROM [CRM_1551_Analitics].[dbo].[AssignmentResolutions]
  where #filter_columns#
  #sort_columns#
  offset @pageOffsetRows rows fetch next @pageLimitRows rows only      