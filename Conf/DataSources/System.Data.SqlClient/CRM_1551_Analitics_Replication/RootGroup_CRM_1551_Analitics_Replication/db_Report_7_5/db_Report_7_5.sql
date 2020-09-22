-- declare @dateFrom datetime = '2020-01-01 00:00:00';
-- declare @dateTo datetime = '2020-08-11 00:00:00';
-- declare @filterTo datetime = dateadd(second,59,(dateadd(minute,59,(dateadd(hour,23,cast(cast(dateadd(day,0,@dateTo) as date) as datetime))))));

DECLARE @currentYear INT = year(@dateFrom);
DECLARE @previousYear INT = year(@dateFrom) -1;

DECLARE @tab_Rel TABLE (
	source NVARCHAR(200) COLLATE Ukrainian_CI_AS,
	prev_val INT,
	cur_val INT
);

DECLARE @tab_exPow TABLE (
	source NVARCHAR(200) COLLATE Ukrainian_CI_AS,
	prev_val INT,
	cur_val INT
);

DECLARE @tab_locMun TABLE (
	source NVARCHAR(200) COLLATE Ukrainian_CI_AS,
	prev_val INT,
	cur_val INT
);

DECLARE @tab_locPow TABLE (
	source NVARCHAR(200) COLLATE Ukrainian_CI_AS,
	prev_val INT,
	cur_val INT
);

DECLARE @tab_stCon TABLE (
	source NVARCHAR(200) COLLATE Ukrainian_CI_AS,
	prev_val INT,
	cur_val INT
);

DECLARE @tab_Oth TABLE (
	source NVARCHAR(200) COLLATE Ukrainian_CI_AS,
	prev_val INT,
	cur_val INT
);

DECLARE @tab_Employees TABLE (
	sourse NVARCHAR(200) COLLATE Ukrainian_CI_AS,
	prev_val INT,
	cur_val INT
);

DECLARE @tab_Rel2 TABLE (
	source NVARCHAR(200) COLLATE Ukrainian_CI_AS,
	prev_val INT,
	cur_val INT
);

DECLARE @tab_exPow2 TABLE (
	source NVARCHAR(200) COLLATE Ukrainian_CI_AS,
	prev_val INT,
	cur_val INT
);

DECLARE @tab_locMun2 TABLE (
	source NVARCHAR(200) COLLATE Ukrainian_CI_AS,
	prev_val INT,
	cur_val INT
);

DECLARE @tab_locPow2 TABLE (
	source NVARCHAR(200) COLLATE Ukrainian_CI_AS,
	prev_val INT,
	cur_val INT
);

DECLARE @tab_stCon2 TABLE (
	source NVARCHAR(200) COLLATE Ukrainian_CI_AS,
	prev_val INT,
	cur_val INT
);

DECLARE @tab_Oth2 TABLE (
	source NVARCHAR(200) COLLATE Ukrainian_CI_AS,
	prev_val INT,
	cur_val INT
);

IF OBJECT_ID('tempdb..#sources') IS NOT NULL 
BEGIN
	DROP TABLE #sources;
END
CREATE TABLE #sources (
row# NVARCHAR(3) NULL,
source_name VARCHAR(MAX) COLLATE Ukrainian_CI_AS
) WITH (DATA_COMPRESSION = Page); 

BEGIN
INSERT INTO
	#sources (source_name)
SELECT
	name
FROM
	dbo.[ReceiptSources]
WHERE
	Id NOT IN (5, 6, 7)
UNION
SELECT
	N'КБУ';
--select * from #sources
END 
--- Діяльність об'єднань громадян, релігії та міжконфесійних відносин
BEGIN
INSERT INTO
	@tab_Rel (source, prev_val, cur_val) 
	-- Попередній рік
SELECT
	z.source_name,
	isnull(RelPrev, 0) ComPrev,
	isnull(RelCur, 0) ComCur
