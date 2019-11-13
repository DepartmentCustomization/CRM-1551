SELECT [LiveAddress].[Id]
	  ,Districts.name as districts_name
	  ,Streets.name + ', ' + Buildings.name as building
	  ,[LiveAddress].[flat]
      ,[LiveAddress].[house_block]
      ,[LiveAddress].[entrance]
      ,[LiveAddress].[main]
      ,[LiveAddress].[active]
  FROM [dbo].[LiveAddress]
	left join Applicants on Applicants.Id = LiveAddress.applicant_id
	left join Buildings on Buildings.Id	= LiveAddress.building_id
	left join Districts on Districts.Id = Buildings.district_id
	left join Streets on Streets.Id = Buildings.street_id
WHERE LiveAddress.applicant_id = @applicant_id
and #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only