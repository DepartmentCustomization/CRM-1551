SELECT [Id]
      ,[name]
      , ltrim(Id)+N'-'+[name] [Idname]
  FROM [CRM_1551_Analitics].[dbo].[ProcessingKind]
  where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only