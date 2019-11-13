update [CRM_1551_Site_Integration].[dbo].[AppealFromSiteFiles]
  set [AppealFromSiteId]=@appeal_from_site_id
      ,[File]=@File
      ,[Name]=@name
  where Id=@Id