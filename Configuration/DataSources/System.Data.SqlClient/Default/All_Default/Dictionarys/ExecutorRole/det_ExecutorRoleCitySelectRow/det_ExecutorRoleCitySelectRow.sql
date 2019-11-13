 -- det_ExecutorRoleCitySelectRow

 select [ExecutorInRoleForObject].Id, [ExecutorInRoleForObject].executor_role_id, [ExecutorRole].name ExecutorRole, [City].Id [City_id], 
  [City].name City, [ExecutorInRoleForObject].executor_id,
  [Organizations].Id OrganizationsId, [Organizations].[short_name] OrganizationsName
  from [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
  left join [CRM_1551_Analitics].[dbo].[ExecutorRole] on [ExecutorInRoleForObject].executor_role_id=[ExecutorRole].Id
  left join [CRM_1551_Analitics].[dbo].[City] on [ExecutorInRoleForObject].city_id=City.id
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [ExecutorInRoleForObject].executor_id=[Organizations].Id
  where [ExecutorInRoleForObject].Id=@Id