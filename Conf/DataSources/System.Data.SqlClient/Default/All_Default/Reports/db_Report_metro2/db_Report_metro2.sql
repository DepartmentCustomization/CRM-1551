--   DECLARE @dateFrom DATETIME = '2020-01-01 00:00:00';
--   DECLARE @dateTo DATETIME = getutcdate();

DECLARE @sources TABLE (Id INT, source NVARCHAR(200));
DECLARE @call_q INT;
DECLARE @site_q INT;
DECLARE @ugl_q INT;
DECLARE @result TABLE (source NVARCHAR(200), val INT);

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
                    cast(cast(dateadd(DAY, 0, @dateTo) AS DATE) AS DATETIME)
                )
            )
        )
    )
);

SELECT
    qt.Id AS Id,
    qt.[name] AS qType,
    COUNT(ass.Id) qty
FROM
    dbo.Questions q
	JOIN dbo.Appeals a ON a.Id = q.appeal_id
    JOIN dbo.QuestionTypes qt ON qt.Id = q.question_type_id
    JOIN dbo.Assignments ass ON ass.question_id = q.Id 
WHERE
    ass.executor_organization_id = 51
	AND a.receipt_source_id IN (1,2,3)
    AND q.registration_date BETWEEN @dateFrom
    AND @filterTo
    AND #filter_columns#
GROUP BY
    qt.[name],
    qt.Id
ORDER BY
    qty DESC ;