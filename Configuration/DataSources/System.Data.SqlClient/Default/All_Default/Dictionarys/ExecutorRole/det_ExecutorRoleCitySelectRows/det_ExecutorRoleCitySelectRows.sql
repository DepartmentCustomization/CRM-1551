--DECLARE @executor_role_id int = 1;
SELECT
    [ExecutorInRoleForObject].Id,
    [ExecutorInRoleForObject].executor_role_id,
    [ExecutorRole].name ExecutorRole,
    [City].Id CityId,
    [City].name City,
    [ExecutorInRoleForObject].executor_id,
    [Organizations].Id OrganizationsId,
    [Organizations].[short_name] OrganizationsName
FROM
    [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
    LEFT JOIN [CRM_1551_Analitics].[dbo].[ExecutorRole] ON [ExecutorInRoleForObject].executor_role_id = [ExecutorRole].Id
    LEFT JOIN [CRM_1551_Analitics].[dbo].[City] ON [ExecutorInRoleForObject].city_id = City.id
    LEFT JOIN [CRM_1551_Analitics].[dbo].[Organizations] ON [ExecutorInRoleForObject].executor_id = [Organizations].Id
WHERE
    [city_id] IS NOT NULL
    AND [ExecutorInRoleForObject].executor_role_id = @executor_role_id
    AND [Organizations].active = 1
    AND #filter_columns#
        #sort_columns#
    OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY