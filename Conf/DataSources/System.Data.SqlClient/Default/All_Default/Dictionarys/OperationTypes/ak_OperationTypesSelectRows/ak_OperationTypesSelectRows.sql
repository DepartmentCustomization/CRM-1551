SELECT [Id]
      ,[name]
  FROM [CRM_1551_Analitics].[dbo].[OperationTypes]
  where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only