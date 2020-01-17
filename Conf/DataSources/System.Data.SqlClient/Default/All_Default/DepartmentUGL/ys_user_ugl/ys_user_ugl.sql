SELECT
    [UserInOrganisation].[UserId] AS Id,
    CONCAT([LastName], ' ', [FirstName], ' ', [Patronymic]) AS name
FROM [#system_database_name#].[dbo].[UserInOrganisation]
LEFT JOIN [#system_database_name#].[dbo].[User] ON [UserInOrganisation].UserId = [User].UserId
WHERE
    [UserInOrganisation].OrganisationStructureId = 29
    AND #filter_columns#
        #sort_columns#
    OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY