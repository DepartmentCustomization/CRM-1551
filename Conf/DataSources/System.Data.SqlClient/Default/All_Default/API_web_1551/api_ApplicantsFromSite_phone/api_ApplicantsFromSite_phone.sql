--declare @phone nvarchar(30)= N'+380632701143';

IF EXISTS
(
  select distinct [ApplicantsFromSite].Id, [ApplicantsFromSite].Firstname, [ApplicantsFromSite].Surname, [ApplicantsFromSite].Fathername
  from [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] inner join
 [CRM_1551_Site_Integration].[dbo].[ApplicantsFromSite] 
 on [ApplicantFromSiteMoreContacts].ApplicantFromSiteId=[ApplicantsFromSite].Id
 where [ApplicantFromSiteMoreContacts].PhoneNumber=@phone)
 BEGIN
	select distinct [ApplicantsFromSite].Id, [ApplicantsFromSite].Firstname, [ApplicantsFromSite].Surname, [ApplicantsFromSite].Fathername
  from [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] inner join
 [CRM_1551_Site_Integration].[dbo].[ApplicantsFromSite] 
 on [ApplicantFromSiteMoreContacts].ApplicantFromSiteId=[ApplicantsFromSite].Id
 where [ApplicantFromSiteMoreContacts].PhoneNumber=@phone
--  and #filter_columns#
--   #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only
  END

 ELSE 
	BEGIN
		SELECT N'вихідний параметр - не знайдено' [text]
	END

