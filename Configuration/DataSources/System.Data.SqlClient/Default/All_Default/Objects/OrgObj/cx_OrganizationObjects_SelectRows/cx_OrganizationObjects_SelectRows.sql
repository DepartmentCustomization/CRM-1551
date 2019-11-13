  select 
   [ExecutorInRoleForObject].Id
  ,[ExecutorRole].name conn_type_name
  ,[Organizations].short_name
  from [dbo].[ExecutorInRoleForObject]
  inner join [dbo].[Objects] on [ExecutorInRoleForObject].[object_id] =[Objects].[Id]
  left join [dbo].[ExecutorRole] on [ExecutorInRoleForObject].executor_role_id=[ExecutorRole].Id
  left join [dbo].[Organizations] on [ExecutorInRoleForObject].executor_id=[Organizations].Id

  where [Objects].Id=@Id
  and  #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only



--   select [ExecutorInRoleForObject].Id, [ExecutorRole].name conn_type_name
--  -- , [ExecutorRole].Id conn_type_id
--   , [Organizations].short_name
--  -- , [Organizations].Id as org_id
--  -- , [ExecutorInRoleForObject].building_id object_id
--   from [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
--   left join [CRM_1551_Analitics].[dbo].[ExecutorRole] on [ExecutorInRoleForObject].executor_role_id=[ExecutorRole].Id
--   left join [CRM_1551_Analitics].[dbo].[Organizations] on [ExecutorInRoleForObject].executor_id=[Organizations].Id
--   inner join [CRM_1551_Analitics].[dbo].[Objects] on [ExecutorInRoleForObject].[building_id]=[Objects].[builbing_id]

--   where [Objects].Id=@Id
--   and  #filter_columns#
--      #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only
