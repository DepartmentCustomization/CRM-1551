SELECT
	afs.Id AS Id,
	ReceiptDate AS receiptDate,
	wdt.[name] AS workDirection,
	obj.[name] AS appealObject,
	afs.Content AS content,
	sar.[name] AS result,
	CommentModerator AS moderComment
FROM
	[CRM_1551_Site_Integration].[dbo].[AppealsFromSite] afs
	LEFT JOIN [CRM_1551_Site_Integration].[dbo].WorkDirectionTypes wdt ON afs.WorkDirectionTypeId = wdt.id
	LEFT JOIN CRM_1551_Analitics.[dbo].[Objects] obj ON obj.Id = afs.[ObjectId]
	LEFT JOIN SiteAppealsResults sar ON sar.id = afs.AppealFromSiteResultId
WHERE
	afs.AppealFromSiteResultId = @result
	AND #filter_columns#
		#sort_columns#
	OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY 
	;