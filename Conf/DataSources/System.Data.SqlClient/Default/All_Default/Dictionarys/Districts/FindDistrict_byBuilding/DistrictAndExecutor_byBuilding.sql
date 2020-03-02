-- DECLARE @building_id INT = 48104;

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

DECLARE @execOrg TABLE(objectId INT, typeId INT, [Name] NVARCHAR(300));
INSERT INTO @execOrg (objectId, typeId, [Name]) 
SELECT 
	obj.Id,
	ot.Id,
	o.short_name 
FROM dbo.[Objects] obj
INNER JOIN dbo.ExecutorInRoleForObject exo ON exo.[object_id] = obj.Id
INNER JOIN dbo.Organizations o ON o.Id = exo.executor_id
INNER JOIN dbo.OrganizationTypes ot ON ot.Id = o.organization_type_id
WHERE
   obj.builbing_id = @building_id
    AND o.organization_type_id IN (3, 6, 7, 10, 11);

SELECT
TOP 1 
	d.Id,
	d.[name],
	o.[Name] AS execOrg 
FROM @Disctict d
LEFT JOIN @execOrg o ON o.objectId = d.objectId
ORDER BY o.typeId DESC ;