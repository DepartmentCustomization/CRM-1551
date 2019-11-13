SELECT app.Id 
      ,[ReceiptDate] as [receipt_date]
      ,[ApplicantFromSiteId] as [applicant_from_site_id]
      ,wdt.name as work_direction_type
      ,obj.name as object
      ,[Content] as [appeal_content]
      ,[appeal_id] as appeal_from_site_id
      ,res.name as result
      ,[CommentModerator] as [comment_moderator]
      ,[ProcessingDate] as [processing_date]
      ,[EditByDate] as [edit_date]
      ,[EditByUserId] as [user_edit_id]
  FROM [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] app
  left join [CRM_1551_Analitics].[dbo].[SiteAppealsResults] res on res.id = app.AppealFromSiteResultId
  left join [CRM_1551_Site_Integration].[dbo].[WorkDirectionTypes] wdt on wdt.id = app.WorkDirectionTypeId
  left join [CRM_1551_Analitics].[dbo].[Objects] obj on obj.Id = app.[ObjectId]
	where  #filter_columns#
     #sort_columns#
offset @pageOffsetRows rows fetch next @pageLimitRows rows only