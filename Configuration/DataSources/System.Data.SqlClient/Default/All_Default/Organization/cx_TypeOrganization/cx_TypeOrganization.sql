select id, name
  from [CRM_1551_Analitics].[dbo].[OrganizationTypes]
   where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only