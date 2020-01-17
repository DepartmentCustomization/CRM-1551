IF object_id('tempdb..#temp_Building') IS NOT NULL DROP TABLE #temp_Building
CREATE TABLE #temp_Building(
[history_id_old] int,
[history_id_new] int
) --declare @building_id int = 69578;
INSERT INTO
  #temp_Building ([history_id_new])
SELECT
  t1.Id
FROM
  [dbo].[Building_History] AS t1
WHERE
  t1.building_id = @building_id
ORDER BY
  t1.Id
UPDATE
  #temp_Building set history_id_old = (select top 1 Id from [dbo].[Building_History] 
WHERE
  [Log_Date] < (
    SELECT
      Log_Date
    FROM
      [dbo].[Building_History]
    WHERE
      Id = #temp_Building.history_id_new) 
      AND building_id = (
        SELECT
          building_id
        FROM
          [dbo].[Building_History]
        WHERE
          Id = #temp_Building.history_id_new)
        ORDER BY
          [Log_Date] DESC
      )
    SELECT
      [Building_History].[Id] 
  -- ,[Applicant_History].[applicant_id]
,
      [Building_History].[Log_Date] AS [operation_date],
      isnull([User].LastName, N'') + N' ' + isnull([User].FirstName, N'') AS [user_id],
CASE
        WHEN [Building_History].[Log_Activity] = N'UPDATE' THEN N'Оновлення даних'
        WHEN [Building_History].[Log_Activity] = N'INSERT' THEN N'Створення будинку'
      END AS [operation_name]
    FROM
      [dbo].[Building_History]
      LEFT JOIN Buildings ON Buildings.Id = [Building_History].building_id
      LEFT JOIN [#system_database_name#].[dbo].[User] AS [User] ON [User].UserId = [Building_History].[Log_User]
    WHERE
      [Building_History].building_id = @building_id
      AND [Building_History].Id IN (
        SELECT
          t0.history_id_new
        FROM
          #temp_Building as t0
          LEFT JOIN [dbo].[Building_History] AS t1 ON t1.Id = t0.history_id_new
          LEFT JOIN [dbo].[Building_History] AS t2 ON t2.Id = t0.history_id_old
      )
      AND #filter_columns#
      -- #sort_columns#
    ORDER BY
      [Building_History].[Log_Date] DESC -- offset @pageOffsetRows rows fetch next @pageLimitRows rows only