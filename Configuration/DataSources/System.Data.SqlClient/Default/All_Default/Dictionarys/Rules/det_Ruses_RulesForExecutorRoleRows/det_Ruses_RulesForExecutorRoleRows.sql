
   select [RulesForExecutorRole].Id, [ExecutorRoleLevel].name ExecutorRoleLevel, [ExecutorRole].name ExecutorRole, 
[Rules].name Rules, [RulesForExecutorRole].priority, 
  case when [RulesForExecutorRole].main=1 then N'Так' else N'Ні' end [main], [ProcessingKind].name ProcessingKind
  /*,

  [RulesForExecutorRole].Id RulesForExecutorRole_Id, [Rules].Id Rules_Id, [ExecutorRoleLevel].Id ExecutorRoleLevel_Id, [ExecutorRole].Id ExecutorRole_Id
  , [RulesForExecutorRole].main RulesForExecutorRole_main_id, [ProcessingKind].Id ProcessingKind_Id
  */
  , [Rules].Id RulesId, [ExecutorRole].Id ExecutorRoleId
  from [CRM_1551_Analitics].[dbo].[RulesForExecutorRole]
  left join [CRM_1551_Analitics].[dbo].[ExecutorRoleLevel] on [RulesForExecutorRole].executor_role_level_id=[ExecutorRoleLevel].Id
  left join [CRM_1551_Analitics].[dbo].[ExecutorRole] on [RulesForExecutorRole].executor_role_id=[ExecutorRole].Id
  inner join [CRM_1551_Analitics].[dbo].[Rules] on [RulesForExecutorRole].rule_id=[Rules].Id
  left join [CRM_1551_Analitics].[dbo].[ProcessingKind] on [RulesForExecutorRole].priocessing_kind_id=[ProcessingKind].Id
  where [Rules].Id=@rules_id 
  and #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
