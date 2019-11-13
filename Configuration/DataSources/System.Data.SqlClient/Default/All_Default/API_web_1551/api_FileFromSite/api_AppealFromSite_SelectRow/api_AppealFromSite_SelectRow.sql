select	[Id],
		[Id] as [appeal_from_site_id],
		[ReceiptDate] as [receipt_date],
		[Content] as [appeal_content],
		[AppealFromSiteResultId] as [site_appeals_result_id],
		[ProcessingDate] as [processing_date]
from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
where Id=@Id