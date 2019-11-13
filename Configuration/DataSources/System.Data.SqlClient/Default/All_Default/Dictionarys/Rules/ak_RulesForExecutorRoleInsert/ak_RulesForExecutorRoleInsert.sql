insert into [CRM_1551_Analitics].[dbo].[RulesForExecutorRole]
  (
  [executor_role_level_id]
      ,[executor_role_id]
      ,[rule_id]
      ,[priority]
      ,[main]
      ,[priocessing_kind_id]
  )

  select
  @ExecutorRoleLevel_Id
      ,@ExecutorRole_Id
      ,@Rules_Id
      ,@priority
      ,@main
      ,@ProcessingKind_Id