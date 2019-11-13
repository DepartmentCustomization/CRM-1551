SELECT [Id]
        ,[name]
      ,[shortname]
      
  FROM [CRM_1551_Analitics].[dbo].[StreetTypes]
  where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only