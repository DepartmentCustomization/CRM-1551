  --  DECLARE @Id INT = 2974375;

DECLARE @Archive NVARCHAR(400) = '['+(SELECT TOP 1 [IP]+'].['+[DatabaseName]+'].' FROM [dbo].[SetingConnetDatabase] WHERE Code = N'Archive');

DECLARE @IsHere BIT = IIF(
   (
      SELECT
         COUNT(1)
      FROM
         dbo.Assignments
      WHERE
        Id = @Id
   ) = 0,
   0,
   1
);

IF(@IsHere = 1)
BEGIN
	SET @Archive = SPACE(1);
END
DECLARE @Query NVARCHAR(MAX) = 
N'IF object_id(''tempdb..#temp_OUT'') IS NOT NULL 
BEGIN
DROP TABLE #temp_OUT;
END

CREATE TABLE #temp_OUT(
[history_id_old] INT,
[history_id_new] INT
) WITH (DATA_COMPRESSION = PAGE);

INSERT INTO
 #temp_OUT ([history_id_new])
SELECT
  t1.Id
FROM
  '+@Archive+N'[dbo].[Assignment_History] AS t1
WHERE
  t1.assignment_id = @Id
ORDER BY
  t1.Id ;

UPDATE
  #temp_OUT SET history_id_old = (SELECT TOP 1 Id FROM '+@Archive+N'[dbo].[Assignment_History] 
WHERE
  [Log_Date] < (
    SELECT
      Log_Date
    FROM
      '+@Archive+N'[dbo].[Assignment_History]
    WHERE
      Id = #temp_OUT.history_id_new) 
      AND [assignment_id] = (
        SELECT
          [assignment_id]
        FROM
          '+@Archive+N'[dbo].[Assignment_History]
        WHERE
          Id = #temp_OUT.history_id_new)
        ORDER BY
          [Log_Date] DESC
      ) ;

    SELECT
      [Assignment_History].[Id],
      [Assignment_History].[Log_Date] AS [operation_date],
      isnull([User].LastName, N'''') + N'' '' + isnull([User].FirstName, N'''') AS [user_id],
CASE
        WHEN [Assignment_History].[Log_Activity] = N''UPDATE'' THEN N''Зміни в дорученні''
        WHEN [Assignment_History].[Log_Activity] = N''INSERT'' THEN N''Створення доручення''
        ELSE N''Зміни в дорученні''
      END AS [operation_name]
    FROM
      '+@Archive+N'[dbo].[Assignment_History]
      LEFT JOIN '+@Archive+N'[dbo].Assignments ON Assignments.Id = [Assignment_History].assignment_id
      LEFT JOIN [#system_database_name#].[dbo].[User] AS [User] ON [User].UserId = [Assignment_History].[Log_User]
    WHERE
      [Assignment_History].[assignment_id] = @Id
      AND [Assignment_History].Id IN (
        SELECT
          t0.history_id_new
        FROM
          #temp_OUT AS t0
          LEFT JOIN '+@Archive+N'[dbo].[Assignment_History] AS t1 ON t1.Id = t0.history_id_new
          LEFT JOIN '+@Archive+N'[dbo].[Assignment_History] AS t2 ON t2.Id = t0.history_id_old
          LEFT JOIN [dbo].[Organizations] AS [Organizations1] ON [Organizations1].Id = t1.[executor_organization_id]
          LEFT JOIN [dbo].[Organizations] AS [Organizations2] ON [Organizations2].Id = t2.[executor_organization_id]
        WHERE
          t1.assignment_state_id != t2.assignment_state_id
          OR t1.transfer_date != t2.transfer_date
          OR IIF(
            len([Organizations2].[head_name]) > 5,
            isnull([Organizations2].[head_name], N''''),
            isnull([Organizations2].[short_name], N'''')
          ) ! = IIF(
            len([Organizations1].[head_name]) > 5,
            isnull([Organizations1].[head_name], N''''),
            isnull([Organizations1].[short_name], N'''')
          )
          OR t1.main_executor != t2.main_executor
          OR t1.AssignmentResultsId != t2.AssignmentResultsId
          OR t1.short_answer != t2.short_answer
          OR t1.AssignmentResolutionsId != t2.AssignmentResolutionsId
      )
     AND #filter_columns#
    ORDER BY
      [Assignment_History].[Log_Date] DESC 
    OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY
  ; ';

  EXEC sp_executesql @Query, N'@Id INT, @pageOffsetRows BIGINT, @pageLimitRows BIGINT', 
                              @Id = @Id,
                              @pageOffsetRows = @pageOffsetRows,
                              @pageLimitRows = @pageLimitRows;