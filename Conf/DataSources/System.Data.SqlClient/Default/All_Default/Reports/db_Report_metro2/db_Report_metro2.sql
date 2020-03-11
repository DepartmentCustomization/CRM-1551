--   DECLARE @dateFrom DATETIME = '2020-03-10';
--   DECLARE @dateTo DATETIME = '2020-03-11';

  DECLARE @targettimezone AS sysname = 'E. Europe Standard Time';
  ---> преобразование параметров дата-время из UTC в локальные значения
  SET @dateFrom = Dateadd(hh, Datediff(hh, Getutcdate(), Getdate()), @dateFrom);
  SET @dateTo = Dateadd(hh, Datediff(hh, Getutcdate(), Getdate()), @dateTo);
  
  SELECT 
    Id, 
	qty,
	qType
  FROM (
  SELECT 
  	   ROW_NUMBER() OVER(
        ORDER BY
            qt.[name] ASC
       ) AS Id,
		COUNT(ass.Id) AS qty,
		qt.[name] AS qType
	FROM dbo.Assignments ass
	INNER JOIN dbo.Questions q ON q.Id = ass.question_id
	INNER JOIN dbo.QuestionTypes qt ON qt.Id = q.question_type_id
	WHERE executor_organization_id = 51 
	AND DATEADD(hh, DATEDIFF(hh, GETUTCDATE(), GETDATE()), ass.registration_date)
	BETWEEN @dateFrom AND  @dateTo
	GROUP BY qt.name 
	) Messi 
	ORDER BY qty
	DESC ;