FROM
	#sources z
	LEFT JOIN (
		SELECT
			source_name,
			count(q.Id) RelPrev
		FROM
			#sources sources
			LEFT JOIN dbo.[ReceiptSources] rs ON rs.name = sources.source_name
			LEFT JOIN dbo.[Appeals] a ON a.receipt_source_id = rs.Id
			LEFT JOIN dbo.[Questions] q ON q.appeal_id = a.Id
		WHERE
			q.question_type_id IN (
				SELECT
					type_question_id
				FROM
					dbo.[QGroupIncludeQTypes] QGroupIncludeQTypes
				WHERE
					group_question_id = 18
			)
			AND year(q.registration_date) = @previousYear
			AND datepart(dayofyear, q.registration_date) 
			BETWEEN datepart(dayofyear, @dateFrom)
			AND datepart(dayofyear, @dateTo)
		GROUP BY
			sources.source_name 
		UNION
		SELECT
			N'КБУ' AS source_name,
			isnull(count(q.Id), 0)
		FROM
			dbo.[Questions] q
		WHERE
			q.question_type_id IN (
				SELECT
					type_question_id
				FROM
					dbo.[QGroupIncludeQTypes] QGroupIncludeQTypes
				WHERE
					group_question_id = 18
			)
			AND year(registration_date) = @previousYear
			AND datepart(dayofyear, q.registration_date) 
			BETWEEN datepart(dayofyear, @dateFrom)
			AND datepart(dayofyear, @dateTo)
	) s ON s.source_name = z.source_name 
	-- Теперішній рік
	LEFT JOIN (
		SELECT
			source_name,
			count(q.Id) RelCur
		FROM
			#sources sources
			LEFT JOIN dbo.[ReceiptSources] rs ON rs.name = sources.source_name
			LEFT JOIN dbo.[Appeals] a ON a.receipt_source_id = rs.Id
			LEFT JOIN dbo.[Questions] q ON q.appeal_id = a.Id
		WHERE
			q.question_type_id IN (
				SELECT
					type_question_id
				FROM
					dbo.[QGroupIncludeQTypes] QGroupIncludeQTypes
				WHERE
					group_question_id = 18
			)
			AND year(q.registration_date) = @currentYear
			AND datepart(dayofyear, q.registration_date) 
			BETWEEN datepart(dayofyear, @dateFrom)
			AND datepart(dayofyear, @dateTo)
		GROUP BY
			sources.source_name 
		UNION
		SELECT
			N'КБУ' AS source_name,
			isnull(count(q.Id), 0) Val
		FROM
			dbo.[Questions] q
		WHERE
			q.question_type_id IN (
				SELECT
					type_question_id
				FROM
					dbo.[QGroupIncludeQTypes] QGroupIncludeQTypes
				WHERE
					group_question_id = 18
			)
			AND year(registration_date) = @currentYear
			AND datepart(dayofyear, q.registration_date) 
			BETWEEN datepart(dayofyear, @dateFrom)
			AND datepart(dayofyear, @dateTo)
	) ss ON ss.source_name = z.source_name;
END 
--- Діяльність центральних органів виконавчої влади
BEGIN
INSERT INTO
	@tab_exPow (source, prev_val, cur_val)
SELECT
	z.source_name,
	0,
	0
FROM
	#sources z
UNION
SELECT
	N'КБУ' AS source_name,
	0,
	0;
END 
--- Діяльність місцевих органів виконавчої влади
BEGIN
INSERT INTO
	@tab_locMun (source, prev_val, cur_val) 
	-- Попередній рік
SELECT
	z.source_name,
	isnull(locMunPrev, 0) locMunPrev,
	isnull(locMunCur, 0) locMunCur
FROM
	#sources z
	LEFT JOIN (
		SELECT
			source_name,
			count(q.Id) locMunPrev
		FROM
			#sources sources
			LEFT JOIN dbo.[ReceiptSources] rs ON rs.name = sources.source_name
			LEFT JOIN dbo.[Appeals] a ON a.receipt_source_id = rs.Id
			LEFT JOIN dbo.[Questions] q ON q.appeal_id = a.Id
		WHERE
			q.question_type_id IN (
				SELECT
					type_question_id
				FROM
					dbo.[QGroupIncludeQTypes] QGroupIncludeQTypes
				WHERE
					group_question_id = 19
			)
			AND year(q.registration_date) = @previousYear
			AND datepart(dayofyear, q.registration_date) 
			BETWEEN datepart(dayofyear, @dateFrom)
			AND datepart(dayofyear, @dateTo)
		GROUP BY
			sources.source_name 
		UNION
		SELECT
			N'КБУ' AS source_name,
			isnull(count(q.Id), 0)
		FROM
			dbo.[Questions] q
		WHERE
			q.question_type_id IN (
				SELECT
					type_question_id
				FROM
					dbo.[QGroupIncludeQTypes] QGroupIncludeQTypes
				WHERE
					group_question_id = 19
			)
			AND year(registration_date) = @previousYear
			AND datepart(dayofyear, q.registration_date) 
			BETWEEN datepart(dayofyear, @dateFrom)
			AND datepart(dayofyear, @dateTo)
	) s ON s.source_name = z.source_name 
	-- Теперішній рік
	LEFT JOIN (
		SELECT
			source_name,
			count(q.Id) locMunCur
		FROM
			#sources sources
			LEFT JOIN dbo.[ReceiptSources] rs ON rs.name = sources.source_name
			LEFT JOIN dbo.[Appeals] a ON a.receipt_source_id = rs.Id
			LEFT JOIN dbo.[Questions] q ON q.appeal_id = a.Id
		WHERE
			q.question_type_id IN (
				SELECT
					type_question_id
				FROM
					dbo.[QGroupIncludeQTypes] QGroupIncludeQTypes
				WHERE
					group_question_id = 19
			)
			AND year(q.registration_date) = @currentYear
			AND datepart(dayofyear, q.registration_date) 
			BETWEEN datepart(dayofyear, @dateFrom)
			AND datepart(dayofyear, @dateTo)
		GROUP BY
			sources.source_name 
		UNION
		SELECT
			N'КБУ' AS source_name,
			isnull(count(q.Id), 0) Val
		FROM
			dbo.[Questions] q
		WHERE
			q.question_type_id IN (
				SELECT
					type_question_id
				FROM
					dbo.[QGroupIncludeQTypes] QGroupIncludeQTypes
				WHERE
					group_question_id = 19
			)
			AND year(registration_date) = @currentYear
			AND datepart(dayofyear, q.registration_date) 
			BETWEEN datepart(dayofyear, @dateFrom)
			AND datepart(dayofyear, @dateTo)
	) ss ON ss.source_name = z.source_name;
END 
--- Забезпечення дотримання законності та охорони правопорядку, запобігання дискримінації
BEGIN
INSERT INTO
	@tab_locPow (source, prev_val, cur_val)
SELECT
	z.source_name,
	0,
	0
FROM
	#sources z
UNION
SELECT
	N'КБУ' AS source_name,
	0,
	0;
END 
--- Державного будівництва, адміністративно-територіального устрою
BEGIN
INSERT INTO
	@tab_stCon (source, prev_val, cur_val) 
	-- Попередній рік
SELECT
	z.source_name,
	isnull(stConPrev, 0) stConPrev,
	isnull(stConCur, 0) stConCur
FROM
	#sources z
	LEFT JOIN (
		SELECT
			source_name,
			count(q.Id) stConPrev
		FROM
			#sources sources
			LEFT JOIN dbo.[ReceiptSources] rs ON rs.name = sources.source_name
			LEFT JOIN dbo.[Appeals] a ON a.receipt_source_id = rs.Id
			LEFT JOIN dbo.[Questions] q ON q.appeal_id = a.Id
		WHERE
			q.question_type_id IN (
				SELECT
					type_question_id
				FROM
					dbo.[QGroupIncludeQTypes] QGroupIncludeQTypes
				WHERE
					group_question_id = 13
			)
			AND year(q.registration_date) = @previousYear
			AND datepart(dayofyear, q.registration_date) 
			BETWEEN datepart(dayofyear, @dateFrom)
			AND datepart(dayofyear, @dateTo)
		GROUP BY
			sources.source_name 
		UNION
		SELECT
			N'КБУ' AS source_name,
			isnull(count(q.Id), 0)
		FROM
			dbo.[Questions] q
		WHERE
			q.question_type_id IN (
				SELECT
					type_question_id
				FROM
					dbo.[QGroupIncludeQTypes] QGroupIncludeQTypes
				WHERE
					group_question_id = 13
			)
			AND year(registration_date) = @previousYear
			AND datepart(dayofyear, q.registration_date) 
			BETWEEN datepart(dayofyear, @dateFrom)
			AND datepart(dayofyear, @dateTo)
	) s ON s.source_name = z.source_name 
	-- Теперішній рік
	LEFT JOIN (
		SELECT
			source_name,
			count(q.Id) stConCur
		FROM
			#sources sources
			LEFT JOIN dbo.[ReceiptSources] rs ON rs.name = sources.source_name
			LEFT JOIN dbo.[Appeals] a ON a.receipt_source_id = rs.Id
			LEFT JOIN dbo.[Questions] q ON q.appeal_id = a.Id
		WHERE
			q.question_type_id IN (
				SELECT
					type_question_id
				FROM
					dbo.[QGroupIncludeQTypes] QGroupIncludeQTypes
				WHERE
					group_question_id = 13
			)
			AND year(q.registration_date) = @currentYear
			AND datepart(dayofyear, q.registration_date) 
			BETWEEN datepart(dayofyear, @dateFrom)
			AND datepart(dayofyear, @dateTo)
		GROUP BY
			sources.source_name 
		UNION
		SELECT
			N'КБУ' AS source_name,
			isnull(count(q.Id), 0) Val
		FROM
			dbo.[Questions] q
		WHERE
			q.question_type_id IN (
				SELECT
					type_question_id
				FROM
					dbo.[QGroupIncludeQTypes] QGroupIncludeQTypes
				WHERE
					group_question_id = 13
			)
			AND year(registration_date) = @currentYear
			AND datepart(dayofyear, q.registration_date) 
			BETWEEN datepart(dayofyear, @dateFrom)
			AND datepart(dayofyear, @dateTo)
	) ss ON ss.source_name = z.source_name;
END 
--- Інші
BEGIN
INSERT INTO
	@tab_Oth (source, prev_val, cur_val) 
	-- Попередній рік
SELECT
	z.source_name,
	isnull(OthPrev, 0) OthPrev,
	isnull(OthCur, 0) OthCur
FROM
	#sources z
	LEFT JOIN (
		SELECT
			source_name,
			count(q.Id) OthPrev
		FROM
			#sources sources
			LEFT JOIN dbo.[ReceiptSources] rs ON rs.name = sources.source_name
			LEFT JOIN dbo.[Appeals] a ON a.receipt_source_id = rs.Id
			LEFT JOIN dbo.[Questions] q ON q.appeal_id = a.Id
		WHERE
			q.question_type_id IS NOT NULL
			AND q.question_type_id NOT IN (
				SELECT
					type_question_id
				FROM
					dbo.[QGroupIncludeQTypes] QGroupIncludeQTypes
				WHERE
					group_question_id BETWEEN 5
					AND 19
			)
			AND year(q.registration_date) = @previousYear
			AND datepart(dayofyear, q.registration_date) 
			BETWEEN datepart(dayofyear, @dateFrom)
			AND datepart(dayofyear, @dateTo)
		GROUP BY
			sources.source_name 
		UNION
		SELECT
			N'КБУ' AS source_name,
			isnull(count(q.Id), 0) Val
		FROM
			dbo.[Questions] q
		WHERE
			q.question_type_id IS NOT NULL
			AND q.question_type_id NOT IN (
				SELECT
					type_question_id
				FROM
					dbo.[QGroupIncludeQTypes] QGroupIncludeQTypes 
				WHERE
					group_question_id BETWEEN 5
					AND 19
			)
			AND year(registration_date) = @previousYear
			AND datepart(dayofyear, q.registration_date)
			BETWEEN datepart(dayofyear, @dateFrom)
			AND datepart(dayofyear, @dateTo)
	) s ON s.source_name = z.source_name 
	-- Теперішній рік
	LEFT JOIN (
		SELECT
			source_name,
			count(q.Id) OthCur
		FROM
			#sources sources
			LEFT JOIN dbo.[ReceiptSources] rs ON rs.name = sources.source_name
			LEFT JOIN dbo.[Appeals] a ON a.receipt_source_id = rs.Id
			LEFT JOIN dbo.[Questions] q ON q.appeal_id = a.Id
		WHERE
			q.question_type_id IS NOT NULL
			AND q.question_type_id NOT IN (
				SELECT
					type_question_id
				FROM
					dbo.[QGroupIncludeQTypes] QGroupIncludeQTypes 
				WHERE
					group_question_id 
					BETWEEN 5 AND 19
			)
			AND year(q.registration_date) = @currentYear
			AND datepart(dayofyear, q.registration_date) 
			BETWEEN datepart(dayofyear, @dateFrom)
			AND datepart(dayofyear, @dateTo)
		GROUP BY
			sources.source_name 
		UNION
		SELECT
			N'КБУ' AS source_name,
			isnull(count(q.Id), 0) Val 
			-- difference in 2019 year
		FROM
			dbo.[Questions] q
		WHERE
			q.question_type_id IS NOT NULL
			AND q.question_type_id NOT IN (
				SELECT
					type_question_id
				FROM
					dbo.[QGroupIncludeQTypes] QGroupIncludeQTypes 
				WHERE
					group_question_id BETWEEN 5
					AND 19
			)
			AND year(registration_date) = @currentYear
			AND datepart(dayofyear, q.registration_date) 
			BETWEEN datepart(dayofyear, @dateFrom)
			AND datepart(dayofyear, @dateTo)
	) ss ON ss.source_name = z.source_name;
END 
--- Штатна чисельність підрозідлу роботи зі зверненнями
BEGIN
INSERT INTO
	@tab_Employees (sourse, prev_val, cur_val)
SELECT
	source_name,
	CASE
		WHEN source_name = N'КБУ' THEN 125
		ELSE 0
	END,
	CASE
		WHEN source_name = N'КБУ' THEN 125
		ELSE 0
	END
FROM
	#sources;
END
UPDATE
	@tab_Rel
SET
	source = N'Сайт/моб. додаток'
WHERE
	source = N'E-mail';
UPDATE
	@tab_exPow
SET
	source = N'Сайт/моб. додаток'
WHERE
	source = N'E-mail';
UPDATE
	@tab_locMun
SET
	source = N'Сайт/моб. додаток'
WHERE
	source = N'E-mail';
UPDATE
	@tab_locPow
SET
	source = N'Сайт/моб. додаток'
WHERE
	source = N'E-mail';
UPDATE
	@tab_stCon
SET
	source = N'Сайт/моб. додаток'
WHERE
	source = N'E-mail';
UPDATE
	@tab_Oth
SET
	source = N'Сайт/моб. додаток'
WHERE
	source = N'E-mail';
DELETE FROM
	#sources WHERE source_name = N'E-mail';
	BEGIN 
	DECLARE @result TABLE (
		source NVARCHAR(200),
		prevRel NVARCHAR(10),
		curRel NVARCHAR(10),
		prevExPow NVARCHAR(10),
		curExPow NVARCHAR(10),
		prevLocMun NVARCHAR(10),
		curLocMun NVARCHAR(10),
		prevLocPow NVARCHAR(10),
		curLocPow NVARCHAR(10),
		prevStCon NVARCHAR(10),
		curStCon NVARCHAR(10),
		prevOth NVARCHAR(10),
		curOth NVARCHAR(10),
		prevEmployees NVARCHAR(10),
		curEmployees NVARCHAR(10)
	);
	-------------> Преобразование и обнова для верочки данных <--------------       
	-- Religy
	DECLARE @prevQtyRel_rs2 INT = (
		SELECT
			sum(isnull(prev_val, 0))
		FROM
			@tab_Rel
		WHERE
			source IN (N'КБУ')
	) - (
		SELECT
			sum(isnull(prev_val, 0))
		FROM
			@tab_Rel
		WHERE
			source IN (N'Сайт/моб. додаток', N'УГЛ', N'Телеефір')
	),
	@curQtyRel_rs2 INT = (
		SELECT
			sum(isnull(cur_val, 0))
		FROM
			@tab_Rel
		WHERE
			source IN (N'КБУ')
	) - (
		SELECT
			sum(isnull(cur_val, 0))
		FROM
			@tab_Rel
		WHERE
			source IN (N'Сайт/моб. додаток', N'УГЛ', N'Телеефір')
	),
	-- Center Power
	@prevQtyExPow_rs2 INT = (
		SELECT
			sum(isnull(prev_val, 0))
		FROM
			@tab_exPow
		WHERE
			source IN (N'КБУ')
	) - (
		SELECT
			sum(isnull(prev_val, 0))
		FROM
			@tab_exPow
		WHERE
			source IN (N'Сайт/моб. додаток', N'УГЛ', N'Телеефір')
	),
	@curQtyExPow_rs2 INT = (
		SELECT
			sum(isnull(cur_val, 0))
		FROM
			@tab_exPow
		WHERE
			source IN (N'КБУ')
	) - (
		SELECT
			sum(isnull(cur_val, 0))
		FROM
			@tab_exPow
		WHERE
			source IN (N'Сайт/моб. додаток', N'УГЛ', N'Телеефір')
	),
	-- Local Municipalitet
	@prevQtyLocMun_rs2 INT = (
		SELECT
			sum(isnull(prev_val, 0))
		FROM
			@tab_locMun
		WHERE
			source IN (N'КБУ')
	) - (
		SELECT
			sum(isnull(prev_val, 0))
		FROM
			@tab_locMun
		WHERE
			source IN (N'Сайт/моб. додаток', N'УГЛ', N'Телеефір')
	),
	@curQtyLocMun_rs2 INT = (
		SELECT
			sum(isnull(cur_val, 0))
		FROM
			@tab_locMun
		WHERE
			source IN (N'КБУ')
	) - (
		SELECT
			sum(isnull(cur_val, 0))
		FROM
			@tab_locMun
		WHERE
			source IN (N'Сайт/моб. додаток', N'УГЛ', N'Телеефір')
	),
	-- Local Power
	@prevQtyLocPow_rs2 INT = (
		SELECT
			sum(isnull(prev_val, 0))
		FROM
			@tab_locPow
		WHERE
			source IN (N'КБУ')
	) - (
		SELECT
			sum(isnull(prev_val, 0))
		FROM
			@tab_locPow
		WHERE
			source IN (N'Сайт/моб. додаток', N'УГЛ', N'Телеефір')
	),
	@curQtyLocPow_rs2 INT = (
		SELECT
			sum(isnull(cur_val, 0))
		FROM
			@tab_locPow
		WHERE
			source IN (N'КБУ')
	) - (
		SELECT
			sum(isnull(cur_val, 0))
		FROM
			@tab_locPow
		WHERE
			source IN (N'Сайт/моб. додаток', N'УГЛ', N'Телеефір')
	),
	-- Construction 
	@prevQtyCon_rs2 INT = (
		SELECT
			sum(isnull(prev_val, 0))
		FROM
			@tab_stCon
		WHERE
			source IN (N'КБУ')
	) - (
		SELECT
			sum(isnull(prev_val, 0))
		FROM
			@tab_stCon
		WHERE
			source IN (N'Сайт/моб. додаток', N'УГЛ', N'Телеефір')
	),
	@curQtyCon_rs2 INT = (
		SELECT
			sum(isnull(cur_val, 0))
		FROM
			@tab_stCon
		WHERE
			source IN (N'КБУ')
	) - (
		SELECT
			sum(isnull(cur_val, 0))
		FROM
			@tab_stCon
		WHERE
			source IN (N'Сайт/моб. додаток', N'УГЛ', N'Телеефір')
	),
	-- Other 
	@prevQtyOth_rs2 INT = (
		SELECT
			sum(isnull(prev_val, 0))
		FROM
			@tab_Oth
		WHERE
			source IN (N'КБУ')
	) - (
		SELECT
			sum(isnull(prev_val, 0))
		FROM
			@tab_Oth
		WHERE
			source IN (N'Сайт/моб. додаток', N'УГЛ', N'Телеефір')
	),
	@curQtyOth_rs2 INT = (
		SELECT
			sum(isnull(cur_val, 0))
		FROM
			@tab_Oth
		WHERE
			source IN (N'КБУ')
	) - (
		SELECT
			sum(isnull(cur_val, 0))
		FROM
			@tab_Oth
		WHERE
			source IN (N'Сайт/моб. додаток', N'УГЛ', N'Телеефір')
	);
