/*
declare @AppealFromSite_Id int = 39
declare @BuildingId int = 5986
declare @Flat int = 4
*/
/*
--Жилянська (Жаданівського) 47
select * from Buildings where id = 5986
select * from Streets where id = 792
*/


select  * from
(
  SELECT  [Applicants].[Id],
		  N'О' as [TypeSearch],
		  [Applicants].[full_name] as [PIB]
  FROM [dbo].[LiveAddress]
  left join [dbo].[Applicants] on [Applicants].Id = [LiveAddress].applicant_id
  where [building_id] = @BuildingId and ([flat] = @Flat or len(isnull(rtrim(@Flat),N'')) = 0)
union all
  SELECT  [Applicants].[Id],
		  N'Т' as [TypeSearch],
		  [Applicants].[full_name]
  FROM [dbo].[ApplicantPhones]
  left join [dbo].[Applicants] on [Applicants].Id = [ApplicantPhones].[applicant_id]
  where [ApplicantPhones].[phone_number] in (select right([ApplicantFromSiteMoreContacts].PhoneNumber,10) as [Phone]
											 from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] 
											 inner join [CRM_1551_Site_Integration].[dbo].[ApplicantsFromSite] on [ApplicantsFromSite].Id = [AppealsFromSite].ApplicantFromSiteId
											 inner join [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] on [ApplicantFromSiteMoreContacts].ApplicantFromSiteId = [ApplicantsFromSite].Id
											 where [AppealsFromSite].Id = @AppealFromSite_Id and [ApplicantFromSiteMoreContacts].PhoneNumber is not null)

) as t1
	where  #filter_columns#
	group by [Id], [TypeSearch], [PIB]
    #sort_columns#
--	order by 1
offset @pageOffsetRows rows fetch next @pageLimitRows rows only