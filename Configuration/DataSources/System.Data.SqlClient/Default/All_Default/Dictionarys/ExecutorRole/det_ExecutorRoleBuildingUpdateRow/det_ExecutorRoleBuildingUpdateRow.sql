-- det_ExecutorRoleBuildingUpdateRow

  update [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
	set
	      [object_id]=@build_id
      ,[executor_role_id]=@executor_role_id
      ,[executor_id]=@executor_id
	where id=@Id

