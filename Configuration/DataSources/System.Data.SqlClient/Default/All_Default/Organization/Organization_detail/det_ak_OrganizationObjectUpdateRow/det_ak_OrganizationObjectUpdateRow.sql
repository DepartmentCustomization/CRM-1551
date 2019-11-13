update [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
  set 
  [object_id]= @building_id
      --,[district_id]
      --,[city_id]
      ,[executor_role_id]= @executor_role_id
      ,[executor_id] =@organization_id
  where id=@Id