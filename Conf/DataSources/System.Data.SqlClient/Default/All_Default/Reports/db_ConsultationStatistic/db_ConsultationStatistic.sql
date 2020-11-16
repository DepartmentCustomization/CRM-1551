-- DECLARE @dateFrom DATETIME = '2020-08-31T21:00:00.000Z';
-- DECLARE @dateTo DATETIME = GETDATE();

IF OBJECT_ID ('tempdb..#Knowledge') IS NOT NULL
BEGIN
	DROP TABLE #Knowledge;
END

CREATE TABLE #Knowledge ([Id] INT, 
						 [parent_id] INT,
						 [Name] NVARCHAR(300),
						 [article_qty] INT,
						 [article_percent] NUMERIC(5,2),
						 [talk_all] TIME,
						 [talk_consultations_only] TIME,
						 [talk_consultation_average] TIME
						 ) WITH (DATA_COMPRESSION = PAGE);
--> Общее значение консультаций
DECLARE @Knowledge_AllVal INT; 
SELECT 
	@Knowledge_AllVal = SUM(number_by_day)
FROM dbo.ConsultationStatistic cs
INNER JOIN CRM_1551_System.dbo.[User] u ON u.[UserId] = cs.[user_id]
WHERE 
	#filter_columns# AND
CAST(main_datetime AS DATE) 
BETWEEN @dateFrom AND @dateTo;
--> Сбор данных по статистике типов 
INSERT INTO #Knowledge 
SELECT 
	[Id],
	[parent_id],
	[name],
	SUM(ISNULL(cs.number_by_day,0)) AS [article_qty], 
    CASE WHEN SUM(cs.number_by_day) > 0 
		 THEN 
		 CAST(CAST(SUM(cs.number_by_day) AS NUMERIC(10,2))
		 / CAST(@Knowledge_AllVal AS NUMERIC(10,2)) AS NUMERIC(10,2)) * 100
		 ELSE 0 END 
  		AS [article_percent], 
    CONVERT(VARCHAR(15), DATEADD(SECOND,SUM(ISNULL(cs.duration,0)),0),108) 
  		AS [talk_all], 
    CONVERT(VARCHAR(15), DATEADD(SECOND,SUM(cs.duration_only_cons),0),108) 
  		AS [talk_consultations_only], 
    CASE WHEN SUM(cs.number_only_cons) > 0 
		 THEN 
		 CONVERT(VARCHAR(15), DATEADD(SECOND,(SUM(ISNULL(cs.duration_only_cons,0)) / SUM(ISNULL(cs.number_only_cons,0))),0),108)
		 ELSE '00:00:00' END
  		AS [talk_consultation_average]
FROM dbo.KnowledgeBaseStates kn_base
LEFT JOIN dbo.ConsultationStatistic cs ON cs.article_id = kn_base.id
LEFT JOIN CRM_1551_System.dbo.[User] u ON u.[UserId] = cs.[user_id]
WHERE 
	#filter_columns# AND
	CAST(cs.main_datetime AS DATE)
	BETWEEN @dateFrom AND @dateTo
GROUP BY  
		 [Id], 
		 [parent_id],
		 [name]
ORDER BY 2,1;

 --select * from #Knowledge;

INSERT INTO #Knowledge
SELECT 
	[Id], 
	[parent_id],
	[Name],
	0 AS [article_qty],
	0 AS [article_percent],
	'00:00:00' AS [talk_all],
	'00:00:00' AS [talk_consultations_only],
	'00:00:00' AS [talk_consultation_average]
FROM dbo.KnowledgeBaseStates
WHERE parent_id = 1 
AND Id NOT IN (SELECT Id FROM #Knowledge);

IF OBJECT_ID('tempdb..#RootVals') IS NOT NULL
BEGIN
	DROP TABLE #RootVals;
END
SELECT 
	[Id],
	[parent_id],
	[Name],
	[article_qty],
	[article_percent],
	[talk_all],
	[talk_consultations_only],
	[talk_consultation_average] 
INTO #RootVals
FROM #Knowledge 
WHERE parent_id = 1;

--SELECT * FROM #RootVals;

DECLARE @RootCircle TABLE (Id INT);
INSERT INTO @RootCircle
SELECT 
	[Id]
FROM #RootVals;

--SELECT * FROM @RootCircle; 

DECLARE @Count SMALLINT = (SELECT COUNT(1) FROM @RootCircle);
DECLARE @Step TINYINT = 1;
DECLARE @Current INT;
DECLARE @StepValues TABLE (Id INT);

WHILE (@Step <= @Count)
BEGIN
	DELETE FROM @StepValues;
	SET @Current = (SELECT TOP 1 [Id] FROM @RootCircle);
	 
	WITH Knowledge_Rec ([Id], [parent_id], [Name])
	AS
	(
		SELECT [Id], 
			   [parent_id], 
			   [Name]
		FROM #Knowledge e
		WHERE e.Id = @Current 
		UNION ALL
		SELECT e.[Id], 
			   e.[parent_id], 
			   e.[Name]
		FROM #Knowledge e
		INNER JOIN Knowledge_Rec r ON e.parent_id = r.Id
	)
	
	INSERT INTO @StepValues
	SELECT 
		[Id]
	FROM Knowledge_Rec;

	UPDATE #RootVals
		SET [article_qty] = (SELECT SUM([article_qty]) FROM #Knowledge WHERE [Id] IN (SELECT [Id] FROM @StepValues)),
			[article_percent] = (SELECT SUM([article_percent]) FROM #Knowledge WHERE [Id] IN (SELECT [Id] FROM @StepValues)),
			[talk_all] = (SELECT DATEADD(ms, SUM(DATEDIFF(ms, 0, [talk_all])), 0) FROM #Knowledge WHERE [Id] IN (SELECT [Id] FROM @StepValues)),
			[talk_consultations_only] = (SELECT DATEADD(ms, SUM(DATEDIFF(ms, 0, [talk_consultations_only])), 0) FROM #Knowledge WHERE [Id] IN (SELECT [Id] FROM @StepValues)),
			[talk_consultation_average] = (SELECT DATEADD(ms, AVG(DATEDIFF(ms, 0, [talk_consultation_average])), 0) FROM #Knowledge WHERE [Id] IN (SELECT [Id] FROM @StepValues))
	WHERE [Id] = @Current;

	DELETE FROM @RootCircle
	WHERE Id = @Current;
	
	SET @Step +=1;
END

SELECT 
DISTINCT
	[Id],
	[Name],
	[article_qty],
	[article_percent],
	CONVERT(VARCHAR(8), [talk_all], 108) AS [talk_all],
	CONVERT(VARCHAR(8), [talk_consultations_only], 108) AS [talk_consultations_only],
	CONVERT(VARCHAR(8), [talk_consultation_average], 108) AS [talk_consultation_average],
	NULL AS [UserId]
FROM #RootVals
ORDER BY [Name];