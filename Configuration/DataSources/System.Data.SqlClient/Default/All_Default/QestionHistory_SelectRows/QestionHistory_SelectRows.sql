IF object_id('tempdb..#temp_OUT') IS NOT NULL DROP TABLE #temp_OUT
CREATE TABLE #temp_OUT(
[history_id_old] int,
[history_id_new] int
)
INSERT INTO
  #temp_OUT ([history_id_new])
SELECT
  t1.Id
FROM
  [dbo].[Question_History] AS t1
WHERE
  t1.question_id = @question_id
ORDER BY
  t1.Id
UPDATE
  #temp_OUT set history_id_old = (select top 1 Id from [dbo].[Question_History] 
WHERE
  [Log_Date] < (
    SELECT
      Log_Date
    FROM
      [dbo].[Question_History]
    WHERE
      Id = #temp_OUT.history_id_new) 
      AND [question_id] = (
        SELECT
          [question_id]
        FROM
          [dbo].[Question_History]
        WHERE
          Id = #temp_OUT.history_id_new)
        ORDER BY
          [Log_Date] DESC
      )
    SELECT
      [Question_History].[Id],
      [Question_History].[Log_Date],
      isnull(LastName, N'') + N' ' + isnull([FirstName], N'') + N' ' + isnull([Patronymic], N'') AS [Log_User_FIO],
CASE
        WHEN [Question_History].[Log_Activity] = N'INSERT' THEN N'Створення'
        WHEN [Question_History].[Log_Activity] = N'UPDATE' THEN N'Редагування'
        ELSE [Question_History].[Log_Activity]
      END AS [Log_Activity]
    FROM
      [dbo].[Question_History]
      LEFT JOIN [#system_database_name#].[dbo].[User] ON [User].UserId = [Question_History].[Log_User]
    WHERE
      [Question_History].question_id = @question_id
      AND [Question_History].Id IN (
        SELECT
          t0.history_id_new
        FROM
          #temp_OUT as t0
          LEFT JOIN [dbo].[Question_History] AS t1 ON t1.Id = t0.history_id_new
          LEFT JOIN [dbo].[Question_History] AS t2 ON t2.Id = t0.history_id_old
          LEFT JOIN [dbo].[Assignments] AS [Assignments1] ON [Assignments1].question_id = t1.question_id
          AND [Assignments1].main_executor = 1
          LEFT JOIN [dbo].[Organizations] AS [Organizations1] ON [Organizations1].Id = [Assignments1].[executor_organization_id]
          LEFT JOIN [dbo].[Assignments] AS [Assignments2] ON [Assignments2].question_id = t2.question_id
          AND [Assignments2].main_executor = 1
          LEFT JOIN [dbo].[Organizations] AS [Organizations2] ON [Organizations2].Id = [Assignments2].[executor_organization_id]
        WHERE
          t1.question_type_id != t2.question_type_id
          OR t1.[object_id] != t2.[object_id]
          OR t1.organization_id != t2.organization_id
          OR t1.question_content != t2.question_content
          OR t1.control_date != t2.control_date
          OR t1.question_state_id != t2.question_state_id
          OR t1.operator_notes != isnull(t2.operator_notes, '')
          OR IIF(
            len([Organizations2].[head_name]) > 5,
            isnull([Organizations2].[head_name], N''),
            isnull([Organizations2].[short_name], N'')
          ) ! = IIF(
            len([Organizations1].[head_name]) > 5,
            isnull([Organizations1].[head_name], N''),
            isnull([Organizations1].[short_name], N'')
          )
      )
      AND #filter_columns#
      -- #sort_columns#
    ORDER BY
      [Question_History].[Log_Date] DESC OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY