select [ExecutorInRoleForObject].Id, [ExecutorInRoleForObject].executor_role_id, [ExecutorRole].name ExecutorRole, [Districts].Id DistrictId, 
  [Districts].name District, [ExecutorInRoleForObject].executor_id,
  [Organizations].Id OrganizationsId, [Organizations].[short_name] OrganizationsName
  from [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
  left join [CRM_1551_Analitics].[dbo].[ExecutorRole] on [ExecutorInRoleForObject].executor_role_id=[ExecutorRole].Id
  left join [CRM_1551_Analitics].[dbo].[Districts] on [ExecutorInRoleForObject].district_id=Districts.id
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [ExecutorInRoleForObject].executor_id=[Organizations].Id
  where [district_id] is not null and [ExecutorInRoleForObject].executor_role_id=@executor_role_id
   and #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only