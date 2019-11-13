declare @output table (Id int)

INSERT INTO [dbo].[Applicants]
           ([registration_date]
           ,[full_name]
           ,[applicant_type_id]
           ,[applicant_category_id]
           ,[social_state_id]
           ,[sex]
           ,[user_id]
           ,[edit_date]
           ,[user_edit_id])
	output inserted.Id into @output (Id)
     VALUES
           (getutcdate()
           ,@n_full_name
           ,@n_applicant_type_id
           ,@n_applicant_category_id
           ,@n_social_state_id
           ,@n_sex
           ,@user_id
           ,getutcdate()
           ,@user_edit_id)

declare @id_app int
set @id_app = (select Id from @output)

insert into dbo.ApplicantPhones (applicant_id, phone_number)
	VALUES (@id_app, @n_phone_number)