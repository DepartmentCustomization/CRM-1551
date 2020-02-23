--declare @history_id int = 275
DECLARE @history_id_old INT = (
	SELECT
		TOP 1 Id
	FROM
		[dbo].[Question_History]
	WHERE
		[Log_Date] < (
			SELECT
				Log_Date
			FROM
				[dbo].[Question_History]
			WHERE
				Id = @history_id
		)
		AND [question_id] = (
			SELECT
				[question_id]
			FROM
				[dbo].[Question_History]
			WHERE
				Id = @history_id
		)
	ORDER BY
		[Log_Date] DESC
) ;
--select @history_id, @history_id_old
IF OBJECT_ID('tempdb..#temp_OUT') IS NOT NULL
BEGIN 
DROP TABLE #temp_OUT ;
END

CREATE TABLE #temp_OUT (
[history_id] INT,
[history_type_name] NVARCHAR(100),
[history_value_old] NVARCHAR(3000),
[history_value_new] NVARCHAR(3000)
) WITH (DATA_COMPRESSION = Page) ;

INSERT INTO
	#temp_OUT([history_id], [history_type_name], [history_value_old],[history_value_new])
SELECT
	t1.Id,
	N'Тип питання' AS [history_type_name],
	qt2.[name] AS [history_value_old],
	qt1.[name] AS [history_value_new]
FROM
	[dbo].[Question_History] AS t1
	LEFT JOIN [dbo].[Question_History] AS t2 ON t2.Id = @history_id_old
	LEFT JOIN [dbo].[QuestionTypes] AS qt1 ON qt1.Id = t1.question_type_id
	LEFT JOIN [dbo].[QuestionTypes] AS qt2 ON qt2.Id = t2.question_type_id
WHERE
	t1.Id = @history_id
UNION
ALL
SELECT
	t1.Id,
	N'Об`єкт' AS [history_type_name],
	isnull([ObjectTypes2].[name] + N': ', N'') + isnull([StreetTypes2].[shortname] + ' ', N'') + isnull([Streets2].[name] + N' ', N'') + isnull([Buildings2].[name], N'') AS [history_value_old],
	isnull([ObjectTypes1].[name] + N': ', N'') + isnull([StreetTypes1].[shortname] + ' ', N'') + isnull([Streets1].[name] + N' ', N'') + isnull([Buildings1].[name], N'') AS [history_value_new]
FROM
	[dbo].[Question_History] AS t1
	LEFT JOIN [dbo].[Question_History] AS t2 ON t2.Id = @history_id_old
	LEFT JOIN [dbo].[Objects] AS [Objects1] ON [Objects1].Id = t1.[object_id]
	LEFT JOIN [dbo].[Buildings] AS [Buildings1] ON [Buildings1].Id = [Objects1].Id
	LEFT JOIN [dbo].[Streets] AS [Streets1] ON [Streets1].Id = [Buildings1].street_id
	LEFT JOIN [dbo].[StreetTypes] AS [StreetTypes1] ON [StreetTypes1].Id = [Streets1].street_type_id
	LEFT JOIN [dbo].[ObjectTypes] AS [ObjectTypes1] ON [ObjectTypes1].Id = [Objects1].object_type_id
	LEFT JOIN [dbo].[Objects] AS [Objects2] ON [Objects2].Id = t2.[object_id]
	LEFT JOIN [dbo].[Buildings] AS [Buildings2] ON [Buildings2].Id = [Objects2].Id
	LEFT JOIN [dbo].[Streets] AS [Streets2] ON [Streets2].Id = [Buildings2].street_id
	LEFT JOIN [dbo].[StreetTypes] AS [StreetTypes2] ON [StreetTypes2].Id = [Streets2].street_type_id
	LEFT JOIN [dbo].[ObjectTypes] AS [ObjectTypes2] ON [ObjectTypes2].Id = [Objects2].object_type_id
WHERE
	t1.Id = @history_id
UNION
ALL
SELECT
	t1.Id,
	N'Організація' AS [history_type_name],
	qt2.[name] AS [history_value_old],
	qt1.[name] AS [history_value_new]
