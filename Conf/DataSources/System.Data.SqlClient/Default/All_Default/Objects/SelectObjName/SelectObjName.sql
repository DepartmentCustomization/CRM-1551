-- DECLARE @buildingId INT = 56036;

SELECT
TOP 1
     Id,
     [name] AS objName
FROM dbo.[Objects] 
WHERE builbing_id = @buildingId 
ORDER BY Id DESC;