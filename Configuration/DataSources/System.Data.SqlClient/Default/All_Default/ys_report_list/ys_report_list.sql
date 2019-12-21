SELECT
    [Id],
    [Code],
    [Name]
FROM
    [#system_database_name#].[dbo].[DashboardPage]
WHERE
    [DashboardGroupId] = 1004