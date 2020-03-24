-- declare @user_id nvarchar(128) = 'eb6d56d2-e217-45e4-800b-c851666ce795';
DECLARE @user_org TABLE (Id INT);

DECLARE @kbu_orgs TABLE (Id INT);

DECLARE @is_root SMALLINT;

INSERT INTO
    @user_org
SELECT
    OrganisationStructureId
FROM
    [#system_database_name#].[dbo].[UserInOrganisation]
WHERE
    UserId = @user_id --- Получить организации дочерние от КБУ
;

WITH RecursiveOrg (Id, parentID, orgName) AS (
    SELECT
        o.Id,
        ParentId,
        Name
    FROM
        [#system_database_name#].[dbo].[OrganisationStructure] o
    WHERE
        o.Id = 4
    UNION
    ALL
    SELECT
        o.Id,
        o.ParentId,
        o.Name
    FROM
        [#system_database_name#].[dbo].[OrganisationStructure] o
        JOIN RecursiveOrg r ON o.ParentId = r.Id
)
INSERT INTO
    @kbu_orgs
SELECT
    DISTINCT Id
FROM
    RecursiveOrg r ;
SET
    @is_root = (
        SELECT
            count(x) xqty
        FROM
            (
                SELECT
                    CASE
                        WHEN Id IN (2)
                        OR Id IN (
                            SELECT
                                Id
                            FROM
                                @kbu_orgs
                        ) THEN 'One'
                        ELSE 'Zero'
                    END AS x
                FROM
                    @user_org
            ) x
        WHERE
            x.x = 'One'
    ) ;
    IF object_id('tempdb..#orgList') IS NOT NULL 
    BEGIN
    DROP TABLE #orgList ;
    END
    CREATE TABLE #orgList
    (
        Id int,
        parentID int,
        orgName nvarchar(255)
    );

--- Если юзер из структуры админов или КБУ - показывать все
IF(@is_root > 0) BEGIN;

WITH RecursiveOrg (Id, parentID, orgName) AS (
    SELECT
        o.Id,
        parent_organization_id,
        short_name
    FROM
        dbo.Organizations o 
    WHERE
        o.Id = 1
    UNION
    ALL
    SELECT
        o.Id,
        o.parent_organization_id,
        o.short_name
    FROM
        dbo.Organizations o
        JOIN RecursiveOrg r ON o.parent_organization_id = r.Id
)
INSERT INTO
    #orgList
SELECT
    DISTINCT Id,
    parentID,
    orgName
FROM
    RecursiveOrg r ;
END --- Иначе выборка по должности
ELSE IF (@is_root = 0)
BEGIN

WITH RecursiveOrg (Id, parentID, orgName) AS (
    SELECT
        o.Id,
        parent_organization_id,
        short_name
    FROM
        dbo.Organizations o
        JOIN dbo.Positions p ON p.organizations_id = o.Id
    WHERE
        p.programuser_id = @user_id
    UNION
    ALL
    SELECT
        o.Id,
        o.parent_organization_id,
        o.short_name
    FROM
        dbo.Organizations o
        JOIN RecursiveOrg r ON o.parent_organization_id = r.Id
)
INSERT INTO
    #orgList
SELECT
    DISTINCT Id,
    parentID,
    orgName
FROM
    RecursiveOrg r ;
END
SELECT
    Id,
    orgName
FROM
    #orgList
WHERE
    #filter_columns#
ORDER BY
    Id OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY ;