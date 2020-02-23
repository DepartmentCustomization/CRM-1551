SELECT
    *
FROM
    (
        SELECT
            0 AS [Id],
            N'Усі РДА' AS [Name]
        UNION
        ALL
        SELECT
            [Id],
            [short_name] AS [Name]
        FROM
            [CRM_1551_Analitics].[dbo].[Organizations]
        WHERE
            Id = 2000
        UNION
        ALL
        SELECT
            [Id],
            [short_name] AS [Name]
        FROM
            [CRM_1551_Analitics].[dbo].[Organizations]
        WHERE
            Id = 2001
        UNION
        ALL
        SELECT
            [Id],
            [short_name] AS [Name]
        FROM
            [CRM_1551_Analitics].[dbo].[Organizations]
        WHERE
            Id = 2002
        UNION
        ALL
        SELECT
            [Id],
            [short_name] AS [Name]
        FROM
            [CRM_1551_Analitics].[dbo].[Organizations]
        WHERE
            Id = 2003
        UNION
        ALL
        SELECT
            [Id],
            [short_name] AS [Name]
        FROM
            [CRM_1551_Analitics].[dbo].[Organizations]
        WHERE
            Id = 2004
        UNION
        ALL
        SELECT
            [Id],
            [short_name] AS [Name]
        FROM
            [CRM_1551_Analitics].[dbo].[Organizations]
        WHERE
            Id = 2005
        UNION
        ALL
        SELECT
            [Id],
            [short_name] AS [Name]
        FROM
            [CRM_1551_Analitics].[dbo].[Organizations]
        WHERE
            Id = 2006
        UNION
        ALL
        SELECT
            [Id],
            [short_name] AS [Name]
        FROM
            [CRM_1551_Analitics].[dbo].[Organizations]
        WHERE
            Id = 2007
        UNION
        ALL
        SELECT
            [Id],
            [short_name] AS [Name]
        FROM
            [CRM_1551_Analitics].[dbo].[Organizations]
        WHERE
            Id = 2008
        UNION
        ALL
        SELECT
            [Id],
            [short_name] AS [Name]
        FROM
            [CRM_1551_Analitics].[dbo].[Organizations]
        WHERE
            Id = 2009
    ) AS t
-- WHERE
--     #filter_columns#
--     #sort_columns#
-- OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY 
;