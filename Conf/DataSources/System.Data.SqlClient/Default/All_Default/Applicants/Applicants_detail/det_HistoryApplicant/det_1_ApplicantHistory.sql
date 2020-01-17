IF object_id('tempdb..#temp_Applicant') IS NOT NULL DROP TABLE #temp_Applicant
CREATE TABLE #temp_Applicant(
[history_id_old] int,
[history_id_new] int
) 
--declare @applicant_id int = 1494317;
INSERT INTO
  #temp_Applicant ([history_id_new])
SELECT
  t1.Id
FROM
  [dbo].[Applicant_History] AS t1
WHERE
  t1.applicant_id = @applicant_id
ORDER BY
  t1.Id
UPDATE
  #temp_Applicant set history_id_old = (select top 1 Id from [dbo].[Applicant_History] 
WHERE
  [Log_Date] < (
    SELECT
      Log_Date
    FROM
      [dbo].[Applicant_History]
    WHERE
      Id = #temp_Applicant.history_id_new) 
      AND [applicant_id] = (
        SELECT
          [applicant_id]
        FROM
          [dbo].[Applicant_History]
        WHERE
          Id = #temp_Applicant.history_id_new)
        ORDER BY
          [Log_Date] DESC
      )
    SELECT
      [Applicant_History].[Id] --   ,[Applicant_History].[applicant_id]
,
      [Applicant_History].[Log_Date] AS [operation_date],
      isnull([User].LastName, N'') + N' ' + isnull([User].FirstName, N'') AS [user_id],
CASE
        WHEN [Applicant_History].[Log_Activity] = N'UPDATE' THEN N'Оновлення даних'
        WHEN [Applicant_History].[Log_Activity] = N'INSERT' THEN N'Створення заявника'
      END AS [operation_name]
    FROM
      [dbo].[Applicant_History]
      LEFT JOIN Applicants ON Applicants.Id = [Applicant_History].applicant_id
      LEFT JOIN [#system_database_name#].[dbo].[User] AS [User] ON [User].UserId = [Applicant_History].[Log_User]
    WHERE
      [Applicant_History].[applicant_id] = @applicant_id
      AND [Applicant_History].Id IN (
        SELECT
          t0.history_id_new
        FROM
          #temp_Applicant as t0
          LEFT JOIN [dbo].[Applicant_History] AS t1 ON t1.Id = t0.history_id_new
          LEFT JOIN [dbo].[Applicant_History] AS t2 ON t2.Id = t0.history_id_old
      )
      AND #filter_columns#
      -- #sort_columns#
    ORDER BY
      [Applicant_History].[Log_Date] DESC OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY