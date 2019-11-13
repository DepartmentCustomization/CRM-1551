insert into [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
  (
  [object_id]
      --,[district_id]
      --,[city_id]
      ,[executor_role_id]
      ,[executor_id]
  )
  select
  @building_id
      --,@district_id
      --,@city_id
      ,@executor_role_id
      ,@organization_id