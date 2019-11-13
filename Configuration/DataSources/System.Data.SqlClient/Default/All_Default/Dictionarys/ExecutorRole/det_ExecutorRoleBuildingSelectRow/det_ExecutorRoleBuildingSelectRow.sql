 -- det_ExecutorRoleBuildingSelectRow
 -- declare @Id int =1;

 select [ExecutorInRoleForObject].Id, [ExecutorInRoleForObject].executor_role_id, [ExecutorRole].name ExecutorRole, [Buildings].Id [build_id], 
  [StreetTypes].shortname+N' '+[Streets].name+N', '+[Buildings].name Building, 
  
  [ExecutorInRoleForObject].executor_id,
  [Organizations].Id OrganizationsId, [Organizations].[short_name] OrganizationsName
  from [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
  left join [CRM_1551_Analitics].[dbo].[ExecutorRole] on [ExecutorInRoleForObject].executor_role_id=[ExecutorRole].Id
  left join [CRM_1551_Analitics].[dbo].[Buildings] on [ExecutorInRoleForObject].object_id=Buildings.id
  left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=[Streets].id
  left join [CRM_1551_Analitics].[dbo].[StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [ExecutorInRoleForObject].executor_id=[Organizations].Id
  where [ExecutorInRoleForObject].Id=@Id