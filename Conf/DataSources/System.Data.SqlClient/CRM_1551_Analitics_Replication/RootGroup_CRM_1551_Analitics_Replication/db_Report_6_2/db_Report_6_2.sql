-- DECLARE @dateFrom DATETIME = '2020-01-01 00:00:00';
-- DECLARE @dateTo DATETIME = CURRENT_TIMESTAMP;

DECLARE @filterTo DATETIME = dateadd(
       SECOND,
       59,
(
              dateadd(
                     MINUTE,
                     59,
(
                            dateadd(
                                   HOUR,
                                   23,
                                   CAST(CAST(dateadd(DAY, 0, @dateTo) AS DATE) AS DATETIME)
                            )
                     )
              )
       )
);

SELECT
       ROW_NUMBER() OVER(
              ORDER BY
                     d.name
       ) AS Id,
       d.[name] AS district,
       isnull(gvp.gvpQty, 0) AS gvpQty,
       isnull(hvp.hvpQty, 0) AS hvpQty,
       isnull(heating.heatingQty, 0) AS heatingQty,
       isnull(electricity.electricityQty, 0) AS electricityQty
FROM
       dbo.[Districts] d 
LEFT JOIN (
SELECT 
	dName,
	COUNT(objName) AS gvpQty
FROM (
        SELECT 
        DISTINCT 
        	d.[name] AS dName,
        	o.[name] AS objName
        FROM dbo.Questions q 
        INNER JOIN dbo.[Objects] o ON o.Id = q.[object_id]
        INNER JOIN dbo.Districts d ON d.Id = o.district_id
        INNER JOIN dbo.QuestionTypes qt ON qt.Id = q.question_type_id
        WHERE qt.Id = 67
        AND q.registration_date 
        BETWEEN @dateFrom AND @dateTo
) sub1
GROUP BY dName
       ) gvp ON gvp.dName = d.[name]
LEFT JOIN (
SELECT 
	dName,
	COUNT(objName) AS hvpQty
FROM (
        SELECT 
        DISTINCT 
        	d.[name] AS dName,
        	o.[name] AS objName
        FROM dbo.Questions q 
        INNER JOIN dbo.[Objects] o ON o.Id = q.[object_id]
        INNER JOIN dbo.Districts d ON d.Id = o.district_id
        INNER JOIN dbo.QuestionTypes qt ON qt.Id = q.question_type_id
        WHERE qt.Id = 75
        AND q.registration_date 
        BETWEEN @dateFrom AND @dateTo
) sub2
GROUP BY dName
       ) hvp ON hvp.dName = d.[name]
LEFT JOIN (
SELECT 
	dName,
	COUNT(objName) AS heatingQty
FROM (
        SELECT 
        DISTINCT 
        	d.[name] AS dName,
        	o.[name] AS objName
        FROM dbo.Questions q 
        INNER JOIN dbo.[Objects] o ON o.Id = q.[object_id]
        INNER JOIN dbo.Districts d ON d.Id = o.district_id
        INNER JOIN dbo.QuestionTypes qt ON qt.Id = q.question_type_id
        WHERE qt.Id = 86
        AND q.registration_date 
        BETWEEN @dateFrom AND @dateTo
) sub3
GROUP BY dName
       ) heating ON heating.dName = d.[name]
LEFT JOIN (
SELECT 
	dName,
	COUNT(objName) AS electricityQty
FROM (
        SELECT 
        DISTINCT 
        	d.[name] AS dName,
        	o.[name] AS objName
        FROM dbo.Questions q 
        INNER JOIN dbo.[Objects] o ON o.Id = q.[object_id]
        INNER JOIN dbo.Districts d ON d.Id = o.district_id
        INNER JOIN dbo.QuestionTypes qt ON qt.Id = q.question_type_id
        WHERE qt.Id = 97
        AND q.registration_date 
        BETWEEN @dateFrom AND @dateTo
) sub3
GROUP BY dName
       ) electricity ON electricity.dName = d.[name]
WHERE
       d.Id <> 11 ;