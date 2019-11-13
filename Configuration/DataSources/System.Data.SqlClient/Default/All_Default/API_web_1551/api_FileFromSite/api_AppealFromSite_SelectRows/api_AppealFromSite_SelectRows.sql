select [Id],
       [ReceiptDate] as [receipt_date],
       [Content] as [appeal_content],
       [AppealFromSiteResultId] as [site_appeals_result_id],
       [ProcessingDate] as [processing_date]
  from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
 where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only