SELECT Applicants.[Id]
      ,Applicants.full_name
  FROM [dbo].[Applicants]
	left join ApplicantPhones on Applicants.Id = ApplicantPhones.applicant_id
where [phone_number] = @phone --and Applicants.Id <> @Id
and #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only