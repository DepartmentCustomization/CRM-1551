 --declare @organization_id int =2000;

  select [ExecutorInRoleForObject].Id, [ExecutorRole].name ConnectionType, [ObjectTypes].name ObjectType,
  [Objects].name ObjectName
  from [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
  left join [CRM_1551_Analitics].[dbo].[Buildings] on [ExecutorInRoleForObject].object_id=[Buildings].Id
  inner join [CRM_1551_Analitics].[dbo].[Objects] on [Buildings].Id=[Objects].builbing_id
  left join [CRM_1551_Analitics].[dbo].[ExecutorRole] on [ExecutorInRoleForObject].executor_role_id=[ExecutorRole].Id
  left join [CRM_1551_Analitics].[dbo].[ObjectTypes] on [Objects].object_type_id=[ObjectTypes].Id
  where  
  #filter_columns# and
  [Objects].object_type_id=1 and [ExecutorInRoleForObject].executor_id=@organization_id

  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
