-- DECLARE @org INT = 3;
-- DECLARE @dateFrom DATE = '2020-01-01';
-- DECLARE @dateTo DATE = getdate();
-- DECLARE @question_type_id INT = 1;
IF object_id('tempdb..##temp_QuestionTypes4monitoring') IS NOT NULL 
BEGIN 
DROP TABLE ##temp_QuestionTypes4monitoring ;
END CREATE TABLE ##temp_QuestionTypes4monitoring (id INT) 
WITH (DATA_COMPRESSION = PAGE);

DECLARE @sql NVARCHAR(MAX) = N'INSERT INTO ##temp_QuestionTypes4monitoring (id) select [QuestionTypes].Id from [CRM_1551_Analitics].[dbo].[QuestionTypes] where Id in (' + rtrim(
  stuff(
    (
      SELECT
        N',' + QuestionTypes
      FROM
        dbo.QuestionTypesAndParent
      WHERE
        ParentId = @question_type_id
        /*#filter_columns# ParentId*/
        FOR XML PATH('')
    ),
    1,
    1,
    N''
  )
) + N')';

EXEC sp_executesql @sql;

/* SELECT * FROM ##temp_QuestionTypes4monitoring */
/*
 if object_id('tempdb..##temp_Organizations4monitoring') is not null drop table ##temp_Organizations4monitoring
 begin
 create table ##temp_Organizations4monitoring (id int)
 end
 
 declare @sql nvarchar(max)  = N'INSERT INTO ##temp_Organizations4monitoring (id) select Organizations.Id from [CRM_1551_Analitics].[dbo].[Organizations] where Id in (' 
 + rtrim(stuff((select N','+[Organizations]
 from [dbo].[OrganizationsAndParent]
 where ParentId = @org
 for xml path('')), 1,1,N''))+N')'
 exec sp_executesql @sql
 SELECT * FROM ##temp_Organizations4monitoring
 */
IF object_id('tempdb..#temp_Organizations1') IS NOT NULL 
BEGIN DROP 
TABLE #temp_Organizations1 ;
END
 CREATE TABLE #temp_Organizations1 (
main_org_id INT,
main_org_name NVARCHAR(500),
main_org_parent_id INT,
L1_id INT,
L1_org_name NVARCHAR(500),
L2_id INT,
L2_org_name NVARCHAR(500),
L3_id INT,
L3_org_name NVARCHAR(500),
L4_id INT,
L4_org_name NVARCHAR(500),
L5_id INT,
L5_org_name NVARCHAR(500)
) WITH (DATA_COMPRESSION = PAGE);

INSERT INTO
  #temp_Organizations1 (main_org_id, main_org_name, main_org_parent_id
,
  L1_id,
  L1_org_name,
  L2_id,
  L2_org_name,
  L3_id,
  L3_org_name,
  L4_id,
  L4_org_name,
  L5_id,
  L5_org_name
)
SELECT
  main_org.id AS main_org_id,
  main_org.short_name AS main_org_name,
  main_org.parent_organization_id,
  L1.id AS L1_id,
  L1.short_name AS L1_org_name,
  L2.id AS L2_id,
  L2.short_name AS L2_org_name,
  L3.id AS L3_id,
  L3.short_name AS L3_org_name,
  L4.id AS L4_id,
  L4.short_name AS L4_org_name,
  L5.id AS L5_id,
  L5.short_name AS L5_org_name
FROM
  (
    SELECT
      id,
      short_name,
      [parent_organization_id]
    FROM
      [CRM_1551_Analitics].[dbo].[Organizations] WITH (nolock)
    WHERE
      [parent_organization_id] = @org
  ) main_org
  LEFT JOIN (
    SELECT
      id,
      short_name,
      [parent_organization_id]
    FROM
      [CRM_1551_Analitics].[dbo].[Organizations] WITH (nolock)
  ) L1 ON L1.[parent_organization_id] = main_org.id
  LEFT JOIN (
    SELECT
      id,
      short_name,
      [parent_organization_id]
    FROM
      [CRM_1551_Analitics].[dbo].[Organizations] WITH (nolock)
  ) L2 ON L2.[parent_organization_id] = L1.id
  LEFT JOIN (
    SELECT
      id,
      short_name,
      [parent_organization_id]
    FROM
      [CRM_1551_Analitics].[dbo].[Organizations] WITH (nolock)
  ) L3 ON L3.[parent_organization_id] = L2.id
  LEFT JOIN (
    SELECT
      id,
      short_name,
      [parent_organization_id]
    FROM
      [CRM_1551_Analitics].[dbo].[Organizations] WITH (nolock)
  ) L4 ON L4.[parent_organization_id] = L3.id
  LEFT JOIN (
    SELECT
      id,
      short_name,
      [parent_organization_id]
    FROM
      [CRM_1551_Analitics].[dbo].[Organizations] WITH (nolock)
  ) L5 ON L5.[parent_organization_id] = L4.id;

INSERT INTO
  #temp_Organizations1 (main_org_id, main_org_name, main_org_parent_id
,
  L1_id,
  L1_org_name,
  L2_id,
  L2_org_name,
  L3_id,
  L3_org_name,
  L4_id,
  L4_org_name,
  L5_id,
  L5_org_name
)
SELECT
  id,
  short_name,
  id,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL
FROM
  [CRM_1551_Analitics].[dbo].[Organizations] WITH (nolock)
WHERE
  id = @org;

-- SELECT * FROM #temp_Organizations1
IF object_id('tempdb..#temp_Organizations2') IS NOT NULL 
BEGIN 
DROP TABLE #temp_Organizations2 ;
END
CREATE TABLE #temp_Organizations2 (
main_org_id INT,
main_org_parent_organization_id INT,
main_org_name NVARCHAR(500),
sub_id INT,
sub_org_name NVARCHAR(500)
) WITH (DATA_COMPRESSION = PAGE);

INSERT INTO
  #temp_Organizations2 (main_org_id, main_org_parent_organization_id, main_org_name, sub_id, sub_org_name)
SELECT
  DISTINCT main_org_id,
  main_org_parent_id,
  main_org_name,
  main_org_id,
  main_org_name
FROM
  #temp_Organizations1
WHERE
  main_org_id IS NOT NULL;

INSERT INTO
  #temp_Organizations2 (main_org_id, main_org_parent_organization_id, main_org_name, sub_id, sub_org_name)
SELECT
  DISTINCT main_org_id,
  main_org_parent_id,
  main_org_name,
  L1_id,
  L1_org_name
FROM
  #temp_Organizations1
WHERE
  L1_id IS NOT NULL;

INSERT INTO
  #temp_Organizations2 (main_org_id, main_org_parent_organization_id, main_org_name, sub_id, sub_org_name)
SELECT
  DISTINCT main_org_id,
  main_org_parent_id,
  main_org_name,
  L2_id,
  L2_org_name
FROM
  #temp_Organizations1
WHERE
  L2_id IS NOT NULL;

INSERT INTO
  #temp_Organizations2 (main_org_id, main_org_parent_organization_id, main_org_name, sub_id, sub_org_name)
SELECT
  DISTINCT main_org_id,
  main_org_parent_id,
  main_org_name,
  L3_id,
  L3_org_name
FROM
  #temp_Organizations1
WHERE
  L3_id IS NOT NULL;

INSERT INTO
  #temp_Organizations2 (main_org_id, main_org_parent_organization_id, main_org_name, sub_id, sub_org_name)
SELECT
  DISTINCT main_org_id,
  main_org_parent_id,
  main_org_name,
  L4_id,
  L4_org_name
FROM
  #temp_Organizations1
WHERE
  L4_id IS NOT NULL;

INSERT INTO
  #temp_Organizations2 (main_org_id, main_org_parent_organization_id, main_org_name, sub_id, sub_org_name)
SELECT
  DISTINCT main_org_id,
  main_org_parent_id,
  main_org_name,
  L5_id,
  L5_org_name
FROM
  #temp_Organizations1
WHERE
  L5_id IS NOT NULL;

-- SELECT * FROM #temp_Organizations2
IF object_id('tempdb..#temp_Main') IS NOT NULL 
BEGIN 
DROP TABLE #temp_Main ;
END
SELECT
  [Assignments].Id,
  [Organizations].main_org_id orgId,
  [Organizations].main_org_name orgName,
  1 AllCount,
  CASE
    WHEN (first_execution_date <= execution_date) THEN 1
    ELSE 0
  END inTimeQty,
  --- Закритих вчасно
  CASE
    WHEN (first_execution_date > execution_date) THEN 1
    ELSE 0
  END outTimeQty,
  --- Закритих не вчасно
  CASE
    WHEN assignment_state_id IN (1, 2)
    AND [Assignments].[execution_date] < getutcdate() THEN 1
    ELSE 0
  END waitTimeQty,
  --- Зареєстровано та не надійшло в роботу вчасно
  CASE
    WHEN AssignmentResultsId IN (4, 7, 10)
    AND assignment_state_id = 5 THEN 1
    ELSE 0
  END doneClosedQty,
  --- Виконано та закрито
  CASE
    WHEN AssignmentResultsId IN (5, 12)
    AND assignment_state_id = 4 THEN 1
    ELSE 0
  END notDoneClosedQty,
  --- Виконано та на доопрацювання
  CASE
    WHEN AssignmentResultsId IN (4, 7, 8)
    AND assignment_state_id = 3 THEN 1
    ELSE 0
  END doneOnCheckQty,
  --- Виконано та на перевірці
  CASE
    WHEN assignment_state_id = 2 THEN 1
    ELSE 0
  END inWorkQty,
  --В роботі
  CASE
    WHEN plan_prog.plan_prog < @dateTo THEN 1
    ELSE 0
  END PlanProg,
  -- План програма
  Questions.control_date INTO #temp_Main
FROM
  [Assignments] [Assignments] WITH (nolock) --on [Assignments].executor_organization_id=[Organizations].Id
  INNER JOIN [Questions] [Questions] WITH (nolock) ON [Assignments].question_id = [Questions].Id
  INNER JOIN #temp_Organizations2 [Organizations] ON [Assignments].executor_organization_id=[Organizations].sub_id
  INNER JOIN ##temp_QuestionTypes4monitoring qt ON [Questions].question_type_id = qt.id
  LEFT JOIN (
    SELECT
      [assignment_id],
      Min([edit_date]) AS first_execution_date
    FROM
      dbo.Assignment_History Assignment_History WITH (nolock)
    WHERE
      [assignment_state_id] = 3
    GROUP BY
      [assignment_id]
  ) First_Assigment_execution ON [Assignments].id = First_Assigment_execution.[assignment_id]
  LEFT JOIN (
    SELECT
      a.id AS [assignment_id],
      ah.edit_date AS plan_prog
    FROM
      [dbo].[Assignments] a
      INNER JOIN [dbo].Questions q ON q.Id = a.question_id
      LEFT JOIN (
        SELECT
          [assignment_id],
          Max(id) AS max_history_id
        FROM
          dbo.Assignment_History Assignment_History WITH (nolock)
        WHERE
          [assignment_state_id] <> 5
        GROUP BY
          [assignment_id]
      ) s1 ON a.id = s1.assignment_id
      LEFT JOIN Assignment_History ah WITH (nolock) ON s1.max_history_id = ah.Id
    WHERE
      a.[assignment_state_id] = 5
      AND a.AssignmentResultsId = 7
      AND ah.assignment_state_id = 3
      AND ah.AssignmentResultsId = 8
      AND q.event_id IS NULL
    UNION
    ALL
    SELECT
      a.id,
      a.edit_date
    FROM
      [dbo].[Assignments] a
      INNER JOIN [dbo].Questions q ON q.Id = a.question_id
    WHERE
      [assignment_state_id] = 3
      AND [AssignmentResultsId] = 8
      AND q.event_id IS NULL
  ) plan_prog ON [Assignments].id = plan_prog.[assignment_id]
WHERE
  CONVERT(DATE, Assignments.registration_date) BETWEEN @dateFrom
  AND @dateTo IF object_id('tempdb..#temp_MainMain') IS NOT NULL BEGIN DROP TABLE #temp_MainMain ;
END
SELECT
  orgId Id,
  orgName,
  sum(AllCount) AllCount,
  sum(inTimeQty) inTimeQty,
  sum(outTimeQty) outTimeQty,
  sum(waitTimeQty) waitTimeQty,
  sum(doneClosedQty) doneClosedQty,
  sum(notDoneClosedQty) notDoneClosedQty,
  sum(doneOnCheckQty) doneOnCheckQty,
  sum(inWorkQty) inWorkQty,
  sum(PlanProg) PlanProg INTO #temp_MainMain
FROM
  #temp_Main
GROUP BY
  orgId,
  orgName;

SELECT
  *,
  CASE
    WHEN PlanProg = 0 THEN donePercent
    ELSE cast(
      (
        cast(doneClosedQty AS NUMERIC(18, 6)) - cast(PlanProg AS NUMERIC(18, 6))
      ) / (
        cast(doneClosedQty AS NUMERIC(18, 6)) + cast(notDoneClosedQty AS NUMERIC(18, 6))
      ) * 100 AS NUMERIC(36, 2)
    )
  END AS withPlanPercent
FROM
  (
    SELECT
      #temp_MainMain.Id, #temp_MainMain.Id orgId, orgName, AllCount, inTimeQty, outTimeQty, 
      waitTimeQty,
      doneClosedQty,
      doneOnCheckQty,
      inWorkQty,
      notDoneClosedQty,
      PlanProg,
      --- Вираховуємо % вчасно закритих доручень організації виконавця
      CASE
        WHEN inTimeQty != 0
        AND outTimeQty != 0
        AND waitTimeQty != 0 THEN cast(
          (
            1 - (
              cast(outTimeQty AS NUMERIC(18, 6)) + cast(waitTimeQty AS NUMERIC(18, 6))
            ) / (
              cast(inTimeQty AS NUMERIC(18, 6)) + cast(outTimeQty AS NUMERIC(18, 6)) + cast(waitTimeQty AS NUMERIC(18, 6))
            )
          ) * 100 AS NUMERIC (36, 2)
        )
        WHEN inTimeQty = 0
        AND outTimeQty != 0
        AND waitTimeQty != 0 THEN cast(
          (
            1 - (
              cast(outTimeQty AS NUMERIC(18, 6)) + cast(waitTimeQty AS NUMERIC(18, 6))
            ) / (
              cast(outTimeQty AS NUMERIC(18, 6)) + cast(waitTimeQty AS NUMERIC(18, 6))
            )
          ) * 100 AS NUMERIC (36, 2)
        )
        WHEN inTimeQty != 0
        AND outTimeQty = 0
        AND waitTimeQty != 0 THEN cast(
          (
            1 - (
              cast(outTimeQty AS NUMERIC(10, 5)) + cast(waitTimeQty AS NUMERIC(18, 6))
            ) / (
              cast(inTimeQty AS NUMERIC(18, 6)) + cast(waitTimeQty AS NUMERIC(18, 6))
            )
          ) * 100 AS NUMERIC (36, 2)
        )
        WHEN inTimeQty != 0
        AND outTimeQty != 0
        AND waitTimeQty = 0 THEN cast(
          (
            1 - (
              cast(outTimeQty AS NUMERIC(18, 6)) + cast(waitTimeQty AS NUMERIC(18, 6))
            ) / (
              cast(inTimeQty AS NUMERIC(18, 6)) + cast(outTimeQty AS NUMERIC(18, 6))
            )
          ) * 100 AS NUMERIC (36, 2)
        )
        WHEN inTimeQty != 0
        AND outTimeQty = 0
        AND waitTimeQty = 0 THEN cast(
          (1 - (0 / (cast(inTimeQty AS NUMERIC(18, 6))))) * 100 AS NUMERIC (36, 2)
        )
        ELSE 0
      END AS inTimePercent,
      CASE
        WHEN doneClosedQty != 0
        AND notDoneClosedQty != 0 THEN cast(
          (
            cast(DoneClosedQty AS NUMERIC(18, 6)) / (
              cast(doneClosedQty AS NUMERIC(18, 6)) + cast(notDoneClosedQty AS NUMERIC(18, 6))
            )
          ) * 100 AS NUMERIC (36, 2)
        )
        WHEN doneClosedQty != 0
        AND notDoneClosedQty = 0 THEN cast(
          (
            cast(doneClosedQty AS NUMERIC(18, 6)) / (cast(doneClosedQty AS NUMERIC(18, 6)))
          ) * 100 AS NUMERIC (36, 2)
        )
        ELSE 0
      END AS donePercent
    FROM
      #temp_MainMain 
  ) z
ORDER BY
  AllCount DESC;