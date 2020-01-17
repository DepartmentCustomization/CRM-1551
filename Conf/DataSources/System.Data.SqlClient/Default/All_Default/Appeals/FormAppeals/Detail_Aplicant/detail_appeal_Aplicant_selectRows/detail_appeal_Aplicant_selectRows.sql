--declare @phone_number nvarchar(50) = N'0672170307'

SELECT distinct 
       [Applicants].[Id]
      ,[Applicants].[full_name] as [PIB]
      ,[Buildings].Id as [BuildingsId]
      ,[Buildings].name as [BuildingsName]
	  ,case when [Buildings].[index] is null then N'' else isnull(rtrim([Buildings].[index]),N'')+N', ' end + isnull([StreetTypes].shortname,N'')+N' '+isnull([Streets].name,N'')+N' '+isnull([Buildings].name,N'') 
	  + case when len(isnull([LiveAddress].flat,N'')) = 0 then N'' else N', кв. '+isnull(rtrim([LiveAddress].flat),N'') end
	  as [Adress]
	  ,[SocialStates].[Id] as [SocialStatesId]
	  ,[SocialStates].[name] as [SocialStatesName]
	  ,[ApplicantPrivilege].[Id] as [ApplicantPrivilegeId]
	  ,[ApplicantPrivilege].[Name] as [ApplicantPrivilegeName]
	   ,isnull((select top 1 phone_number from [dbo].[ApplicantPhones] as ApplicantPhones2 
					 where ApplicantPhones2.applicant_id = [Applicants].Id 
					 and ApplicantPhones2.IsMain = 1
					 order by CreatedAt desc),N'«не визначений»') as [phone_number]
	   ,[Districts].Id as [DistrictsId]
	   ,[Districts].name as [DistrictsName]
	   ,[Streets].Id as [StreetsId]
	   ,isnull([StreetTypes].shortname,N'')+N' '+isnull([Streets].name,N'') as [StreetsName]
	   ,[CategoryType].Id as [CategoryTypeId]
	   ,[CategoryType].Name as [CategoryTypeName] 
		,[LiveAddress].house_block	
		,[LiveAddress].entrance	
		,[LiveAddress].flat
		,[Applicants].sex as ApplicantSex
		,[Applicants].birth_date as ApplicantBirth_date
		/*,[Applicants].age as ApplicantAge*/
		,DATEDIFF(YEAR,[Applicants].birth_date, getdate()) as  ApplicantAge
		,[Applicants].mail as ApplicantMail
		,[Applicants].comment as ApplicantComment
		,[applicant_type_id]
		,[ApplicantTypes].name as applicant_type_name
		,(select top 1 [PhoneTypes].Id 
				from [dbo].[ApplicantPhones] as ApplicantPhones2 
				left join [dbo].[PhoneTypes] on [PhoneTypes].id = ApplicantPhones2.phone_type_id
					 where ApplicantPhones2.applicant_id = [Applicants].Id 
					 and ApplicantPhones2.IsMain = 1
					 order by CreatedAt desc)as Applicant_TypePhone_Id
		,(select top 1 [PhoneTypes].name  
				from [dbo].[ApplicantPhones] as ApplicantPhones3
				left join [dbo].[PhoneTypes] on [PhoneTypes].id = ApplicantPhones3.phone_type_id
					 where ApplicantPhones3.applicant_id = [Applicants].Id 
					 and ApplicantPhones3.IsMain = 1
					 order by CreatedAt desc) as Applicant_TypePhone_Name
		,(select top 1 phone_number from [dbo].[ApplicantPhones] as ApplicantPhones2 
					 where ApplicantPhones2.applicant_id = [Applicants].Id 
					 and ApplicantPhones2.IsMain = 0
					 order by CreatedAt desc) as Applicant_AdditionalPhone
		,(select top 1 [PhoneTypes].Id 
				from [dbo].[ApplicantPhones] as ApplicantPhones2 
				left join [dbo].[PhoneTypes] on [PhoneTypes].id = ApplicantPhones2.phone_type_id
					 where ApplicantPhones2.applicant_id = [Applicants].Id 
					 and ApplicantPhones2.IsMain = 0
					 order by CreatedAt desc) as Applicant_AdditionalTypePhone_Id
		,(select top 1 [PhoneTypes].name  
				from [dbo].[ApplicantPhones] as ApplicantPhones3
				left join [dbo].[PhoneTypes] on [PhoneTypes].id = ApplicantPhones3.phone_type_id
					 where ApplicantPhones3.applicant_id = [Applicants].Id 
					 and ApplicantPhones3.IsMain = 0
					 order by CreatedAt desc) as Applicant_AdditionalTypePhone_Name
		,stuff((select N', '+p.[phone_number]
					from [dbo].[ApplicantPhones] p
					where p.applicant_id=[Applicants].Id 
					for xml path('')), 1,1,N'') [AllPhones]
		,(select top 1 ApplicantPhones12.phone_number from [dbo].[ApplicantPhones] as ApplicantPhones12 
					 where ApplicantPhones12.applicant_id = [Applicants].Id 
					 and ApplicantPhones12.IsMain = 1
					 order by CreatedAt desc) as Applicant_IsMainPhone			


  FROM [dbo].[Applicants]
  left join [dbo].[ApplicantPhones] on [ApplicantPhones].applicant_id = [Applicants].Id /*and [ApplicantPhones].IsMain = 1*/
  --left join [dbo].[PhoneTypes] on [PhoneTypes].id = [ApplicantPhones].phone_type_id
  
  left join [dbo].[LiveAddress] on [LiveAddress].applicant_id = [Applicants].Id
  left join [dbo].[Buildings] on [Buildings].Id = [LiveAddress].building_id
  left join [dbo].[Streets] on [Streets].Id = [Buildings].street_id
  left join [dbo].[StreetTypes] on [StreetTypes].Id = [Streets].street_type_id
  left join [dbo].[Districts] on [Districts].Id = [Streets].district_id
  left join [dbo].[ApplicantPrivilege] on [ApplicantPrivilege].Id = [Applicants].applicant_privilage_id
  left join [dbo].[ApplicantCategories] on [ApplicantCategories].applicant_id = [Applicants].Id
  --left join [dbo].[CategoryType] on [CategoryType].Id = [ApplicantCategories].categoryType_id
  left join [dbo].[CategoryType] on [CategoryType].Id = [Applicants].category_type_id
  left join [dbo].[SocialStates] on [SocialStates].Id = [Applicants].social_state_id
  left join [dbo].[ApplicantTypes] on [Applicants].applicant_type_id=[ApplicantTypes].Id
  --left join (select 1 from [dbo].[ApplicantPhones] as ApplicantPhones2 
		--	 where ApplicantPhones2.applicant_id = [Applicants].Id 
		--	 and ApplicantPhones2.IsMain = 0) as ap2
 where ApplicantPhones.phone_number = @phone_number
 and 
	#filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only