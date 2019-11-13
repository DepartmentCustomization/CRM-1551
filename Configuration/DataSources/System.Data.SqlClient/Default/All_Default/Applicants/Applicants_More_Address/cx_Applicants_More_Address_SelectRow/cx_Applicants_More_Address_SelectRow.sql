 SELECT [LiveAddress].[Id]
	  ,[LiveAddress].applicant_id
	  ,Districts.name as districts_name
	  ,Districts.Id as districts_id
      ,Buildings.name as buildings_name
	  ,Buildings.Id as building_address
	  ,concat(StreetTypes.shortname, N' ', Streets.name, N' ', 
	   Buildings.number,isnull(Buildings.letter, null)) as building_address_name
	  ,[LiveAddress].[flat]
      ,[LiveAddress].[house_block]
      ,[LiveAddress].[entrance]
      ,[LiveAddress].[main]
      ,[LiveAddress].[active]
  FROM [dbo].[LiveAddress]
	left join Applicants on Applicants.Id = LiveAddress.applicant_id
	left join Buildings on Buildings.Id	= LiveAddress.building_id
	left join Districts on Districts.Id = Buildings.district_id
	left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=Streets.Id
    left join [CRM_1551_Analitics].[dbo].[StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
  WHERE LiveAddress.Id = @Id