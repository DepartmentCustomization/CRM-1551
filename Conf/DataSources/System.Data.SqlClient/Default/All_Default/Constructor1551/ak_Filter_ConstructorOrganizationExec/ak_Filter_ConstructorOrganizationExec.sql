-- DECLARE @UserId NVARCHAR(128) = '049a185d-5a14-4728-8571-fbfd8ef4c844';
DECLARE @userPos INT = (SELECT TOP 1 Id FROM Positions WHERE programuser_id = @UserId);
DECLARE @userOrg INT = (SELECT TOP 1 organizations_id FROM Positions WHERE Id = @userPos);

; 
WITH 
Orgs (Id, parent_id, short_name) 
AS (
  SELECT
    Id,
    parent_organization_id AS parent_id,
    short_name  
  FROM
    [dbo].[Organizations]
  WHERE
    Id = @userOrg
  UNION
  ALL
  SELECT
	o.Id,
    o.parent_organization_id AS parent_id,
    o.short_name 
  FROM
    [dbo].[Organizations] o
    INNER JOIN Orgs h ON o.parent_organization_id = h.Id
)

SELECT 
	Id,
	short_name AS [Name] 
FROM Orgs
WHERE
 #filter_columns#
 #sort_columns#
OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY;