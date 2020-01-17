SELECT [Id]
      ,[name]
      ,ltrim(Id)+N'-'+name [Idname]
  FROM [CRM_1551_Analitics].[dbo].[ExecutorRole]
  where #filter_columns#
  order by id
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only