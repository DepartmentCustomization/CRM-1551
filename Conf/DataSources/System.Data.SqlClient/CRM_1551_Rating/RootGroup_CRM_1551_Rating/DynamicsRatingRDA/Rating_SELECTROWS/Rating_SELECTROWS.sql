select [Id]
  ,[Name]
  FROM [CRM_1551_Analitics].[dbo].[Rating]
  where 
  #filter_columns#
  --#sort_columns#
  order by 1
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only