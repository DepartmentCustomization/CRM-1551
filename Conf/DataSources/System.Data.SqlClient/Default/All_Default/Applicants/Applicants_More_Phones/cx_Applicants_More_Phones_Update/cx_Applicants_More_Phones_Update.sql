UPDATE
	[dbo].[ApplicantPhones]
SET
	[phone_type_id] = @phone_type_id,
	[phone_number] = @phone_number,
	[edit_date] = GETUTCDATE(),
	[user_edit_id] = @user_id
WHERE
	Id = @Id;