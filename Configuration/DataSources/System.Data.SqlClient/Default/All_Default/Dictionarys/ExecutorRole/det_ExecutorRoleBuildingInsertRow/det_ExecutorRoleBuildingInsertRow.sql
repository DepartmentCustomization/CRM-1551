  -- det_ExecutorRoleBuildingInsertRow

  insert into [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
  (
  [object_id]
      ,[executor_role_id]
      ,[executor_id]
  )

  select 
      @build_id
      ,@executor_role_id
      ,@executor_id