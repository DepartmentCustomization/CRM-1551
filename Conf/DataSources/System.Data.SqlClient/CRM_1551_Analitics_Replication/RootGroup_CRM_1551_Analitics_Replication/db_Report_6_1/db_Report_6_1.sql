-- DECLARE @dateFrom DATETIME = '2020-01-01 00:00:00';
-- DECLARE @dateTo DATETIME = CURRENT_TIMESTAMP;4

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
                     d.name AS dName,
                     count(q.Id) AS gvpQty
              FROM
                     dbo.[Districts] d
                     LEFT JOIN dbo.Buildings b ON b.district_id = d.Id
                     LEFT JOIN dbo.[Objects] o ON o.builbing_id = b.Id
                     LEFT JOIN dbo.Questions q ON q.[object_id] = o.Id
                     LEFT JOIN dbo.QuestionTypes qt ON qt.Id = q.question_type_id
              WHERE
                     qt.Id IN (67)
                     AND d.name IS NOT NULL
                     AND q.registration_date BETWEEN @dateFrom
                     AND @filterTo
              GROUP BY
                     d.name
       ) gvp ON gvp.dName = d.[name]
       LEFT JOIN (
              SELECT
                     d.name AS dName,
                     count(q.Id) AS hvpQty
              FROM
                     dbo.[Districts] d
                     LEFT JOIN dbo.Buildings b ON b.district_id = d.Id
                     LEFT JOIN dbo.[Objects] o ON o.builbing_id = b.Id
                     LEFT JOIN dbo.Questions q ON q.[object_id] = o.Id
                     LEFT JOIN dbo.QuestionTypes qt ON qt.Id = q.question_type_id
              WHERE
                     qt.Id IN (75)
                     AND d.name IS NOT NULL
                     AND q.registration_date BETWEEN @dateFrom
                     AND @filterTo
              GROUP BY
                     d.name
       ) hvp ON hvp.dName = d.[name]
       LEFT JOIN (
              SELECT
                     d.name AS dName,
                     count(q.Id) AS heatingQty
              FROM
                     dbo.[Districts] d
                     LEFT JOIN dbo.Buildings b ON b.district_id = d.Id
                     LEFT JOIN dbo.[Objects] o ON o.builbing_id = b.Id
                     LEFT JOIN dbo.Questions q ON q.[object_id] = o.Id
                     LEFT JOIN dbo.QuestionTypes qt ON qt.Id = q.question_type_id
              WHERE
                     qt.Id IN (86)
                     AND d.name IS NOT NULL
                     AND q.registration_date BETWEEN @dateFrom
                     AND @filterTo
              GROUP BY
                     d.name
       ) heating ON heating.dName = d.[name]
       LEFT JOIN (
              SELECT
                     d.name AS dName,
                     count(q.Id) AS electricityQty
              FROM
                     dbo.[Districts] d
                     LEFT JOIN dbo.Buildings b ON b.district_id = d.Id
                     LEFT JOIN dbo.[Objects] o ON o.builbing_id = b.Id
                     LEFT JOIN dbo.Questions q ON q.[object_id] = o.Id
                     LEFT JOIN dbo.QuestionTypes qt ON qt.Id = q.question_type_id
              WHERE
                     qt.Id IN (97)
                     AND d.name IS NOT NULL
                     AND q.registration_date BETWEEN @dateFrom
                     AND @filterTo
              GROUP BY
                     d.name
       ) electricity ON electricity.dName = d.[name]
WHERE
       d.Id <> 11 ;