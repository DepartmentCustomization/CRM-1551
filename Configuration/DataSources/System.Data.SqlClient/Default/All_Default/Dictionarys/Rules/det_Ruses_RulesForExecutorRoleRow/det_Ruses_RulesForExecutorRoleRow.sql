
--declare @Id int =33;



 select [RulesForExecutorRole].Id, ltrim([RulesForExecutorRole].Id)+N'. '+isnull([Rules].name,N'') name, 
 [ExecutorRoleLevel].Id ExecutorRoleLevel_Id, ltrim([ExecutorRoleLevel].Id)+N'-'+[ExecutorRoleLevel].name ExecutorRoleLevel, 
 [ExecutorRole].Id [ExecutorRole_Id], ltrim([ExecutorRole].Id)+N'-'+[ExecutorRole].name ExecutorRole, 
 [Rules].Id [Rules_Id], ltrim([Rules].Id)+N'-'+[Rules].name Rules, 
 [RulesForExecutorRole].priority,  [RulesForExecutorRole].main,
 [ProcessingKind].Id [ProcessingKind_Id], ltrim([ProcessingKind].Id)+N'-'+[ProcessingKind].name ProcessingKind
   from [CRM_1551_Analitics].[dbo].[RulesForExecutorRole]
   left join [CRM_1551_Analitics].[dbo].[ExecutorRoleLevel] on [RulesForExecutorRole].executor_role_level_id=[ExecutorRoleLevel].Id
   left join [CRM_1551_Analitics].[dbo].[ExecutorRole] on [RulesForExecutorRole].executor_role_id=[ExecutorRole].Id
   inner join [CRM_1551_Analitics].[dbo].[Rules] on [RulesForExecutorRole].rule_id=[Rules].Id
   left join [CRM_1551_Analitics].[dbo].[ProcessingKind] on [RulesForExecutorRole].priocessing_kind_id=[ProcessingKind].Id
   where [RulesForExecutorRole].Id=@Id


