update [PersonExecutorChoose]
	  set [name]= @name
      ,[organization_id]= @organization_id
      ,[position_id]= @position_id
      --,[user_id]
      --,[create_date]
      ,[user_edit_id]=@user_id
      ,[edit_date]=GETUTCDATE()
	  where Id=@Id