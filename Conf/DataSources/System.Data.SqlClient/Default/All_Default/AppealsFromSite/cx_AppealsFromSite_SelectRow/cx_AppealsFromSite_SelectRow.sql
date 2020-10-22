





  --DECLARE @Id INT = 67551;

SELECT
	TOP 1
	afs.Id,
	ltrim(
		rtrim(
			isnull(abi.surname, N'') + ' ' + isnull(abi.firstname, N'') + ' ' + isnull(abi.fathername, N'')
		)
	) AS ApplicantFromSite_PIB,
CASE
		WHEN len(
			isnull(
				stuff(
					(
						SELECT
							N' ,' + p.[PhoneNumber]
						FROM
							[CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] p
						WHERE
							p.ApplicantFromSiteId = abi.Id
							AND len(isnull(p.PhoneNumber, N'')) > 0
							AND p.MoreContactTypeId = 1 FOR XML PATH('')
					),
					2,
					1,
					N''
				),
				N''
			)
		) > 0 THEN N'Основний: (' + isnull(
			stuff(
				(
					SELECT
						N' ,' + p.[PhoneNumber]
					FROM
						[CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] p
					WHERE
						p.ApplicantFromSiteId = abi.Id
						AND len(isnull(p.PhoneNumber, N'')) > 0
						AND p.MoreContactTypeId = 1 FOR XML PATH('')
				),
				2,
				1,
				N''
			),
			N''
		) + N'); '
		ELSE N''
	END + CASE
		WHEN len(
			isnull(
				stuff(
					(
						SELECT
							N' ,' + p.[PhoneNumber]
						FROM
							[CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] p
						WHERE
							p.ApplicantFromSiteId = abi.Id
							AND len(isnull(p.PhoneNumber, N'')) > 0
							AND p.MoreContactTypeId = 2 FOR XML PATH('')
					),
					2,
					1,
					N''
				),
				N''
			)
		) > 0 THEN N'Додатковий: (' + isnull(
			stuff(
				(
					SELECT
						N' ,' + p.[PhoneNumber]
					FROM
						[CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] p
					WHERE
						p.ApplicantFromSiteId = abi.Id
						AND len(isnull(p.PhoneNumber, N'')) > 0
						AND p.MoreContactTypeId = 2 FOR XML PATH('')
				),
				2,
				1,
				N''
			),
			N''
		) + N'); '
		ELSE N''
	END AS [ApplicantFromSite_Phone],
CASE
		WHEN len(
			isnull(
				stuff(
					(
						SELECT
							N' ,' + p.[Mail]
						FROM
							[CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] p
						WHERE
							p.ApplicantFromSiteId = abi.Id
							AND len(isnull(p.[Mail], N'')) > 0
							AND p.MoreContactTypeId = 1 FOR XML PATH('')
					),
					2,
					1,
					N''
				),
				N''
			)
		) > 0 THEN N'Основний: (' + isnull(
			stuff(
				(
					SELECT
						N' ,' + p.[Mail]
					FROM
						[CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] p
					WHERE
						p.ApplicantFromSiteId = abi.Id
						AND len(isnull(p.[Mail], N'')) > 0
						AND p.MoreContactTypeId = 1 FOR XML PATH('')
				),
				2,
				1,
				N''
			),
			N''
		) + N'); '
		ELSE N''
	END + CASE
		WHEN len(
			isnull(
				stuff(
					(
						SELECT
							N' ,' + p.[Mail]
						FROM
							[CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] p
						WHERE
							p.ApplicantFromSiteId = abi.Id
							AND len(isnull(p.[Mail], N'')) > 0
							AND p.MoreContactTypeId = 2 FOR XML PATH('')
					),
					2,
					1,
					N''
				),
				N''
			)
		) > 0 THEN N'Додатковий: (' + isnull(
			stuff(
				(
					SELECT
						N' ,' + p.[Mail]
					FROM
						[CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] p
					WHERE
						p.ApplicantFromSiteId = abi.Id
						AND len(isnull(p.[Mail], N'')) > 0
						AND p.MoreContactTypeId = 2 FOR XML PATH('')
				),
				2,
				1,
				N''
			),
			N''
		) + N'); '
		ELSE N''
	END AS [ApplicantFromSite_Mail],

   --IIF(aa.BuildingId IS NULL, 	
   stuff(
			(
							SELECT TOP 1
								N';' + isnull(aa.Region + N' обл., ', N'') + isnull(aa.District + N' р-н, ', N'') + 
								isnull(N' місто ' + aa.CityName + ',', N'') + isnull(N' вул. ' + aa.StreetName, N'') + 
								isnull(N' буд. ' + aa.BuildingName, N'') + isnull(N', кв. ' + aa.flat, N'')
							FROM
								[CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteAddresses] aa
							WHERE
								aa.ApplicantFromSiteId = abi.Id 
							--order by case when [AddressTypeId]=4 then [AddressTypeId]
							--else aa.Id*(-1) end 
							order by case when [AddressTypeId]=4 then 1 else 2 end,
							aa.Id desc
								FOR XML PATH('')
						),
						1,
						1,
						N''
					)
			--		,
			-- d.name + N' р-н, ' + st.name + N' ' + s.name + N', буд. ' + b.name  + isnull(N', кв. ' +aa.flat, N'')
			--) AS 
			ApplicantFromSite_Address,
	aa.ApplicantFromSiteId,
	abi.sex AS [ApplicantFromSite_Sex],
	abi.birthdate AS [ApplicantFromSite_Birthdate],
