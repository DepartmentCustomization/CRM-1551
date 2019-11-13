 select Id
  from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
   where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only