BEGIN
UPDATE
	@tab_Rel
SET
	prev_val = @prevQtyRel_rs2,
	cur_val = @curQtyRel_rs2
WHERE
	source = N'Дзвінок в 1551';
UPDATE
	@tab_exPow
SET
	prev_val = @prevQtyExPow_rs2,
	cur_val = @curQtyExPow_rs2
WHERE
	source = N'Дзвінок в 1551';
UPDATE
	@tab_locMun
SET
	prev_val = @prevQtyLocMun_rs2,
	cur_val = @curQtyLocMun_rs2
WHERE
	source = N'Дзвінок в 1551';
UPDATE
	@tab_locPow
SET
	prev_val = @prevQtyLocPow_rs2,
	cur_val = @curQtyLocPow_rs2
WHERE
	source = N'Дзвінок в 1551';
UPDATE
	@tab_stCon
SET
	prev_val = @prevQtyCon_rs2,
	cur_val = @curQtyCon_rs2
WHERE
	source = N'Дзвінок в 1551';
UPDATE
	@tab_Oth
SET
	prev_val = @prevQtyOth_rs2,
	cur_val = @curQtyOth_rs2
WHERE
	source = N'Дзвінок в 1551';
END 
BEGIN
INSERT INTO
	@tab_Rel2 (source, prev_val, cur_val)
SELECT
	source,
	sum(prev_val) prev_val,
	sum(cur_val) cur_val
FROM
	@tab_Rel z
GROUP BY
	source;
INSERT INTO
	@tab_exPow2 (source, prev_val, cur_val)
SELECT
	source,
	sum(prev_val) prev_val,
	sum(cur_val) cur_val
FROM
	@tab_exPow z
GROUP BY
	source;
INSERT INTO
	@tab_locMun2 (source, prev_val, cur_val)
SELECT
	source,
	sum(prev_val) prev_val,
	sum(cur_val) cur_val
FROM
	@tab_locMun z
GROUP BY
	source;
INSERT INTO
	@tab_locPow2 (source, prev_val, cur_val)
SELECT
	source,
	sum(prev_val) prev_val,
	sum(cur_val) cur_val
FROM
	@tab_locPow z
GROUP BY
	source;
INSERT INTO
	@tab_stCon2 (source, prev_val, cur_val)
SELECT
	source,
	sum(prev_val) prev_val,
	sum(cur_val) cur_val
FROM
	@tab_stCon z
GROUP BY
	source;
