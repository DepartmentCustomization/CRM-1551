SELECT [ApplicantPhones].[Id]
      ,PhoneTypes.name as phone_type_name
      ,[ApplicantPhones].[phone_number]
  FROM [dbo].[ApplicantPhones]
	left join PhoneTypes on PhoneTypes.Id = ApplicantPhones.phone_type_id
WHERE [ApplicantPhones].applicant_id = @app_info
    and  
	 #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
