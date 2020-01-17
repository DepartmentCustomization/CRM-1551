

update [Applicants] 
      SET     [full_name] = @full_name
           ,[applicant_type_id] = @applicant_type_id
           ,[applicant_category_id] = @applicant_category_id
           ,[social_state_id] = @social_state_id
           ,[mail] = @mail
           ,[sex] = @sex
           ,[birth_date] = @birth_date
           ,[age] = @age
           ,[comment] = @comment
           ,[edit_date] = GETUTCDATE()
           ,[user_edit_id] = @user_edit_id
		where Id = @applicant_id

update [LiveAddress] 
   set       [building_id] = @building_id
           ,[house_block] = @house_block
           ,[entrance] = @entrance
           ,[flat] = @flat
		where applicant_id = @applicant_id

update[Appeals]
    set       [receipt_source_id] = @receipt_source_id
          -- ,[phone_number] = @phone_number
           ,[mail] = @mail
           ,[enter_number] = @enter_number
           ,[submission_date] = @submission_date
           ,[start_date] = @start_date
           ,[end_date] = @end_date
           ,[article] = @article
           ,[sender_name] = @sender_name
           ,[sender_post_adrress] = @sender_post_adrress
           ,[city_receipt] = @city_receipt
           ,[edit_date] = getutcdate()
           ,[user_edit_id] = @user_edit_id
		where applicant_id = @applicant_id


update [Questions]
     set      [receipt_date] = @receipt_date
           ,[question_state_id] = @question_state_id
           ,[control_date] = @control_date
           ,[object_id] = @object_id
           ,[object_comment] = @object_comment
           ,[organization_id] = @organization_id
           ,[application_town_id] = @application_town_id
           ,[event_id] = @event_id
           ,[question_type_id] = @question_type_id
           ,[question_content] = @question_content
           ,[answer_form_id] = @answer_form_id
           ,[answer_phone] = @answer_phone
           ,[answer_post] = @answer_post
           ,[answer_mail] = @answer_mail
           ,[edit_date] = GETUTCDATE()
           ,[user_edit_id] = @user_edit_id
		where appeal_id = (select Id from Appeals where applicant_id = @applicant_id)
