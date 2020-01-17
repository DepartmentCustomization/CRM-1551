declare @output table (Id int)

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
output [inserted].[Id] into @output (Id)
     VALUES
           (@appeal_id
           ,GETUTCDATE() -- @registration_date
        --   ,isnull(@receipt_date, getutcdate() )
           ,@receipt_date
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
SET @quest_id = (select top 1 Id from @output)

-- update [dbo].[Questions] set [registration_number] = concat ( (select registration_number from Appeals where Id = @appeal_id )
--                                                         ,'/', @quest_id) 
--                                                         where Id = @quest_id;

	update [dbo].[Questions] set [registration_number] = concat ( (select registration_number from Appeals where Id = @appeal_id ),'/',
																(select case when count(*) = 0 then 1 else count(*)+1 end 
																	from [Questions] where appeal_id = @appeal_id) )
															where Id = @quest_id;

select @quest_id as [Id]
return;