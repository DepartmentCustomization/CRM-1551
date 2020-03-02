-- DECLARE @org_id INT = NULL;
-- DECLARE @ass_Id INT = 2976314;


IF(@org_id IS NOT NULL)
BEGIN
SELECT
  p.Id,
  concat(p.[name], ' (' + p.[position] + ')') AS executor_person
FROM
  [dbo].[PersonExecutorChoose] AS pe
  JOIN Positions AS p ON p.Id = pe.position_id
WHERE
  p.organizations_id = @org_id
  AND p.active <> 0
  AND #filter_columns#
     #sort_columns# 
OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY;
END
ELSE 
BEGIN
DECLARE @ass_execOrg INT = (SELECT executor_organization_id FROM dbo.Assignments WHERE Id = @ass_Id);

 SELECT
  p.Id,
  concat(p.[name], ' (' + p.[position] + ')') AS executor_person
FROM
  [dbo].[PersonExecutorChoose] AS pe
  JOIN Positions AS p ON p.Id = pe.position_id
WHERE
  p.organizations_id = @ass_execOrg
  AND p.active <> 0
  AND #filter_columns#
      #sort_columns# 
OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY;
END