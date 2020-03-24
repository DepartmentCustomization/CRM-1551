    -- DECLARE @dateFrom DATETIME = '2020-03-10 00:00';
    -- DECLARE @dateTo DATETIME = '2020-03-11 00:00';

  DECLARE @targettimezone AS sysname = 'E. Europe Standard Time';
  ---> преобразование параметров дата-время из UTC в локальные значения
  SET @dateFrom = Dateadd(hh, Datediff(hh, Getutcdate(), Getdate()), @dateFrom);
  SET @dateTo = Dateadd(hh, Datediff(hh, Getutcdate(), Getdate()), @dateTo);

  DECLARE @rsNames TABLE (sourceID INT, souceName NVARCHAR(100), pos TINYINT);
  INSERT INTO @rsNames (sourceID, souceName)
  SELECT 
		Id,
		CASE 
		WHEN [name] = N'УГЛ' THEN N'Зареєстровано звернень через УГЛ'
		WHEN [name] = N'Сайт/моб. додаток' THEN N'Зареєстровано звернень через сайт/мобільний додаток'
		WHEN [name] = N'Дзвінок в 1551' THEN N'Зареєстровано звернень через дзвінок 1551' 
		END 
 FROM dbo.ReceiptSources
 WHERE Id IN (1,2,3)

 UNION ALL
 SELECT 4, N'Надано усних консультацій'

 UNION ALL 
 SELECT 5, N'Отримано дзвінків на лінію з питань метрополітену';

 UPDATE @rsNames
 SET pos = CASE
 WHEN sourceID = 5 THEN 1
 WHEN sourceID = 4 THEN 2
 WHEN sourceID = 3 THEN 4
 WHEN sourceID = 2 THEN 3
 WHEN sourceID = 1 THEN 5 
 END
 FROM @rsNames ;

DROP TABLE IF EXISTS ##tempData;

 SELECT 
	    ROW_NUMBER() OVER(
        ORDER BY
            app.receipt_source_id ASC
       ) AS Id,
		COUNT(ass.Id) qty,
		app.receipt_source_id

		INTO ##tempData 

	FROM dbo.Assignments ass
	INNER JOIN dbo.Questions q ON q.Id = ass.question_id
	INNER JOIN dbo.Appeals app ON app.Id = q.appeal_id
	WHERE executor_organization_id = 51 
	AND DATEADD(hh, DATEDIFF(hh, GETUTCDATE(), GETDATE()), ass.registration_date) 
	BETWEEN @dateFrom AND  @dateTo
	GROUP BY app.receipt_source_id ;


	DECLARE @otherVal INT  =  (
	SELECT 
		COUNT(ass.Id) 
	FROM dbo.Assignments ass
	INNER JOIN dbo.Questions q ON q.Id = ass.question_id
	INNER JOIN dbo.Appeals app ON app.Id = q.appeal_id
	WHERE executor_organization_id = 51 
	AND DATEADD(hh, DATEDIFF(hh, GETUTCDATE(), GETDATE()), ass.registration_date)
	BETWEEN @dateFrom AND  @dateTo 
	AND app.receipt_source_id > 3 
	   );
 
    IF(@otherVal > 0)
	BEGIN 
	UPDATE ##tempData
	SET qty = ISNULL(qty, 0) + @otherVal 
	WHERE ##tempData.receipt_source_id = 1 ;
	END

	SELECT 
		rs.sourceID AS Id,
		rs.souceName AS [source],
		ISNULL(td.qty, 0) AS val 
	FROM @rsNames rs
	LEFT JOIN ##tempData td ON td.receipt_source_id = rs.sourceID
	ORDER BY pos ;