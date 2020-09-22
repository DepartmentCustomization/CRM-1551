-- DECLARE @user_id NVARCHAR(128) = 'deae23d5-b957-48de-b2c6-63960db3622c';
DECLARE @user_org TABLE (Id INT);

---> Получить организации юзера
INSERT INTO
    @user_org
SELECT
    OrganisationStructureId
FROM
    [#system_database_name#].[dbo].[UserInOrganisation] 
WHERE
    UserId = @user_id --- Получить организации дочерние от КБУ
;

---> Выбрать организации администратора и КБУ с их дочерними
DECLARE @root_orgs TABLE (Id INT);
INSERT INTO @root_orgs
SELECT 2
UNION 
SELECT 4
UNION 
SELECT 
	Id 
FROM 
    [#system_database_name#].[dbo].[OrganisationStructure]
WHERE ParentId IN (2, 4);

DECLARE @isRoot BIT = IIF(
						(SELECT 
							COUNT(Id) 
					   FROM @user_org 
					   WHERE Id IN 
								(SELECT Id FROM @root_orgs)) > 0,
								1,
								0);

IF OBJECT_ID('tempdb..#orgList') IS NOT NULL
BEGIN
	DROP TABLE #orgList;
END

CREATE TABLE #orgList (Id INT, 
					   parentID INT, 
					   orgName NVARCHAR(300) 
					   ) WITH (DATA_COMPRESSION = PAGE);

--- Если юзер из структуры админов или КБУ - показывать все
IF(@isRoot = 1) 
BEGIN;

INSERT INTO #orgList (Id, parentID, orgName)
SELECT
	Id,
	parent_organization_id,
	short_name 
FROM
    dbo.[Organizations];
END 
--- Иначе выборка по должности
ELSE IF (@isRoot = 0)
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

INSERT INTO #orgList (Id, parentID, orgName)
SELECT
DISTINCT 
	Id,
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
ORDER BY Id 
OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY ;