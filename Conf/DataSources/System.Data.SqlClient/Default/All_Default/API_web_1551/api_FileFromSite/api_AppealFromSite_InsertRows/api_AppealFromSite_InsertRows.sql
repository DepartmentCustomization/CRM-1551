-- insert into [CRM_1551_Site_Integration].[dbo].AppealFromSite
--   (name)
--   select @name

insert into [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
  ([ReceiptDate]
  ,[Content]
  ,[AppealFromSiteResultId]
  ,[ProcessingDate])
  
  select @receipt_date
  ,@appeal_content
  ,@site_appeals_result_id
  ,@processing_date