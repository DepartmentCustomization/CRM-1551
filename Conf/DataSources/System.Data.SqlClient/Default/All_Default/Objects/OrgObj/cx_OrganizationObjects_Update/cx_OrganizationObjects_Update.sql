update [ExecutorInRoleForObject]
  set [executor_id]= @org_id
           ,[executor_role_id]= @conn_type_id
  where Id=@Id

