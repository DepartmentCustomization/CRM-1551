-- DECLARE @dateFrom DATE = '2019-12-01';
-- DECLARE @dateTo DATE = cast(CURRENT_TIMESTAMP AS DATE);
-- DECLARE @organization INT = 0;
-- DECLARE @organizationGroup INT = 0;
-- DECLARE @sourceId NVARCHAR(50) = N'0';

DECLARE @question_t TABLE (typeQ INT);
DECLARE @question_g TABLE (typeG INT);
DECLARE @organization_t TABLE (questionOrg INT);
DECLARE @source_t TABLE (Id INT);

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
					cast(
						cast(dateadd(DAY, 0, @dateTo) AS DATE) AS DATETIME
					)
				)
			)
		)
	)
);

SET
	@organization = IIF(@organization = 0, 1, @organization);

SET
	@organizationGroup = IIF(@organizationGroup = 0, NULL, @organization);

IF(@sourceId = N'0') 
BEGIN
INSERT INTO
	@source_t(Id)
SELECT
	Id
FROM
	dbo.[ReceiptSources];
END
ELSE IF(@sourceId != N'0') 
BEGIN
INSERT INTO
	@source_t(Id)
SELECT
	value
FROM
	STRING_SPLIT(@sourceId, ',');
END 
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
	RecursiveOrg r;
END 

IF(@organizationGroup IS NOT NULL) 
BEGIN
INSERT INTO
	@organization_t(questionOrg)
SELECT
	organization_id
FROM
	dbo.OGroupIncludeOrganizations
WHERE
	organization_group_id = @organizationGroup;

END 
IF object_id('tempdb..#temp_OUT') IS NOT NULL 
BEGIN 
	DROP TABLE #temp_OUT ;
END 
CREATE TABLE #temp_OUT(
GroupQuestionId INT,
QuestionTypeName NVARCHAR(200),
QuestionTypeId INT
) WITH (DATA_COMPRESSION = PAGE);

DECLARE @QuestionRowId INT;
DECLARE @CURSOR CURSOR;

SET
	@CURSOR = CURSOR SCROLL FOR
SELECT
	Id
FROM
	[dbo].[QuestionTypes]
WHERE
	question_type_id = 1;

OPEN @CURSOR
FETCH NEXT
FROM
	@CURSOR INTO @QuestionRowId 
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
	WITH QuestionTypesH (ParentId, Id, [Name], LEVEL, Label) AS (
		SELECT
			question_type_id AS ParentId,
			Id,
			name AS [Name],
			0,
			CAST(rtrim(Id) + '/' AS NVARCHAR(MAX)) AS Label
		FROM
			[dbo].[QuestionTypes]
		WHERE
			Id = @QuestionRowId
		UNION
		ALL
		SELECT
			o.question_type_id AS ParentId,
			o.Id,
			o.name AS [Name],
			LEVEL + 1,
			CAST(
				rtrim(h.Label) + rtrim(o.Id) + '/' AS NVARCHAR(MAX)
			) AS Label
		FROM
			[dbo].[QuestionTypes] o
			JOIN QuestionTypesH h ON o.question_type_id = h.Id
	)
INSERT INTO
	#temp_OUT (GroupQuestionId, QuestionTypeId, QuestionTypeName)
SELECT
	@QuestionRowId,
	Id,
	Name
FROM
	QuestionTypesH ;
	
	FETCH NEXT
FROM
	@CURSOR INTO @QuestionRowId
END
CLOSE @CURSOR ;

SELECT
	TOP 10 GroupQuestionId,
	CASE
		WHEN GroupQuestionId <> 0 THEN (
			SELECT
				[name]
			FROM
				dbo.QuestionTypes
			WHERE
				Id = GroupQuestionId
		)
		ELSE ''
	END AS GroupQuestionName,
	isnull(sum(val), 0) qty
FROM
	#temp_OUT o
	LEFT JOIN (
		SELECT
			count(q.Id) val,
			qt.Id
		FROM
			dbo.Questions q
			INNER JOIN dbo.[Appeals] a ON a.Id = q.appeal_id
			INNER JOIN dbo.[ReceiptSources] rs ON rs.Id = a.receipt_source_id
			INNER JOIN dbo.Assignments ass ON ass.Id = q.last_assignment_for_execution_id
			INNER JOIN dbo.QuestionTypes qt ON q.question_type_id = qt.Id
		WHERE
			rs.Id IN (
				SELECT
					Id
				FROM
					@source_t
			)
			AND q.registration_date BETWEEN @dateFrom
			AND @filterTo
			AND ass.executor_organization_id IN (
				SELECT
					DISTINCT questionOrg
				FROM
					@organization_t
			)
		GROUP BY
			qt.Id
	) z ON z.Id = o.QuestionTypeId
GROUP BY
	o.GroupQuestionId
ORDER BY
	qty DESC;