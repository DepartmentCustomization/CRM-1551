/*
declare @AppealFromSite_Id_Search int =5;
declare @AppealFromSite_Id int; -- = 39
declare @BuildingId int;-- = 5986
declare @Flat int;-- = 4
*/
--DECLARE @mail nvarchar(150)

/*
--Жилянська (Жаданівського) 47
select * from Buildings where id = 5986
select * from Streets where id = 792
*/ 

DECLARE @phone_table TABLE (phone nvarchar(40));
DECLARE @mail_table TABLE (mail nvarchar(150));


IF @AppealFromSite_Id IS NULL AND @BuildingId IS NULL AND @Flat IS NULL
	 BEGIN
			INSERT INTO @phone_table (phone)
		  SELECT [ApplicantFromSiteMoreContacts].PhoneNumber
		  FROM [CRM_1551_Site_Integration].[dbo].[ApplicantsFromSite]
		  INNER JOIN [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] ON [ApplicantsFromSite].Id=[ApplicantFromSiteMoreContacts].ApplicantFromSiteId
		  INNER JOIN [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] ON [AppealsFromSite].ApplicantFromSiteId=[ApplicantsFromSite].Id
		  WHERE [AppealsFromSite].Id=@AppealFromSite_Id_Search AND [ApplicantFromSiteMoreContacts].PhoneNumber IS NOT NULL

		  
		  --SELECT phone FROM @phone_table
		  --SELECT * FROM @mail_table

		IF NOT EXISTS (SELECT DISTINCT [Applicants].Id
						  FROM [CRM_1551_Analitics].[dbo].[Applicants]
						  INNER JOIN [CRM_1551_Analitics].[dbo].[ApplicantPhones] ON [Applicants].Id=[ApplicantPhones].applicant_id
						  INNER JOIN @phone_table pt ON [ApplicantPhones].phone_number=pt.phone)

			BEGIN
					  INSERT INTO @mail_table (mail)
					  SELECT [ApplicantFromSiteMoreContacts].Mail
					  FROM [CRM_1551_Site_Integration].[dbo].[ApplicantsFromSite]
					  INNER JOIN [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] ON [ApplicantsFromSite].Id=[ApplicantFromSiteMoreContacts].ApplicantFromSiteId
					  INNER JOIN [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] ON [AppealsFromSite].ApplicantFromSiteId=[ApplicantsFromSite].Id
					  WHERE [AppealsFromSite].Id=@AppealFromSite_Id_Search

					 

					  SELECT Id, [TypeSearch], [PIB]
					  FROM
					  (SELECT DISTINCT Id, N'E' as [TypeSearch], [full_name] [PIB]
					  FROM [CRM_1551_Analitics].[dbo].Applicants
					  WHERE mail IN (SELECT mail FROM @mail_table)) t
					  WHERE #filter_columns#
					  #sort_columns#
			--order by 1
					  offset @pageOffsetRows rows fetch next @pageLimitRows rows only
			END
		ELSE
			BEGIN

			

				SELECT Id, [TypeSearch], [PIB]
				FROM
				(SELECT DISTINCT [Applicants].Id, N'T' AS [TypeSearch], [Applicants].full_name [PIB]
				FROM [CRM_1551_Analitics].[dbo].[Applicants]
				INNER JOIN [CRM_1551_Analitics].[dbo].[ApplicantPhones] ON [Applicants].Id=[ApplicantPhones].applicant_id
				INNER JOIN @phone_table pt ON [ApplicantPhones].phone_number=pt.phone
				) t
		  WHERE #filter_columns#
		  #sort_columns#
			--order by 1
		  offset @pageOffsetRows rows fetch next @pageLimitRows rows only
			END
	 END

	 ELSE
		BEGIN
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
			--	--order by 1
			offset @pageOffsetRows rows fetch next @pageLimitRows rows only

	END