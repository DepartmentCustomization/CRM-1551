declare @builbing_id int=
  (select [builbing_id]
  from [Objects]
  where [Id]=@object_id)

insert into [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
  (
  [object_id]
      --,[district_id]
      --,[city_id]
      ,[executor_role_id]
      ,[executor_id]
      ,[object_id]
  )

  select @builbing_id, @conn_type_id, @org_id, @object_id

