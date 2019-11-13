select [Id],			
       [AppealFromSiteId],			
       [File],				
       [Name]
  from [CRM_1551_Site_Integration].[dbo].[AppealFromSiteFiles]
  where 
  [AppealFromSiteId]=@appeal_from_site_id and 
  #filter_columns#
  --#sort_columns#
 order by 1
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only