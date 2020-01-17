SELECT [Id]
      ,[Name] as [name]
  FROM [CRM_1551_Site_Integration].dbo.DocumentTypes
  where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only