(year(CURRENT_TIMESTAMP) - year(abi.birthdate)) AS [ApplicantFromSite_Age],
	ss.id AS [ApplicantFromSite_SocialState],
	ss.name AS [ApplicantFromSite_SocialStateName],
	ap.id AS [Applicant_Privilege],
	ap.name AS [Applicant_PrivilegeName],
	afs.Id AS [AppealFromSite_Id],
	afs.[ReceiptDate] AS [AppealFromSite_ReceiptDate],
	wdt.id AS [AppealFromSite_WorkDirectionType],
	wdt.name AS [AppealFromSite_WorkDirectionTypeName],
	obj.id AS [AppealFromSite_Object],
	obj.name AS [AppealFromSite_ObjectName],
	afs.[Content] AS [AppealFromSite_Content],
	afs.[Appeal_Id] AS [Appeal_Id],
	res.[Id] AS [AppealFromSite_SiteAppealsResult],
	res.[name] AS [AppealFromSite_SiteAppealsResultName],
	afs.[CommentModerator] AS [AppealFromSite_CommentModerator],
	afs.[ProcessingDate] AS [AppealFromSite_ProcessingDate],
   (SELECT 
		applicant_id
    FROM dbo.Appeals 
	WHERE Id = (SELECT Appeal_Id FROM [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] WHERE Id = @Id)
	) AS [Applicant_Id],
	afs.[geolocation_lat] AS [AppealFromSite_geolocation_lat],
	afs.[geolocation_lon] AS [AppealFromSite_geolocation_lon],
	b.Id AS ApplicantFromSite_Address_Building,
	aa.Flat AS ApplicantFromSite_Address_Flat,
	abi.is_verified AS isVerify,
	afs.Content AS question_content,
	afs.ObjectId AS Question_Building,
	obj.[name] AS Question_BuildingName
FROM
	[CRM_1551_Site_Integration].[dbo].[AppealsFromSite] afs
	LEFT JOIN [CRM_1551_Site_Integration].[dbo].[ApplicantsFromSite] abi ON abi.Id = afs.ApplicantFromSiteId
	LEFT JOIN   [dbo].[SocialStates] ss ON ss.Id = abi.SocialStateId
	LEFT JOIN   [dbo].[ApplicantPrivilege] ap ON ap.Id = abi.ApplicantPrivilegeId
	LEFT JOIN [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteAddresses] aa ON aa.ApplicantFromSiteId = abi.Id
	LEFT JOIN   [dbo].[SiteAppealsResults] res ON res.id = afs.AppealFromSiteResultId
	LEFT JOIN [CRM_1551_Site_Integration].[dbo].[WorkDirectionTypes] wdt ON wdt.id = afs.WorkDirectionTypeId
	LEFT JOIN   [dbo].[Objects] obj ON obj.Id = afs.ObjectId
	LEFT JOIN   [dbo].[Objects] applicantObj ON applicantObj.builbing_id = aa.BuildingId
	LEFT JOIN dbo.Buildings b ON b.Id = aa.BuildingId
	LEFT JOIN dbo.Streets s ON s.Id = b.street_id
	LEFT JOIN dbo.StreetTypes st ON st.Id = s.street_type_id
	LEFT JOIN dbo.Districts d ON d.Id = s.district_id
WHERE
	afs.Id = @Id
	ORDER BY 5 DESC ;