FROM
	[dbo].[Question_History] AS t1
	LEFT JOIN [dbo].[Question_History] AS t2 ON t2.Id = @history_id_old
	LEFT JOIN [dbo].[Organizations] AS qt1 ON qt1.Id = t1.organization_id
	LEFT JOIN [dbo].[Organizations] AS qt2 ON qt2.Id = t2.organization_id
WHERE
	t1.Id = @history_id
UNION
ALL
SELECT
	t1.Id,
	N'Зміст' AS [history_type_name],
	t2.[question_content] AS [history_value_old],
	t1.[question_content] AS [history_value_new]
FROM
	[dbo].[Question_History] AS t1
	LEFT JOIN [dbo].[Question_History] AS t2 ON t2.Id = @history_id_old
WHERE
	t1.Id = @history_id
UNION
ALL
SELECT
	t1.Id,
	N'Виконавець' AS [history_type_name],
	IIF(
		len([Organizations2].[head_name]) > 5,
		isnull([Organizations2].[head_name], N''),
		isnull([Organizations2].[short_name], N'')
	) AS [history_value_old],
	IIF(
		len([Organizations1].[head_name]) > 5,
		isnull([Organizations1].[head_name], N''),
		isnull([Organizations1].[short_name], N'')
	) AS [history_value_new]
FROM
	[dbo].[Question_History] AS t1
	LEFT JOIN [dbo].[Question_History] AS t2 ON t2.Id = @history_id_old
	LEFT JOIN [dbo].[Assignments] AS [Assignments1] ON [Assignments1].question_id = t1.question_id
	AND [Assignments1].main_executor = 1
	LEFT JOIN [dbo].[Organizations] AS [Organizations1] ON [Organizations1].Id = [Assignments1].[executor_organization_id]
	LEFT JOIN [dbo].[Assignments] AS [Assignments2] ON [Assignments2].question_id = t2.question_id
	AND [Assignments2].main_executor = 1
	LEFT JOIN [dbo].[Organizations] AS [Organizations2] ON [Organizations2].Id = [Assignments2].[executor_organization_id]
WHERE
	t1.Id = @history_id
UNION
ALL
SELECT
	t1.Id,
	N'Дата контролю' AS [history_type_name],
	CONVERT(VARCHAR(50), t2.[control_date], 104) + N' ' + CONVERT(VARCHAR(50), t2.[control_date], 108) AS [history_value_old],
	CONVERT(VARCHAR(50), t1.[control_date], 104) + N' ' + CONVERT(VARCHAR(50), t1.[control_date], 108) AS [history_value_new]
FROM
	[dbo].[Question_History] AS t1
	LEFT JOIN [dbo].[Question_History] AS t2 ON t2.Id = @history_id_old
WHERE
	t1.Id = @history_id
UNION
ALL
SELECT
	t1.Id,
	N'Стан питання' AS [history_type_name],
	qt2.[name] AS [history_value_old],
	qt1.[name] AS [history_value_new]
FROM
	[dbo].[Question_History] AS t1
	LEFT JOIN [dbo].[Question_History] AS t2 ON t2.Id = @history_id_old
	LEFT JOIN [dbo].[QuestionStates] AS qt1 ON qt1.Id = t1.question_state_id
	LEFT JOIN [dbo].[QuestionStates] AS qt2 ON qt2.Id = t2.question_state_id
WHERE
	t1.Id = @history_id
UNION
ALL
SELECT
	t1.Id,
	N'Коментар оператора' AS [history_operator_notes_name],
	t2.operator_notes AS [history_value_old],
	t1.operator_notes AS [history_value_new]
FROM
	[dbo].[Question_History] AS t1
	LEFT JOIN [dbo].[Question_History] AS t2 ON t2.Id = @history_id_old
WHERE
	t1.Id = @history_id ;
SELECT
	*
FROM
	#temp_OUT
WHERE
	isnull([history_value_old], N'') != isnull([history_value_new], N'')
	AND #filter_columns#
	--  #sort_columns#
ORDER BY 1 
OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY