declare @output table (Id int)

INSERT INTO [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
       ([ReceiptDate]
      ,[ApplicantFromSiteId]
      ,[WorkDirectionTypeId]
      ,[ObjectId]
      ,[Content]
      ,[Appeal_Id]
      ,[AppealFromSiteResultId]
      ,[CommentModerator]
      ,[ProcessingDate]
      ,[EditByDate]
      ,[EditByUserId])
         output inserted.Id into @output (Id)
     VALUES
           (GETUTCDATE()
        --   ,@registration_number
           ,@name
           ,@phone_number
           ,@mail
           ,@applicant_adrress
           ,@aditional_Information
           ,@question_direction
           ,@problem_place
           ,@appeal_content
           ,@appeal_id
           ,@state_id
           ,@comment_moderator
           ,GETUTCDATE()
           ,@user_id
           ,GETUTCDATE()
           ,@user_edit_id)
           
declare @reg_id int;
set @reg_id = (select top 1 Id from @output)

--update AppealsFromSite set registration_number = @reg_id where Id = @reg_id
return;