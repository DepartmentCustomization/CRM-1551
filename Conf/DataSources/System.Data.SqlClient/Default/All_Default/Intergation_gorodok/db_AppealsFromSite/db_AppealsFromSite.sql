--declare @result int =1;

SELECT
	afs.Id AS Id,
	ReceiptDate AS receiptDate,
	wdt.[name] AS workDirection,
	obj.[name] AS appealObject,
	afs.Content AS content,
	sar.[name] AS result,
	CommentModerator AS moderComment,
	afs.[SystemIP],
	app.Surname,
	app.Firstname,
	(
	SELECT STUFF((SELECT N', '+PhoneNumber FROM [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts]
	WHERE PhoneNumber IS NOT NULL AND [ApplicantFromSiteId]=app.Id
	FOR XML PATH('')),1,2,N'')
	) ApplicantPhone,
	(
	SELECT STUFF((SELECT N', '+Mail FROM [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts]
	WHERE Mail IS NOT NULL AND [ApplicantFromSiteId]=app.Id
	FOR XML PATH('')),1,2,N'')
	) ApplicantMail

FROM
	[CRM_1551_Site_Integration].[dbo].[AppealsFromSite] afs
	LEFT JOIN [CRM_1551_Site_Integration].[dbo].WorkDirectionTypes wdt ON afs.WorkDirectionTypeId = wdt.id
	LEFT JOIN CRM_1551_Analitics.[dbo].[Objects] obj ON obj.Id = afs.[ObjectId]
	LEFT JOIN SiteAppealsResults sar ON sar.id = afs.AppealFromSiteResultId
	LEFT JOIN [CRM_1551_Site_Integration].[dbo].[ApplicantsFromSite] app ON afs.ApplicantFromSiteId=app.Id

WHERE
	afs.AppealFromSiteResultId = @result
	AND #filter_columns#
		#sort_columns#
	OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY 


-- SELECT
-- 	afs.Id AS Id,
-- 	ReceiptDate AS receiptDate,
-- 	wdt.[name] AS workDirection,
-- 	obj.[name] AS appealObject,
-- 	afs.Content AS content,
-- 	sar.[name] AS result,
-- 	CommentModerator AS moderComment
-- FROM
-- 	[CRM_1551_Site_Integration].[dbo].[AppealsFromSite] afs
-- 	LEFT JOIN [CRM_1551_Site_Integration].[dbo].WorkDirectionTypes wdt ON afs.WorkDirectionTypeId = wdt.id
-- 	LEFT JOIN CRM_1551_Analitics.[dbo].[Objects] obj ON obj.Id = afs.[ObjectId]
-- 	LEFT JOIN SiteAppealsResults sar ON sar.id = afs.AppealFromSiteResultId
-- WHERE
-- 	afs.AppealFromSiteResultId = @result
-- 	AND #filter_columns#
-- 		#sort_columns#
-- 	OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY 
-- 	;