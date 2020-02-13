--det_ExecutorRoleBuildingSelectRows
--declare @executor_role_id int =1;

SELECT
  [ExecutorInRoleForObject].Id,
  [ExecutorInRoleForObject].executor_role_id,
  [ExecutorRole].name ExecutorRole,
  [Buildings].Id build_id,
  [StreetTypes].shortname + N' ' + [Streets].name + N', ' + [Buildings].name AS Building,
  [ExecutorInRoleForObject].executor_id,
  [Organizations].Id OrganizationsId,
  [Organizations].[short_name] OrganizationsName
FROM
  [dbo].[ExecutorInRoleForObject]
  LEFT JOIN [dbo].[ExecutorRole] ON [ExecutorInRoleForObject].executor_role_id = [ExecutorRole].Id
  LEFT JOIN [dbo].[Buildings] ON [ExecutorInRoleForObject].[object_id] = Buildings.id
  LEFT JOIN [dbo].[Streets] ON [Buildings].street_id = [Streets].id
  LEFT JOIN [dbo].[StreetTypes] ON [Streets].street_type_id = [StreetTypes].Id
  LEFT JOIN [dbo].[Organizations] ON [ExecutorInRoleForObject].executor_id = [Organizations].Id
WHERE
  [ExecutorInRoleForObject].executor_role_id = @executor_role_id
  AND [ExecutorInRoleForObject].[object_id] IS NOT NULL
  AND [Organizations].active = 1
  AND #filter_columns#
      #sort_columns#
  OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY