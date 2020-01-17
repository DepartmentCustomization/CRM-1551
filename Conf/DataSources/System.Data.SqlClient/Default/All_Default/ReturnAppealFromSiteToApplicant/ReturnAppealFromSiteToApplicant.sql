update [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] 
set AppealFromSiteResultId = 2, 
    CommentModerator = @AppealFromSite_CommentModerator
where Id = @Id