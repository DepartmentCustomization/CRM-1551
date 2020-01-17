SELECT ApplicantPhones.[Id]
      ,Applicants.full_name
      ,Applicants.Id as appl_id
      ,Workers.name as user_id
-- 	  ,convert(nvarchar(10), Applicants.registration_date, 104) as registration_date
	  ,Applicants.registration_date
  FROM [dbo].[ApplicantPhones]
	left join Applicants on Applicants.Id = ApplicantPhones.applicant_id
	left join Workers on Workers.worker_user_id = Applicants.user_id
where ApplicantPhones.[phone_number] = @phone --and Applicants.Id <> @Id
and #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only