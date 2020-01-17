SELECT [Applicants].[Id]
      ,[Applicants].[registration_date]
      ,[Applicants].[full_name]
	  , ApplicantPhones.phone_number
	  , PhoneTypes.name as phone_type_name
	    ,PhoneTypes.Id as phone_type_id
      ,[Applicants].[mail]

	  , Districts.name as district_name
	    ,Districts.Id as district_id

	  , Buildings.name as building_name
	    ,Buildings.Id as building_id
	    
	  , LiveAddress.flat
	  , LiveAddress.house_block
	  , LiveAddress.entrance

	  , ApplicantTypes.name as types_name
		,ApplicantTypes.Id as types_id
      , ApplicantCategories.name as category_name
		, ApplicantCategories.Id as category_id
      , SocialStates.name as states_name
		, SocialStates.Id as states_id
      ,[Applicants].[sex]
      ,[Applicants].[birth_date]
      ,[Applicants].[age]
      ,[Applicants].[comment]

      ,[Applicants].[user_id]
      ,[Applicants].[edit_date]
      ,[Applicants].[user_edit_id]
  FROM [dbo].[Applicants]
	left join ApplicantTypes on ApplicantTypes.Id = Applicants.applicant_type_id
	left join ApplicantCategories on ApplicantCategories.Id = Applicants.applicant_category_id
	left join SocialStates on SocialStates.Id = Applicants.social_state_id
	left join ApplicantPhones on ApplicantPhones.applicant_id = Applicants.Id
	left join PhoneTypes on PhoneTypes.Id = ApplicantPhones.phone_type_id
	left join LiveAddress on LiveAddress.applicant_id = Applicants.Id
	left join Buildings on Buildings.Id = LiveAddress.building_id
	left join Districts on Districts.Id = Buildings.district_id
--WHERE [Applicants].[Id] = @Id or [Applicants].[Id] = @appl_id