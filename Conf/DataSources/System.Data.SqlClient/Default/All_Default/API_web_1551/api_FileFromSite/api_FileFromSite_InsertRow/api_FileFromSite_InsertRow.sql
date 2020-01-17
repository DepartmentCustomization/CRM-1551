insert into [CRM_1551_Site_Integration].[dbo].[AppealFromSiteFiles]
  (
  [AppealFromSiteId]
      ,[File]
      ,[Name]
  )
  output [inserted].[Id]
   select @appeal_from_site_id
      ,@file
      ,@name