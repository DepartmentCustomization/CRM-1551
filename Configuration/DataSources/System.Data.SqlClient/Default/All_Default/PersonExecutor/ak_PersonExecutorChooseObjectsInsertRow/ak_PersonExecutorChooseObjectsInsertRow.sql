  insert into [PersonExecutorChooseObjects]
  (
  [person_executor_choose_id]
      ,[object_id]
      ,[user_id]
      ,[create_date]
      ,[user_edit_id]
      ,[edit_date]
  )

  select @person_executor_choose_id
      ,@object_id
      ,@user_id
      ,GETUTCDATE()
      ,@user_id
      ,GETUTCDATE()