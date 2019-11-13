
INSERT INTO [dbo].[ApplicantPhones]
           ([applicant_id]
           ,[phone_type_id]
           ,[phone_number])
output [inserted].[Id]
     VALUES
           (@applicant_id
           ,@phone_type_id
           ,@phone_number
		   )

 

