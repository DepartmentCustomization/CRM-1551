UPDATE [dbo].[ApplicantPhones]
set [phone_type_id] = @phone_type_id
	,[phone_number] = @phone_number
where Id = @Id