INSERT INTO
	@tab_Oth2 (source, prev_val, cur_val)
SELECT
	source,
	sum(prev_val) prev_val,
	sum(cur_val) cur_val
FROM
	@tab_Oth z
GROUP BY
	source;
END -------------> Получить конечный результат <--------------
INSERT INTO
	@result
SELECT
	source_name,
	t_rel.prev_val prevRel,
	t_rel.cur_val curRel,
	t_expow.prev_val prevResidential,
	t_expow.cur_val curResidential,
	t_locmun.prev_val prevEcology,
	t_locmun.cur_val curEcology,
	t_locpow.prev_val prevLaw,
	t_locpow.cur_val curLaw,
	t_stcon.prev_val prevFamily,
	t_stcon.cur_val curFamily,
	t_oth.prev_val prevSince,
	t_oth.cur_val curSince,
	t_empl.prev_val prevEmployees,
	t_empl.cur_val curEmployees
FROM
	#sources s
	INNER JOIN @tab_Rel2 t_rel ON t_rel.[source] = s.source_name
	INNER JOIN @tab_exPow2 t_expow ON t_expow.source = s.source_name
	INNER JOIN @tab_locMun2 t_locmun ON t_locmun.source = s.source_name
	INNER JOIN @tab_locPow2 t_locpow ON t_locpow.source = s.source_name
	INNER JOIN @tab_stCon2 t_stcon ON t_stcon.source = s.source_name
	INNER JOIN @tab_Oth2 t_oth ON t_oth.source = s.source_name
	INNER JOIN @tab_Employees t_empl ON t_empl.sourse = s.source_name;
END 
-- select * FROM @result
BEGIN
UPDATE
	#sources
SET
	row# = CASE [source_name]
	WHEN N'КБУ' THEN '1.'
	WHEN N'Дзвінок в 1551' THEN '1.1'
	WHEN N'Сайт/моб. додаток' THEN '1.2'
	WHEN N'УГЛ' THEN '1.3'
	WHEN N'Телеефір' THEN '1.4'
END;
END
SELECT
	s.row#,
	CASE
		WHEN [source] = N'КБУ' THEN N'Питання, що надійшли до КБУ «Контактний центр міста Києва»'
		WHEN [source] = N'Дзвінок в 1551' THEN N'з них, через гарячу лінію 1551'
		WHEN [source] = N'Сайт/моб. додаток' THEN N'з них, через офіційний веб-портал та додатки для мобільних пристроїв'
		WHEN [source] = N'УГЛ' THEN N'з них, через ДУ «Урядовий контактний центр»'
		WHEN [source] = N'Телеефір' THEN N'з них, у рамках проекту «Прямий зв`язок з київською міською владаю»'
		ELSE '' 
	END AS [source],
	IIF(prevRel = '0', '-', prevRel) prevReligy,
	IIF(curRel = '0', '-', curRel) curReligy,
	IIF(prevExPow = '0', '-', prevExPow) prevCentralExecutePower,
	IIF(curExPow = '0', '-', curExPow) curCentralExecutePower,
	IIF(prevLocMun = '0', '-', prevLocMun) prevLocalExecutePower,
	IIF(curLocMun = '0', '-', curLocMun) curLocalExecutePower,
	IIF(prevLocPow = '0', '-', prevLocPow) prevLocalMunicipalitet,
	IIF(curLocPow = '0', '-', curLocPow) curLocalMunicipalitet,
	IIF(prevStCon = '0', '-', prevStCon) prevStateConstruction,
	IIF(curStCon = '0', '-', curStCon) curStateConstruction,
	IIF(prevOth = '0', '-', prevOth) prevOther,
	IIF(curOth = '0', '-', curOth) curOther,
	IIF(prevEmployees = '0', '-', prevEmployees) prevEmployees,
	IIF(curEmployees = '0', '-', curEmployees) curEmployees
FROM
	@result r
	INNER JOIN #sources s ON r.source = s.source_name	 
ORDER BY
	row#;