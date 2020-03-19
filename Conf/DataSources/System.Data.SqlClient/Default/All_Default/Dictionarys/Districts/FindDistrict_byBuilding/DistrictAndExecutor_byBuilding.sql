-- DECLARE @building_id INT = 18018;

DECLARE @Disctict TABLE (objectId INT, Id INT, [name] NVARCHAR(30));
INSERT INTO @Disctict
SELECT
	obj.Id,
	d.Id,
    d.[name]
FROM dbo.[Objects] obj 
INNER JOIN dbo.[Districts] d ON d.Id = obj.district_id
WHERE
   obj.builbing_id = @building_id ;

DECLARE @execOrg NVARCHAR(300);
SET @execOrg = ( 
SELECT 
TOP 1 o.short_name
FROM dbo.ExecutorInRoleForObject AS eo
LEFT JOIN dbo.Organizations AS o ON o.Id = eo.executor_id
WHERE [executor_role_id] = 1
AND eo.[object_id] = @building_id 
);

SELECT
TOP 1 
	d.[name] AS district,
	@execOrg AS execOrg 
FROM @Disctict d
;