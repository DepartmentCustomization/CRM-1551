update [PersonExecutorChooseQT]
  set [person_executor_choose_id] = @person_executor_choose_id
      ,[question_type_id] = @question_type_id
      ,[user_id]= @user_id
      ,[create_date]= GETUTCDATE()
      ,[user_edit_id]=@user_id
      ,[edit_date]= GETUTCDATE()
  where Id=@Id