-- select Id, [appeal_id]
--  from [CRM_1551_Analitics].[dbo].[AppealsFromSite]
select Id, [Appeal_Id]
 from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
  where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only