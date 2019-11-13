select [Id],			
       [AppealFromSiteId],			
       [File],				
       [Name]
  from [CRM_1551_Site_Integration].[dbo].[AppealFromSiteFiles]
  where Id=@Id