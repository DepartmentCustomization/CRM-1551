--declare @Id int = 39


SELECT afs.Id
	   ,ltrim(rtrim(isnull(abi.surname,N'') + ' ' + isnull(abi.firstname,N'') + ' ' + isnull(abi.fathername,N''))) as ApplicantFromSite_PIB
	   ,case when len(isnull(stuff((select N' ,'+p.[PhoneNumber]
									from [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] p
										where p.ApplicantFromSiteId=abi.Id
										and len(isnull(p.PhoneNumber,N'')) > 0
										and p.MoreContactTypeId = 1
										for xml path('')), 2,1,N''),N'')) > 0
					then N'Основний: ('+isnull(stuff((select N' ,'+p.[PhoneNumber]
										from [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] p
										where p.ApplicantFromSiteId=abi.Id
										and len(isnull(p.PhoneNumber,N'')) > 0
										and p.MoreContactTypeId = 1
										for xml path('')), 2,1,N''),N'')+N'); ' 
					else N'' end
					+
					case when len(isnull(stuff((select N' ,'+p.[PhoneNumber]
										from [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] p
										where p.ApplicantFromSiteId=abi.Id
										and len(isnull(p.PhoneNumber,N'')) > 0
										and p.MoreContactTypeId = 2
										for xml path('')), 2,1,N''),N'')) > 0
					then  N'Додатковий: ('+isnull(stuff((select N' ,'+p.[PhoneNumber]
										from [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] p
										where p.ApplicantFromSiteId=abi.Id
										and len(isnull(p.PhoneNumber,N'')) > 0
										and p.MoreContactTypeId = 2
										for xml path('')), 2,1,N''),N'')+N'); ' 
					else N'' end as [ApplicantFromSite_Phone]

      ,case when len(isnull(stuff((select N' ,'+p.[Mail]
									from [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] p
										where p.ApplicantFromSiteId=abi.Id
										and len(isnull(p.[Mail],N'')) > 0
										and p.MoreContactTypeId = 1
										for xml path('')), 2,1,N''),N'')) > 0
					then N'Основний: ('+isnull(stuff((select N' ,'+p.[Mail]
										from [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] p
										where p.ApplicantFromSiteId=abi.Id
										and len(isnull(p.[Mail],N'')) > 0
										and p.MoreContactTypeId = 1
										for xml path('')), 2,1,N''),N'')+N'); ' 
					else N'' end
					+
					case when len(isnull(stuff((select N' ,'+p.[Mail]
										from [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] p
										where p.ApplicantFromSiteId=abi.Id
										and len(isnull(p.[Mail],N'')) > 0
										and p.MoreContactTypeId = 2
										for xml path('')), 2,1,N''),N'')) > 0
					then  N'Додатковий: ('+isnull(stuff((select N' ,'+p.[Mail]
										from [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] p
										where p.ApplicantFromSiteId=abi.Id
										and len(isnull(p.[Mail],N'')) > 0
										and p.MoreContactTypeId = 2
										for xml path('')), 2,1,N''),N'')+N'); ' 
					else N'' end as [ApplicantFromSite_Mail]
      ,isnull(stuff((select N';'+isnull(aa.Region + ' обл., ', N'') + isnull(aa.District + ' р-н, ', N'') 
								   + isnull(' місто ' + aa.CityName +',', N'') + isnull(' вул. ' + aa.StreetName, N'') 
								   + isnull(' буд. ' + aa.BuildingName, N'')
										from [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteAddresses] aa
										where aa.ApplicantFromSiteId=abi.Id
										for xml path('')), 1,1,N''),N'') as [ApplicantFromSite_Address]
	  ,abi.sex as [ApplicantFromSite_Sex]
	  ,abi.birthdate as [ApplicantFromSite_Birthdate]
	  ,(year(current_timestamp) - year(abi.birthdate)) as [ApplicantFromSite_Age]
	  ,ss.id as [ApplicantFromSite_SocialState]
	  ,ss.name as [ApplicantFromSite_SocialStateName]
	  ,ap.id as [Applicant_Privilege]
	  ,ap.name as [Applicant_PrivilegeName]

	  ,afs.Id as [AppealFromSite_Id]
      ,afs.[ReceiptDate] as [AppealFromSite_ReceiptDate]
	  ,wdt.id as [AppealFromSite_WorkDirectionType]
      ,wdt.name as [AppealFromSite_WorkDirectionTypeName]
      ,obj.id as [AppealFromSite_Object]
	  ,obj.name as [AppealFromSite_ObjectName]
      ,afs.[Content] as [AppealFromSite_Content]
      ,afs.[Appeal_Id] as [Appeal_Id]
	  ,res.[Id] as [AppealFromSite_SiteAppealsResult]
      ,res.[name] as [AppealFromSite_SiteAppealsResultName]
      ,afs.[CommentModerator] as [AppealFromSite_CommentModerator]
      ,afs.[ProcessingDate] as [AppealFromSite_ProcessingDate]
      ,(select top 1 ApplicantId from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] where Id = @Id) as [Applicant_Id]
	  ,afs.[geolocation_lat] as [AppealFromSite_geolocation_lat]
	  ,afs.[geolocation_lon] as [AppealFromSite_geolocation_lon]
  FROM [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] afs
  left join [CRM_1551_Site_Integration].[dbo].[ApplicantsFromSite] abi on abi.Id = afs.ApplicantFromSiteId 
  left join [CRM_1551_Analitics].[dbo].[SocialStates] ss on ss.Id = abi.SocialStateId
  left join [CRM_1551_Analitics].[dbo].[ApplicantPrivilege] ap on ap.Id = abi.ApplicantPrivilegeId
  left join [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteAddresses] aa on aa.ApplicantFromSiteId = abi.Id
  left join [CRM_1551_Analitics].[dbo].[SiteAppealsResults] res on res.id = afs.AppealFromSiteResultId
  left join [CRM_1551_Site_Integration].[dbo].[WorkDirectionTypes] wdt on wdt.id = afs.WorkDirectionTypeId
  left join [CRM_1551_Analitics].[dbo].[Objects] obj on obj.Id = afs.ObjectId
	where afs.Id = @Id