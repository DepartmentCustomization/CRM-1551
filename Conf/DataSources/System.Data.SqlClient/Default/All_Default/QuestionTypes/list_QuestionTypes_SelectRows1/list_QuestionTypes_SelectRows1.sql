select Id, ltrim(Id)+N'-'+name0 name0, name
from
(
select distinct a.name name0, a.Id, 
  stuff(
  (select N', '+
  ISNULL(N'Пріоритет '+LTRIM([RulesForExecutorRole].priority)+N': ', N'')+
  ISNULL(N'Роль- '+[ExecutorRole].name, N'')+ 
  ISNULL(N', рівень- '+[ExecutorRoleLevel].name, N'')+
  ISNULL(N', тип доручення- ', N'')+[ProcessingKind].name+
  ISNULL(case when [RulesForExecutorRole].main=N'true' then N', головний'
  when [RulesForExecutorRole].main=N'false' then N', не головний' else N'' end, N'') 
  from [CRM_1551_Analitics].[dbo].[RulesForExecutorRole]
  left join [CRM_1551_Analitics].[dbo].[Rules] on [RulesForExecutorRole].rule_id=[Rules].Id
  left join [CRM_1551_Analitics].[dbo].[ExecutorRoleLevel] on [RulesForExecutorRole].[executor_role_level_id]=[ExecutorRoleLevel].id
  left join [CRM_1551_Analitics].[dbo].[ExecutorRole] on [RulesForExecutorRole].executor_role_id=[ExecutorRole].Id
  left join [CRM_1551_Analitics].[dbo].[ProcessingKind] on [RulesForExecutorRole].priocessing_kind_id=[ProcessingKind].Id
  where [Rules].Id=a.Id
  for xml path('')
  ),1,1,'') name
  

  from [CRM_1551_Analitics].[dbo].[Rules] a
) b
 where #filter_columns#
 order by Id
  --#sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only