UPDATE [dbo].[Appeals]
   SET [mail] = @mail
       ,applicant_id = @applicant_id
      ,[enter_number] = @enter_number
      ,[end_date] = @end_date
      ,[article] = @article
      ,[sender_name] = @sender_name
      ,[sender_post_adrress] = @sender_post_adrress
      ,[city_receipt] = @city_receipt
      ,[edit_date] = getutcdate()
      ,[user_edit_id] = @user_edit_id
 WHERE Id = @Id