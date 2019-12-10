insert into [PersonExecutorChooseQT]
  (
  [person_executor_choose_id]
      ,[question_type_id]
      ,[user_id]
      ,[create_date]
      ,[user_edit_id]
      ,[edit_date]
  )

  select @person_executor_choose_id
      ,@question_type_id
      ,@user_id
      ,GETUTCDATE()
      ,@user_id
      ,GETUTCDATE()