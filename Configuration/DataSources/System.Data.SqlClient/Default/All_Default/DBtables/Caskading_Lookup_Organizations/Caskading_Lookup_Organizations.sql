--declare @organizationId int= 7683;

  select [Organizations].Id, [Organizations].[name]
  from [CRM_1551_Analitics].[dbo].[Organizations]
  where [parent_organization_id] = @organizationId and [programworker]=N'true'
  and  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only