--declare @phone nvarchar(100);

select [Applicants].Id
	  ,[Applicants].full_name
-- 	  ,[Districts].name DistrictsName
-- 	  ,[Streets].name StrictName
-- 	  ,[Buildings].number BuildNumber
-- 	  ,[LiveAddress].house_block
-- 	  ,[LiveAddress].entrance
-- 	  ,[LiveAddress].flat

	  ,concat('р-н. ' + [Districts].name, ', '+ StreetTypes.shortname +' ' + [Streets].name, 
	  ', буд.' + [Buildings].name, ', під.' + rtrim([LiveAddress].entrance), ', кв.' + [LiveAddress].flat
	   ) as Building

	  ,[ApplicantPrivilege].Name Privilege
	  ,[SocialStates].name [SocialStates]

  from [CRM_1551_Analitics].[dbo].[Applicants]
 left join [dbo].[ApplicantPhones] on [Applicants].Id=[ApplicantPhones].applicant_id
  left join [dbo].[PhoneTypes] on [ApplicantPhones].phone_type_id=[PhoneTypes].Id
  left join [dbo].[LiveAddress] on [Applicants].Id=[LiveAddress].[applicant_id]
  left join [dbo].[Buildings] on [LiveAddress].building_id=[Buildings].Id
  left join [dbo].[Districts] on [Buildings].district_id=Districts.Id
  left join [dbo].[Streets] on [Buildings].street_id=[Streets].Id
  left join StreetTypes on StreetTypes.Id = Streets.street_type_id
  left join [dbo].[ApplicantTypes] on [Applicants].applicant_type_id=[ApplicantTypes].Id


  left join [dbo].[CategoryType] on [Applicants].category_type_id=[CategoryType].Id
  left join [dbo].[ApplicantPrivilege] on [Applicants].applicant_privilage_id=[ApplicantPrivilege].Id
  left join [dbo].[SocialStates] on [Applicants].social_state_id=[SocialStates].Id

  where ApplicantPhones.phone_number=@phone
