declare @output table (Id int);
declare @outputAppeals table (Id int);
declare @outputQuestion table (Id int);

INSERT INTO [dbo].[Applicants]
           ([registration_date]
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
           ,[user_edit_id])
		output inserted.Id into @output (Id)
     VALUES
           (getutcdate()
           ,@full_name
           ,@applicant_type_id
           ,@applicant_category_id
           ,@social_state_id
           ,@mail
           ,@sex
           ,@birth_date
           ,isnull(@age, DATEDIFF(year,isnull(@birth_date, null),getutcdate()) )
           ,@comment
           ,@user_id
           ,GETUTCDATE()
           ,@user_edit_id
		   )

declare @applicant_id int
set @applicant_id = (select top 1 Id from @output)

insert into [dbo].[ApplicantPhones]
			([applicant_id]
           ,[phone_type_id]
           ,[phone_number])
	output [inserted].[Id]
     VALUES
           (@applicant_id
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
           (@applicant_id
           ,@building_id
           ,@house_block
           ,@entrance
           ,@flat
           ,@main
           ,@active
		   )



INSERT INTO [dbo].[Appeals]
           ([applicant_id]
           ,[registration_date]
           --,[registration_number]
           ,[receipt_source_id]
           ,[phone_number]
           ,[mail]
           ,[enter_number]
           ,[submission_date]
           ,[receipt_date]
           ,[start_date]
           ,[end_date]
           ,[article]
           ,[sender_name]
           ,[sender_post_adrress]
           ,[city_receipt]
           ,[user_id]
           ,[edit_date]
           ,[user_edit_id])
output [inserted].[Id] into @outputAppeals (Id)
     VALUES
           (@applicant_id
           ,getutcdate() --@registration_date
           --,@registration_number
           ,@receipt_source_id
           ,@phone_number
           ,@mail
           ,@enter_number
           ,@submission_date
           ,getutcdate() -- @receipt_date
           ,@start_date
           ,@end_date
           ,@article
           ,@sender_name
           ,@sender_post_adrress
           ,@city_receipt
           ,@user_id
           ,getutcdate() -- @edit_date
           ,@user_edit_id
		   )
declare @appeal_id int
set @appeal_id = (select top 1 Id from @outputAppeals)

update [dbo].[Appeals] set registration_number =  concat( YEAR(getdate()),'-',MONTH(getdate()),'/',@appeal_id  ) where Id =  @appeal_id

INSERT INTO [dbo].[Questions]
           ([appeal_id]
           ,[registration_date]
           ,[receipt_date]
           ,[question_state_id]
           ,[control_date]
           ,[object_id]
           ,[object_comment]
           ,[organization_id]
           ,[application_town_id]
           ,[event_id]
           ,[question_type_id]
           ,[question_content]
           ,[answer_form_id]
           ,[answer_phone]
           ,[answer_post]
           ,[answer_mail]
           ,[user_id]
           ,[edit_date]
           ,[user_edit_id])
output [inserted].[Id] into @outputQuestion (Id)
     VALUES
           (@appeal_id
           ,GETUTCDATE()
           ,isnull(@receipt_date, getutcdate())
           ,@question_state_id
           ,@control_date
           ,@object_id
           ,@object_comment
           ,@organization_id
           ,@application_town_id
           ,@event_id
           ,@question_type_id
           ,@question_content
           ,@answer_form_id
           ,@answer_phone
           ,@answer_post
           ,@answer_mail
           ,@user_id
           ,GETUTCDATE() -- @edit_date
           ,@user_edit_id
		   )

declare @quest_id int;
SET @quest_id = (select top 1 Id from @outputQuestion)

update [dbo].[Questions] set [registration_number] = concat ( (select registration_number from Appeals where Id = @appeal_id ),'/',
																(select case when count(*) = 0 then 1 else count(*) end 
																	from [Questions] where appeal_id = @appeal_id) )
															where Id = @quest_id;

select @applicant_id as Id
return;
