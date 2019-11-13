select Id, name
  from [CRM_1551_Analitics].[dbo].[Objects]
   where #filter_columns#
   #sort_columns#
  offset @pageOffsetRows rows fetch next @pageLimitRows rows only