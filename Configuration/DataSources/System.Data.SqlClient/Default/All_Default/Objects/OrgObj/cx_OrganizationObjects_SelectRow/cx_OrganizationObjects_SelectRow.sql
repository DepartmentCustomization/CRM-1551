  select [ExecutorInRoleForObject].Id, [ExecutorRole].name conn_type_name
  , [ExecutorRole].Id conn_type_id
  , [Organizations].short_name
  , [Organizations].Id as org_id
  , [Objects].Id object_id
  from [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
  left join [CRM_1551_Analitics].[dbo].[ExecutorRole] on [ExecutorInRoleForObject].executor_role_id=[ExecutorRole].Id
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [ExecutorInRoleForObject].executor_id=[Organizations].Id
  inner join [CRM_1551_Analitics].[dbo].[Objects] on [ExecutorInRoleForObject].[object_id]=[Objects].[Id]

  where [ExecutorInRoleForObject].Id=@Id
