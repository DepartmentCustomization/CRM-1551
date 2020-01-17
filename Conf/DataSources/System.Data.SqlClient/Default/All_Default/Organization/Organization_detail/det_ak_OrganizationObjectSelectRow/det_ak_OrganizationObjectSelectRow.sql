 --declare @Id int = 56408;

  select [ExecutorInRoleForObject].Id, [ExecutorInRoleForObject].[executor_role_id], 
  [ExecutorRole].name ExecutorRole, 
  [ExecutorInRoleForObject].object_id as building_id,
  [Buildings].name Building,
  [ObjectTypes].name ObjectType,
  [ExecutorInRoleForObject].executor_id [organization_id],
  [Objects].name ObjectName,
  [Organizations].short_name
  from [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
  inner join [CRM_1551_Analitics].[dbo].[Buildings] on [ExecutorInRoleForObject].object_id=[Buildings].Id
  inner join [CRM_1551_Analitics].[dbo].[Objects] on [Buildings].Id=[Objects].builbing_id
  left join [CRM_1551_Analitics].[dbo].[ExecutorRole] on [ExecutorInRoleForObject].executor_role_id=[ExecutorRole].Id
  left join [CRM_1551_Analitics].[dbo].[ObjectTypes] on [Objects].object_type_id=[ObjectTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [ExecutorInRoleForObject].executor_id=[Organizations].Id
  where [Objects].object_type_id=1 and [ExecutorInRoleForObject].Id=@Id