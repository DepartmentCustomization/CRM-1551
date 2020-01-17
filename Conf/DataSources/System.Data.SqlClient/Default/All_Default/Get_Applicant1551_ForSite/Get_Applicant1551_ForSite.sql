--declare @ApplicantId int = 1490249


select (select top 1 full_name FROM [dbo].[Applicants] where Id = @ApplicantId) as [1551_Applicant_PIB],
		stuff((select N' ,'+p.phone_number
									from [dbo].[ApplicantPhones] p
										where p.applicant_id=@ApplicantId
										and len(isnull(p.phone_number,N'')) > 0
										for xml path('')), 2,1,N'') as [1551_Applicant_Phone],
      stuff((select N' ,'+case when [Buildings].[index] is null then N'' else isnull(rtrim([Buildings].[index]),N'')+N', ' end + isnull([StreetTypes].shortname,N'')+N' '+isnull([Streets].name,N'')+N' '+isnull([Buildings].name,N'') 
	  + case when len(isnull([LiveAddress].flat,N'')) = 0 then N'' else N', кв. '+isnull(rtrim([LiveAddress].flat),N'') end
									from [dbo].[Applicants] p
									left join [dbo].[LiveAddress] on [LiveAddress].applicant_id = p.Id
									left join [dbo].[Buildings] on [Buildings].Id = [LiveAddress].building_id
									left join [dbo].[Streets] on [Streets].Id = [Buildings].street_id
									left join [dbo].[StreetTypes] on [StreetTypes].Id = [Streets].street_type_id
									left join [dbo].[Districts] on [Districts].Id = [Streets].district_id
									where p.id=@ApplicantId
									for xml path('')), 2,1,N'') as [1551_Applicant_Address]
