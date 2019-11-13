if( select [real_end_date] from [Events] where Id = @Id) is not null
begin
	return
end
else
begin 

UPDATE [dbo].[Events]
      SET   
           [plan_end_date]= @plan_end_date
        --   ,[real_end_date]= @real_end_date
           --,[active]= @active
        --   ,[comment]= @comment
        --   ,[area]  = @area
          ,[user_id]= @user_id
           ,[audio_start_date]= @audio_start_date
           ,[audio_end_date]= @audio_end_date
           ,[Standart_audio]= @Standart_audio
           ,[say_liveAddress_id]= @say_liveAddress_id
           ,[say_organization_id]  = @say_organization_id
           ,[say_phone_for_information] = @say_phone_for_information
           ,[phone_for_information] = @phone_for_information
           ,[say_plan_end_date]= @say_plan_end_date
           ,[audio_on] = @audio_on
           ,[executor_comment]=@coment_executor
           --,[File] = @file
		WHERE Id = @Id

end