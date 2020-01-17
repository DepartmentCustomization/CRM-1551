SELECT [Applicants].[Id]
      ,[Applicants].[full_name]

  FROM [dbo].[Applicants]
	left join ApplicantPhones on ApplicantPhones.applicant_id = Applicants.Id
	where ApplicantPhones.phone_number = @phone_number
		and 
	 #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only