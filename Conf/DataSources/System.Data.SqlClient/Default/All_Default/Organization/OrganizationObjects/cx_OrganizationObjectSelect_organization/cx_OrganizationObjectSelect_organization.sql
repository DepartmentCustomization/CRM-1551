select Id, name, short_name
  from [CRM_1551_Analitics].[dbo].[Organizations]  
  where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only