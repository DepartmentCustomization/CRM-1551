--  DECLARE @questionType INT = 2;
--  DECLARE @questionGroup INT = 11;
--  DECLARE @organization INT = 3;
--  DECLARE @organizationGroup INT = 0;
--  DECLARE @dateFrom DATE = '2019-12-01';
--  DECLARE @dateTo DATE = cast(CURRENT_TIMESTAMP AS DATE); 
--  DECLARE @sourceId NVARCHAR(50) = '1,3,4';

DECLARE @question_t TABLE (typeQ INT);
DECLARE @question_g TABLE (typeG INT);
DECLARE @organization_t TABLE (questionOrg INT);
DECLARE @source_t TABLE (Id INT);

SET @organization = IIF(@organization = 0, 1, @organization);
SET @organizationGroup = IIF(@organizationGroup = 0, NULL, @organization);

BEGIN
WITH RecursiveOrg (Id, parentID) AS (
    SELECT
        o.Id,
        parent_organization_id
    FROM
       [dbo].[Organizations] o WITH (NOLOCK)
    WHERE
        o.Id = @organization
    UNION
    ALL
    SELECT
        o.Id,
        o.parent_organization_id
    FROM
        [dbo].[Organizations] o WITH (NOLOCK)
        JOIN RecursiveOrg r ON o.parent_organization_id = r.Id
)
INSERT INTO
    @organization_t
SELECT
     Id
FROM
    RecursiveOrg r ;
END

--select @organizationGroup

IF(@organizationGroup IS NOT NULL)
BEGIN
	INSERT INTO @organization_t(questionOrg)
	SELECT 
		organization_id
	FROM dbo.OGroupIncludeOrganizations WITH (NOLOCK) 
	WHERE organization_group_id = @organizationGroup ;
END

IF(@sourceId = N'0')
BEGIN
INSERT INTO @source_t(Id)
SELECT
	Id
FROM dbo.[ReceiptSources] ;
END
ELSE IF(@sourceId != N'0')
BEGIN
INSERT INTO @source_t(Id)
SELECT 
	value 
FROM STRING_SPLIT(@sourceId, ',');
END

IF @questionType = 0 
BEGIN
	INSERT INTO @question_t (typeQ)
	SELECT [Id]
	FROM dbo.QuestionTypes WITH (NOLOCK);
END
ELSE 
BEGIN 
	DECLARE @question_type_id INT = @questionType;
	--declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
	--[QuestionTypes].question_type_id
	DECLARE @QuestionTypes TABLE(Id INT);
	DECLARE @QuestionTypesId INT = @question_type_id;
	DECLARE @IdT TABLE (Id INT);

	INSERT INTO
		@IdT(Id)
	SELECT
		Id
	FROM
		[dbo].[QuestionTypes] WITH (NOLOCK)
	WHERE
		(
			Id = @QuestionTypesId
			OR [question_type_id] = @QuestionTypesId
		)
		AND Id NOT IN (
			SELECT
				Id
			FROM
				@IdT
		) ;
		WHILE (
			SELECT
				count(id)
			FROM
				(
					SELECT
						Id
					FROM
						[dbo].[QuestionTypes] WITH (NOLOCK)
					WHERE
						[question_type_id] IN (SELECT Id FROM @IdT)
						AND Id NOT IN (SELECT Id FROM @IdT)
				) q
		) != 0 BEGIN
	INSERT INTO
		@IdT
	SELECT
		Id
	FROM
		[dbo].[QuestionTypes] WITH (NOLOCK)
	WHERE
		[question_type_id] IN (
			SELECT
				Id
			FROM
				@IdT
		) 
		AND Id NOT IN (
			SELECT
				Id
			FROM
				@IdT
		) ;
	END


	INSERT INTO @QuestionTypes (Id)
	SELECT Id
	FROM @IdT;
	
	INSERT INTO
		@question_t (typeQ)
	SELECT Id
	FROM @QuestionTypes ;
END --- Для поиска QuestionTypes по группе


IF @questionGroup = 0 
BEGIN
	INSERT INTO @question_g (typeG)
	SELECT [Id]
	FROM dbo.QuestionTypes  WITH (NOLOCK); 
END
ELSE 
BEGIN 
	-- НАХОДИМ ИД QuestionTypes которые входят в выбранную QuestionGroups
	INSERT INTO @question_g(typeG)
	SELECT DISTINCT qt.Id
	FROM
		dbo.QuestionTypes qt WITH (NOLOCK)
		LEFT JOIN dbo.QGroupIncludeQTypes qgiqt WITH (NOLOCK) ON qgiqt.type_question_id = qt.Id
		LEFT JOIN dbo.QuestionGroups qg WITH (NOLOCK) ON qg.Id = qgiqt.group_question_id 
	WHERE
		qg.report_code = 'Analitica_spheres'
		AND qg.Id = @questionGroup ;
END --  select * from @question_g

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

IF OBJECT_ID('tempdb..#temp_OUT_Questions') IS NOT NULL
BEGIN
	DROP TABLE #temp_OUT_Questions;
END
CREATE TABLE #temp_OUT_Questions (
	questionQ INT,
	typeId INT,
	[source] INT
) WITH (DATA_COMPRESSION = PAGE);

INSERT INTO #temp_OUT_Questions ([questionQ], [typeId])
SELECT
	COUNT(q.Id) AS questionQ,
	question_type_id AS typeId
FROM
	[dbo].[Questions] q WITH (NOLOCK)
	LEFT JOIN [dbo].[Appeals] ap WITH (NOLOCK) ON ap.Id = q.appeal_id
	LEFT JOIN [dbo].ReceiptSources rs ON rs.Id = ap.receipt_source_id
	LEFT JOIN [dbo].[Assignments] a WITH (NOLOCK) ON q.last_assignment_for_execution_id = a.id
	LEFT JOIN [dbo].[Organizations] org WITH (NOLOCK) ON org.Id = a.executor_organization_id
WHERE 
	rs.Id IN (SELECT Id FROM @source_t)
	AND 
	q.registration_date BETWEEN @dateFrom AND dateadd(DAY, 1, @dateTo)
	AND a.executor_organization_id IN (SELECT questionOrg FROM @organization_t)
GROUP BY
	q.question_type_id ;

SELECT
	ROW_NUMBER() OVER(
		ORDER BY
			z.questionQty DESC
	) Id,
	*
FROM
	(
		SELECT
			DISTINCT 
			qt.[name] AS questionType,
			isnull(qty.questionQ, 0) AS questionQty
		FROM
			dbo.QuestionTypes qt  WITH (NOLOCK)
			LEFT JOIN dbo.[QGroupIncludeQTypes] qgiqt WITH (NOLOCK) ON qgiqt.type_question_id = qt.Id
			LEFT JOIN dbo.[QuestionGroups] qg WITH (NOLOCK) ON qg.Id = qgiqt.group_question_id
			LEFT JOIN #temp_OUT_Questions qty ON qty.typeId = qt.Id
		WHERE
			(qt.Id IN (SELECT typeQ FROM @question_t)
				OR qt.Id IN (SELECT Id
							 FROM dbo.QuestionTypes QuestionTypes WITH (NOLOCK)
							 WHERE question_type_id IN (SELECT typeQ FROM @question_t)
							 )
			)
			AND qt.Id IN (SELECT typeG FROM @question_g)
	) z ;