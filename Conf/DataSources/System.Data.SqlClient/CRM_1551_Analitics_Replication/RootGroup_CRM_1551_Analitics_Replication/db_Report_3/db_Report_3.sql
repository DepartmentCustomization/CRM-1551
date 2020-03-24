-- DECLARE @questionType INT = 2;
-- DECLARE @questionGroup INT = 11;
-- DECLARE @organization INT = 3;
-- DECLARE @organizationGroup INT = 0;
-- DECLARE @dateFrom DATE = '2019-12-01';
-- DECLARE @dateTo DATE = cast(CURRENT_TIMESTAMP AS DATE); 

DECLARE @question_t TABLE (typeQ INT);
DECLARE @question_g TABLE (typeG INT);
DECLARE @organization_t TABLE (questionOrg INT);

SET @organization = IIF(@organization = 0, 1, @organization);
SET @organizationGroup = IIF(@organizationGroup = 0, NULL, @organization);

BEGIN
WITH RecursiveOrg (Id, parentID) AS (
    SELECT
        o.Id,
        parent_organization_id
    FROM
       [dbo].[Organizations] o
    WHERE
        o.Id = @organization
    UNION
    ALL
    SELECT
        o.Id,
        o.parent_organization_id
    FROM
        [dbo].[Organizations] o
        JOIN RecursiveOrg r ON o.parent_organization_id = r.Id
)
INSERT INTO
    @organization_t
SELECT
     Id
FROM
    RecursiveOrg r ;
END

IF(@organizationGroup IS NOT NULL)
BEGIN
INSERT INTO @organization_t(questionOrg)
SELECT 
	organization_id
FROM dbo.OGroupIncludeOrganizations 
WHERE organization_group_id = @organizationGroup ;
END

DECLARE @filterFrom DATETIME = cast(DATEADD(DAY, 1, @datefrom) AS DATE);

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
					cast(cast(DATEADD(DAY, 1, @dateTo) AS DATE) AS DATETIME)
				)
			)
		)
	)
);

IF @questionType = 0 
BEGIN
INSERT INTO
	@question_t (typeQ)
SELECT
	[Id]
FROM
	dbo.QuestionTypes ;
END
ELSE 
BEGIN
INSERT INTO
	@question_t(typeQ)
SELECT
	Id
FROM
	[CRM_1551_Analitics].[dbo].[QuestionTypes]
WHERE
	(
		Id = @questionType
		OR [question_type_id] = @questionType
	)
	AND Id NOT IN (
		SELECT
			typeQ
		FROM
			@question_t
	);

	WHILE (
		SELECT
			count(id)
		FROM
			(
				SELECT
					Id
				FROM
					[CRM_1551_Analitics].[dbo].[QuestionTypes]
				WHERE
					[question_type_id] IN (
						SELECT
							typeQ
						FROM
							@question_t
					)
					AND Id NOT IN (
						SELECT
							typeQ
						FROM
							@question_t
					)
			) q
	) != 0 
BEGIN
INSERT INTO
	@question_t
SELECT
	Id
FROM
	[CRM_1551_Analitics].[dbo].[QuestionTypes]
WHERE
	[question_type_id] IN (
		SELECT
			typeQ
		FROM
			@question_t
	)
	AND Id NOT IN (
		SELECT
			typeQ
		FROM
			@question_t
	) ;
END
END 
IF @questionGroup = 0 BEGIN
INSERT INTO
	@question_g (typeG)
SELECT
	[Id]
FROM
	dbo.QuestionTypes ;
END
ELSE BEGIN -- НАХОДИМ ИД QuestionTypes которые входят в выбранную QuestionGroups
INSERT INTO
	@question_g(typeG)
SELECT
	qt.Id
FROM
	dbo.QuestionTypes qt 
	JOIN dbo.QGroupIncludeQTypes qgiqt ON qgiqt.type_question_id = qt.Id
	JOIN dbo.QuestionGroups qg ON qg.Id = qgiqt.group_question_id 
WHERE
	qg.report_code = 'Analitica_spheres'
	AND qg.Id = @questionGroup ;
END
SELECT
	TOP 10 ROW_NUMBER() OVER(
		ORDER BY
			x.questionType DESC
	) AS Id,
	*,
	sum(
		x.Golosiivsky + x.Darnitsky + x.Desnyansky + x.Dnirovsky + x.Obolonsky + x.Pechersky + x.Podilsky + x.Svyatoshinsky + x.Solomiansky + x.Shevchenkovsky
	) AS allQuestionsQty
FROM
	(
		SELECT
			PivotTable.questionType AS questionType,
			isnull(PivotTable.[Голосіївський], 0) AS Golosiivsky,
			isnull(PivotTable.[Дарницький], 0) AS Darnitsky,
			isnull(PivotTable.[Деснянський], 0) AS Desnyansky,
			isnull(PivotTable.[Дніпровський], 0) AS Dnirovsky,
			isnull(PivotTable.[Оболонський], 0) AS Obolonsky,
			isnull(PivotTable.[Печерський], 0) AS Pechersky,
			isnull(PivotTable.[Подільський], 0) AS Podilsky,
			isnull(PivotTable.[Святошинський], 0) AS Svyatoshinsky,
			isnull(PivotTable.[Солом`янський], 0) AS Solomiansky,
			isnull(PivotTable.[Шевченківський], 0) AS Shevchenkovsky
		FROM
			(
				SELECT
					qt.[name] AS questionType,
					d.[name] AS district,
					isnull(count(q.Id), 0) AS questionQty
				FROM
					dbo.Questions q
					INNER JOIN dbo.QuestionTypes qt ON qt.Id = q.question_type_id
					INNER JOIN dbo.Assignments ass ON ass.Id = q.last_assignment_for_execution_id
					INNER JOIN dbo.[Objects] o ON o.Id = q.[object_id]
					INNER JOIN dbo.[Buildings] b ON b.Id = o.builbing_id
					INNER JOIN dbo.[Districts] d ON d.Id = b.district_id 
				WHERE
					q.registration_date BETWEEN @filterFrom
					AND @filterTo
					AND qt.Id IN (
						SELECT
							typeQ
						FROM
							@question_t
					)
					AND ass.executor_organization_id IN (SELECT 
														 DISTINCT 
															questionOrg
														FROM @organization_t)
														
				GROUP BY
					qt.[name],
					d.[name]
			) AS q_tab PIVOT (
				SUM(questionQty) FOR district IN (
					[Голосіївський],
					[Дарницький],
					[Деснянський],
					[Дніпровський],
					[Оболонський],
					[Печерський],
					[Подільський],
					[Святошинський],
					[Солом`янський],
					[Шевченківський]
				)
			) AS PivotTable
	) x
GROUP BY
	x.questionType,
	x.Darnitsky,
	x.Desnyansky,
	x.Dnirovsky,
	x.Golosiivsky,
	x.Obolonsky,
	x.Pechersky,
	x.Podilsky,
	x.Shevchenkovsky,
	x.Solomiansky,
	x.Svyatoshinsky
ORDER BY
	allQuestionsQty DESC ;