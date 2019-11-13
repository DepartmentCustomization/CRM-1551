insert into [dbo].[ApplicantPhones]
			([applicant_id]
           ,[phone_type_id]
           ,[phone_number])
	output [inserted].[Id]
     VALUES
           (@app_id
           ,@phone_type_id
           ,@phone_number 
		   )