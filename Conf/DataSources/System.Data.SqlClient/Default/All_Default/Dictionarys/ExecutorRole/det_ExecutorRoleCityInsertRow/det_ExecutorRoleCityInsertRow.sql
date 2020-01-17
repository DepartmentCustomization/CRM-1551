 insert into [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
  (
  [city_id]
      ,[executor_role_id]
      ,[executor_id]
  )

  select 
      @city_id
      ,@executor_role_id
      ,@executor_id