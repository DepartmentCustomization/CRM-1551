declare @output table (Id int)

INSERT INTO [dbo].[Applicants]
           (
		    [registration_date]
           ,[full_name]
           ,[applicant_type_id]
           ,[applicant_category_id]
           ,[social_state_id]
           ,[mail]
           ,[sex]
           ,[birth_date]
           ,[age]
           ,[comment]
           ,[user_id]
           ,[edit_date]
           ,[user_edit_id]
		   )
output [inserted].[Id] into @output (Id)
     VALUES
           (
		    GETUTCDATE()
           ,@full_name
           ,@types_id
           ,@category_id
           ,@states_id
           ,@mail
           ,@sex
           ,@birth_date
           ,isnull(@age, DATEDIFF(year,isnull(@birth_date, null),getutcdate()) )
           ,@comment
           ,@user_id
           ,GETUTCDATE()
           ,@user_edit_id
		   )
declare @app_id int;
set @app_id = (select top 1 Id from @output )

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

INSERT INTO [dbo].[LiveAddress]
           ([applicant_id]
           ,[building_id]
           ,[house_block]
           ,[entrance]
           ,[flat]
           ,[main]
           ,[active])
     VALUES
           (@app_id
           ,@building_id
           ,@house_block
           ,@entrance
           ,@flat
           ,@main
           ,@active
		   )
		   
update  [dbo].[Appeals]
      set  applicant_id = @app_id
     where Id = @appeals

-- select @app_id	as [Id]
-- return;