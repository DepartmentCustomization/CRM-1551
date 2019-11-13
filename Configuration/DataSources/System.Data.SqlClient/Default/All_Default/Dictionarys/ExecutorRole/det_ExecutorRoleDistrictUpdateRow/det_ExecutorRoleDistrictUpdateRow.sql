update [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
	set
	--[building_id]=@building_id
      [district_id]=@district_id
      --,[city_id]=@city_id
      ,[executor_role_id]=@executor_role_id
      ,[executor_id]=@executor_id
	where id=@Id