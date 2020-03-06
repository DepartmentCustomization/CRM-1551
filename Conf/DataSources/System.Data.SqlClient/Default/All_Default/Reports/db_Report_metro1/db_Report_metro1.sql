-- DECLARE @dateFrom DATETIME = '2020-01-01 00:00:00';
-- DECLARE @dateTo DATETIME = getutcdate();

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

INSERT INTO
    @sources (Id, source)
SELECT
    Id,
    [name]
FROM
    dbo.ReceiptSources
WHERE
    Id IN (1, 2, 3) ;
    
SET
    @call_q = (
        SELECT
            isnull(COUNT(ass.Id), 0)
        FROM
            @sources s
            JOIN dbo.ReceiptSources rs ON s.Id = rs.Id
            JOIN dbo.Appeals a ON a.receipt_source_id = rs.Id
            JOIN dbo.Questions q ON q.appeal_id = a.Id
            JOIN dbo.Assignments ass ON ass.question_id = q.Id
        WHERE
            rs.Id = 1
            AND ass.executor_organization_id = 51
            AND q.registration_date BETWEEN @dateFrom
            AND @filterTo
        GROUP BY
            s.Id
    ) ;

SET
    @site_q = (
        SELECT
            isnull(COUNT(ass.Id), 0)
        FROM
            @sources s
            JOIN dbo.ReceiptSources rs ON s.Id = rs.Id
            JOIN dbo.Appeals a ON a.receipt_source_id = rs.Id
            JOIN dbo.Questions q ON q.appeal_id = a.Id
            JOIN dbo.Assignments ass ON ass.question_id = q.Id
        WHERE
            rs.Id = 2
            AND ass.executor_organization_id = 51
            AND q.registration_date BETWEEN @dateFrom
            AND @filterTo
        GROUP BY
            s.Id
    ) ;

SET
    @ugl_q = (
        SELECT
            isnull(COUNT(ass.Id), 0)
        FROM
            @sources s
            JOIN dbo.ReceiptSources rs ON s.Id = rs.Id
            JOIN dbo.Appeals a ON a.receipt_source_id = rs.Id
            JOIN dbo.Questions q ON q.appeal_id = a.Id
            JOIN dbo.Assignments ass ON ass.question_id = q.Id
        WHERE
            rs.Id = 3
            AND ass.executor_organization_id = 51
            AND q.registration_date BETWEEN @dateFrom
            AND @filterTo
        GROUP BY
            s.Id
    ) ;

INSERT INTO
    @result (source, val)
SELECT
    source,
    isnull(@call_q, 0) call_q
FROM
    @sources
WHERE
    Id = 1;

INSERT INTO
    @result (source, val)
SELECT
    source,
    isnull(@site_q, 0) site_q
FROM
    @sources
WHERE
    Id = 2;

INSERT INTO
    @result (source, val)
SELECT
    source,
    isnull(@ugl_q, 0) ugl_q
FROM
    @sources
WHERE
    Id = 3;


SELECT
    ROW_NUMBER() OVER(
        ORDER BY
            Zidan.val ASC
    ) AS Id,
    *
FROM
    (
        SELECT
            N'Отримано дзвінків на лінію з питань метрополітену' [source],
            '         ' val
        UNION
        ALL
        SELECT
            N'Надано усних консультацій' [source],
            '         ' val
        UNION
        ALL
        SELECT
            CASE
                WHEN [source] = N'Сайт/моб. додаток' THEN N'Зареєстровано звернень через сайт/мобільний додаток'
                WHEN [source] = N'УГЛ' THEN N'Зареєстровано звернень через УГЛ'
                WHEN [source] = N'Дзвінок в 1551' THEN N'Зареєстровано звернень через дзвінок 1551'
            END,
            val
        FROM
            @result
    ) Zidan ;