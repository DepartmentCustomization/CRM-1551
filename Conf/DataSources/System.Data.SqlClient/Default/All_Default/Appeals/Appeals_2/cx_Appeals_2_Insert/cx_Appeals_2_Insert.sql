DECLARE @output TABLE (Id INT);
DECLARE @outputAppeals TABLE (Id INT);
DECLARE @outputQuestion TABLE (Id INT);

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
		OUTPUT inserted.Id INTO @output (Id)
     VALUES
           (getutcdate()
           ,@full_name
           ,@applicant_type_id
           ,@applicant_category_id
           ,@social_state_id
           ,@mail
           ,@sex
           ,@birth_date
           ,ISNULL(@age, DATEDIFF(year,isnull(@birth_date, NULL),getutcdate()) )
           ,@comment
           ,@user_id
           ,GETUTCDATE()
           ,@user_edit_id
		   );

DECLARE @applicant_id INT;
SET @applicant_id = (SELECT TOP 1 Id FROM @output);

INSERT INTO [dbo].[ApplicantPhones]
			([applicant_id]
           ,[phone_type_id]
           ,[phone_number])
	output [inserted].[Id]
     VALUES
           (@applicant_id
           ,@phone_type_id
           ,@phone_number 
		   );

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
		   );



INSERT INTO [dbo].[Appeals]
           ([applicant_id]
           ,[registration_date]
           ,[registration_number]
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
           ,[user_edit_id]
           ,[LogUpdated_Query])
OUTPUT [inserted].[Id] INTO @outputAppeals (Id)
     VALUES
           (@applicant_id
           ,getutcdate() --@registration_date
           ,(
select 
case when not exists(
				select top 1 LTRIM(RIGHT(YEAR(getutcdate()),1))+N'-'+ltrim(substring(registration_number, 3, len(registration_number)-2)*1+1)
				from [dbo].[Appeals]
				where left(registration_number, 1) in (right(ltrim(year(getutcdate())),1))
				order by id desc
				)
			then LTRIM(RIGHT(YEAR(getutcdate()),1))+N'-1'
			else (select top 1 LTRIM(RIGHT(YEAR(getutcdate()),1))+N'-'+ltrim(substring(registration_number, 3, len(registration_number)-2)*1+1)
				from [dbo].[Appeals]
				where left(registration_number, 1) in (right(ltrim(year(getutcdate())),1))
				order by id desc)
			end
)
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
           ,N'query_cx_Appeals_2_Insert'
		   );
DECLARE @appeal_id INT;
SET @appeal_id = (SELECT TOP 1 Id FROM @outputAppeals);

-- UPDATE [dbo].[Appeals] 
-- SET registration_number =  CONCAT( YEAR(GETDATE()),'-',MONTH(GETDATE()),'/',@appeal_id  ) 
-- ,edit_date=GETUTCDATE()
-- WHERE Id =  @appeal_id;

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
OUTPUT [inserted].[Id] INTO @outputQuestion (Id)
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
		   );

DECLARE @quest_id INT;
SET @quest_id = (SELECT TOP 1 Id FROM @outputQuestion);

UPDATE [dbo].[Questions] 
SET [registration_number] = 
CONCAT ( 
      (SELECT registration_number 
      FROM Appeals Appeals
      WHERE Id = @appeal_id ) 
      ,'/',
      (SELECT CASE WHEN COUNT(*) = 0 THEN 1 ELSE count(*) END 
      FROM [Questions] Questions
      WHERE appeal_id = @appeal_id) ),
      [edit_date]=getutcdate()

WHERE Id = @quest_id;

SELECT @applicant_id AS Id;
RETURN;
