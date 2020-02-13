SELECT [LiveAddress].[Id]
	  ,Districts.name AS districts_name
	  ,Streets.name + ', ' + Buildings.name AS building
	  ,[LiveAddress].[flat]
      ,[LiveAddress].[house_block]
      ,[LiveAddress].[entrance]
      ,[LiveAddress].[main]
      ,[LiveAddress].[active]
  FROM [dbo].[LiveAddress]
	LEFT JOIN Applicants ON Applicants.Id = LiveAddress.applicant_id
	LEFT JOIN Buildings ON Buildings.Id	= LiveAddress.building_id
	LEFT JOIN Districts ON Districts.Id = Buildings.district_id
	LEFT JOIN Streets ON Streets.Id = Buildings.street_id
WHERE LiveAddress.applicant_id = @applicant_id AND [LiveAddress].main='false'
AND #filter_columns#
     #sort_columns#
 OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY