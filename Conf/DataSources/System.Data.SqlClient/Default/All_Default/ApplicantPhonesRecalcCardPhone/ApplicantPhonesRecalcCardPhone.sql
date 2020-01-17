select stuff((select N', '+p.[phone_number]
					from [dbo].[ApplicantPhones] p
					where p.applicant_id=@Applicant_id
					for xml path('')), 1,2,N'') [AllPhones]