  -- det_ExecutorRoleBuildingSelectRows
  --declare @executor_role_id int =1;
  
  
   select [ExecutorInRoleForObject].Id, 
	 [ExecutorInRoleForObject].executor_role_id, 
	 [ExecutorRole].name ExecutorRole, 
	 [Buildings].Id build_id, 
	 [StreetTypes].shortname+N' '+[Streets].name+N', '+[Buildings].name as Building,
	 [ExecutorInRoleForObject].executor_id,
	 [Organizations].Id OrganizationsId, 
	 [Organizations].[short_name] OrganizationsName
  from [dbo].[ExecutorInRoleForObject]
  left join [dbo].[ExecutorRole] on [ExecutorInRoleForObject].executor_role_id=[ExecutorRole].Id
  left join [dbo].[Buildings] on [ExecutorInRoleForObject].[object_id] = Buildings.id
  left join [dbo].[Streets] on [Buildings].street_id=[Streets].id
  left join [dbo].[StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
  left join [dbo].[Organizations] on [ExecutorInRoleForObject].executor_id=[Organizations].Id
  where [ExecutorInRoleForObject].executor_role_id = @executor_role_id
    and  [ExecutorInRoleForObject].[object_id] is not null
    and #filter_columns#
    #sort_columns#
    offset @pageOffsetRows rows fetch next @pageLimitRows rows only
  
  
  
  
  /*
  select [ExecutorInRoleForObject].Id, [ExecutorInRoleForObject].executor_role_id, [ExecutorRole].name ExecutorRole, [Buildings].Id build_id,
   
  [StreetTypes].shortname+N' '+[Streets].name+N', '+[Buildings].name Building, 
  
  [ExecutorInRoleForObject].executor_id,
  [Organizations].Id OrganizationsId, [Organizations].[short_name] OrganizationsName
  from [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
  left join [CRM_1551_Analitics].[dbo].[ExecutorRole] on [ExecutorInRoleForObject].executor_role_id=[ExecutorRole].Id
  left join [CRM_1551_Analitics].[dbo].[Buildings] on [ExecutorInRoleForObject].building_id=Buildings.id
  left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=[Streets].id
  left join [CRM_1551_Analitics].[dbo].[StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [ExecutorInRoleForObject].executor_id=[Organizations].Id
  where [building_id] is not null and [ExecutorInRoleForObject].executor_role_id=  @executor_role_id
  and #filter_columns#
  #sort_columns#
  offset @pageOffsetRows rows fetch next @pageLimitRows rows only
  */