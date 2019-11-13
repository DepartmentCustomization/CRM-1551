 select [AppealsFromSite].Id as [AppealFromSiteId], 
		[AppealsFromSite].[ReceiptDate] as [receipt_date], 
		[SiteAppealsResults].name [Result], 
		[Objects].name [Object], 
		[WorkDirectionTypes].name [WorkDirectionTypes],
		[AppealsFromSite].[Content] as [appeal_content], 
		[AppealsFromSite].CommentModerator as [comment_moderator]
  from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
  left join [CRM_1551_Analitics].[dbo].[SiteAppealsResults] on [AppealsFromSite].ApplicantFromSiteId=[SiteAppealsResults].id
  left join [CRM_1551_Analitics].[dbo].[Objects] on [AppealsFromSite].[ObjectId]=[Objects].Id
  left join [CRM_1551_Site_Integration].[dbo].[WorkDirectionTypes] on [AppealsFromSite].WorkDirectionTypeId=[WorkDirectionTypes].id
  where [AppealsFromSite].[appeal_id] is null 
  and [AppealsFromSite].ApplicantFromSiteId = @ApplicantFromSiteId
   and #filter_columns#
--   #sort_columns#
order by 1
  offset @pageOffsetRows rows fetch next @pageLimitRows rows only