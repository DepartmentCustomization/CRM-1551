-- DECLARE @building_id INT = 15828;

SELECT
    TOP 1 
	d.Id,
    d.[name],
    o.[short_name] AS execOrg
FROM dbo.[Objects] obj 
INNER JOIN dbo.[Districts] d ON d.Id = obj.district_id
LEFT JOIN dbo.ExecutorInRoleForObject exo ON exo.[object_id] = obj.Id
LEFT JOIN dbo.Organizations o ON o.Id = exo.executor_id
WHERE
   obj.builbing_id = @building_id
    AND o.organization_type_id IN (3, 6, 7, 11)
ORDER BY
    organization_type_id DESC ;
