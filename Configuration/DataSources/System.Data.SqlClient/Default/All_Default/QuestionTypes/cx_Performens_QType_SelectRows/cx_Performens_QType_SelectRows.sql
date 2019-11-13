--declare @rule_id int =22;
   select [ExecutorRole].Id, [ExecutorRole].name ExecutorRole, [Organizations].Id Organizations_Id, [Organizations].short_name,
   case when [RulesForExecutorRole].main=N'true' then N'Так'
   when [RulesForExecutorRole].main=N'false' then N'Ні' end main,
    [OrganizationTypes].name OrganizationType
   from [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
   left join [CRM_1551_Analitics].[dbo].[Organizations] on [ExecutorInRoleForObject].executor_id=[Organizations].Id
   left join [CRM_1551_Analitics].[dbo].[ExecutorRole] on [ExecutorInRoleForObject].executor_role_id=[ExecutorRole].Id
   left join [CRM_1551_Analitics].[dbo].[RulesForExecutorRole] on [RulesForExecutorRole].executor_role_id=[ExecutorRole].Id
   left join [CRM_1551_Analitics].[dbo].[OrganizationTypes] on [Organizations].organization_type_id=[OrganizationTypes].Id
   where [RulesForExecutorRole].rule_id=@rule_id
  and #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
  
  
-- SELECT [Organizations].[Id]
--       ,[Organizations].[short_name] as name_org
-- 	  ,N'Так / Ні' as sing
-- 	  ,org.short_name as name_parent
--   FROM [dbo].[Organizations]
-- 	left join [Organizations] org on org.Id = [Organizations].[parent_organization_id]
-- 	left join ExecutorInRoleForObject as er on er.executor_id =  Organizations.Id
-- 	where er.executor_role_id = @rule
-- 	and
-- 	 #filter_columns#
--      #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only