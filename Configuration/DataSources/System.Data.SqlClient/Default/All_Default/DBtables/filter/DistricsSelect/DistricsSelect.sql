SELECT [Id]
      ,[name] as [Name]
  FROM [CRM_1551_Analitics].[dbo].[Districts]
  where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only