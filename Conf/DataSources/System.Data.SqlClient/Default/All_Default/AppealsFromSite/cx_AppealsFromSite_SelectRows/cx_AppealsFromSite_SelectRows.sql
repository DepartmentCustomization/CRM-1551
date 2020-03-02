SELECT
     app.Id,
     [ReceiptDate] AS [receipt_date],
     [ApplicantFromSiteId] AS [applicant_from_site_id],
     wdt.name AS work_direction_type,
     obj.name AS object,
     [Content] AS [appeal_content],
     [appeal_id] AS appeal_from_site_id,
     res.name AS result,
     [CommentModerator] AS [comment_moderator],
     [ProcessingDate] AS [processing_date],
     [EditByDate] AS [edit_date],
     [EditByUserId] AS [user_edit_id]
FROM
     [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] app
     LEFT JOIN [CRM_1551_Analitics].[dbo].[SiteAppealsResults] res ON res.id = app.AppealFromSiteResultId
     LEFT JOIN [CRM_1551_Site_Integration].[dbo].[WorkDirectionTypes] wdt ON wdt.id = app.WorkDirectionTypeId
     LEFT JOIN [CRM_1551_Analitics].[dbo].[Objects] obj ON obj.Id = app.[ObjectId]
WHERE
     #filter_columns#
     #sort_columns#
     OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY ;