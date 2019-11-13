update [CRM_1551_Analitics].[dbo].[RulesForExecutorRole]
  set
  executor_role_level_id=@ExecutorRoleLevel_Id--executor_role_level_id
      ,executor_role_id=@ExecutorRole_Id--executor_role_id
      ,rule_id=@Rules_Id--@rule_id
      ,priority=@priority
      ,main=@main
      ,priocessing_kind_id=@ProcessingKind_Id--priocessing_kind_id

  where [Id]=@Id