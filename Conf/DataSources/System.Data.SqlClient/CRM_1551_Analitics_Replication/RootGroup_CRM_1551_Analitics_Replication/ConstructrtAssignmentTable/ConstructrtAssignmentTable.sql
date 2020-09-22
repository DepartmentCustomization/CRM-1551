    --DECLARE @RegistrationDateFrom DATETIME = '2020-02-01 00:00';
    --DECLARE @RegistrationDateTo DATETIME = '2020-02-19 00:00';
    --DECLARE @OrganizationExecId INT = 3;
    --DECLARE @OrganizationExecGroupId INT = NULL;
    --DECLARE @ReceiptSourcesId INT = NULL;
    --DECLARE @QuestionGroupId INT = NULL;


 SET @RegistrationDateFrom = Dateadd(hh, Datediff(hh, Getutcdate(), Getdate()), @RegistrationDateFrom);
 SET @RegistrationDateTo = Dateadd(hh, Datediff(hh, Getutcdate(), Getdate()), @RegistrationDateTo);

IF object_id('tempdb..#temp_OUT') IS NOT NULL 
BEGIN
DROP TABLE #temp_OUT;
END
CREATE TABLE #temp_OUT(OrgId INT) 
WITH (DATA_COMPRESSION = PAGE);

IF @OrganizationExecId IS NOT NULL
BEGIN;

WITH OrganizationsH (ParentId, Id, [Name], LEVEL, Label, Label2) AS (
  SELECT
    parent_organization_id AS ParentId,
    Id,
    short_name AS [Name],
    0,
    CAST(rtrim(Id) + '/' AS NVARCHAR(MAX)) AS Label,
    CAST((short_name) + N' / ' AS NVARCHAR(MAX)) AS Label2
  FROM
    [dbo].[Organizations] with (nolock)
  WHERE
    Id = @OrganizationExecId
  UNION
  ALL
  SELECT
    o.parent_organization_id AS ParentId,
    o.Id,
    o.short_name AS [Name],
    LEVEL + 1,
    CAST(
      rtrim(h.Label) + rtrim(o.Id) + '/' AS NVARCHAR(MAX)
    ) AS Label,
    CAST(
      (h.Label2) + (o.short_name) + ' / ' AS NVARCHAR(MAX)
    ) AS Label2
  FROM
    [dbo].[Organizations] o with (nolock)
    JOIN OrganizationsH h ON o.parent_organization_id = h.Id
)
INSERT INTO
  #temp_OUT (OrgId)
SELECT
  Id
FROM
  OrganizationsH;
END 
IF @OrganizationExecGroupId IS NOT NULL 
BEGIN
INSERT INTO
  #temp_OUT (OrgId)
SELECT
  organization_id
FROM
  [dbo].[OGroupIncludeOrganizations] with (nolock)
WHERE
  organization_group_id = @OrganizationExecGroupId;
END 
IF @OrganizationExecGroupId IS NOT NULL
AND @OrganizationExecId IS NOT NULL 
BEGIN
DELETE FROM
  #temp_OUT;
END 
IF @OrganizationExecGroupId IS NULL
AND @OrganizationExecId IS NULL
BEGIN
INSERT INTO
  #temp_OUT (OrgId)
SELECT
  Id
FROM
  [dbo].[Organizations] with (nolock);
END 
IF object_id('tempdb..#temp_OUT_QuestionGroup') IS NOT NULL 
BEGIN
DROP TABLE #temp_OUT_QuestionGroup;
END
CREATE TABLE #temp_OUT_QuestionGroup(QueTypeId INT) 
WITH (DATA_COMPRESSION = PAGE);
IF @QuestionGroupId IS NOT NULL 
BEGIN
INSERT INTO
  #temp_OUT_QuestionGroup (QueTypeId)
SELECT
  type_question_id
FROM
  dbo.[QGroupIncludeQTypes] with (nolock) 
WHERE
  group_question_id = @QuestionGroupId;
END
ELSE BEGIN
INSERT INTO
  #temp_OUT_QuestionGroup (QueTypeId)
SELECT
  Id
FROM
  dbo.[QuestionTypes] with (nolock);
END 

DECLARE @targettimezone AS sysname = 'E. Europe Standard Time';
SELECT
  Ass.Id AS AssignmentId,
  CONVERT(VARCHAR(16),dateadd(MINUTE,datepart(tz, [Ass].registration_date 
  AT TIME ZONE @targettimezone), [Ass].registration_date), 120)
  AS Registration_date,

  CONVERT(VARCHAR(16),dateadd(MINUTE,datepart(tz, [Vykon].Log_Date
  AT TIME ZONE @targettimezone), [Vykon].Log_Date), 120) 
  AS Vykon_date,

  CONVERT(VARCHAR(16),dateadd(MINUTE,datepart(tz, [Closed].Log_Date
  AT TIME ZONE @targettimezone), [Closed].Log_Date), 120)  
  AS Close_date,
  [AssState].[name] [AssignmentState],
  1 Count_,
  CASE
    WHEN [Vykon].Log_Date > [Que].control_date THEN 1
    ELSE 0
  END Сount_prostr,
  [Organizations1].[Id] AS OrgExecutId,
  [QuesStates].[name] AS [QuestionState],
  [Organizations1].[Name] AS OrgExecutName,
  [Organizations1].[Level] AS LevelToOrgatization,
  [Organizations1].[OrgName_Level1] Orgatization_Level_1,
  [Organizations1].[OrgName_Level2] Orgatization_Level_2,
  [Organizations1].[OrgName_Level3] Orgatization_Level_3,
  [Organizations1].[OrgName_Level4] Orgatization_Level_4,
  [Organizations1].[LabelName] AS OrgExecutLabelName,
  [Organizations1].[LabelName2] AS OrgExecutLabelName2,
  stuff(
    (
      SELECT
        N',' + [OrganizationGroups].[name]
      FROM
        dbo.[OGroupIncludeOrganizations]
        LEFT JOIN dbo.[OrganizationGroups] ON [OGroupIncludeOrganizations].organization_group_id = [OrganizationGroups].Id
      WHERE
        dbo.[OGroupIncludeOrganizations].organization_id = [Ass].executor_organization_id FOR XML PATH('')
    ),
    1,
    1,
    N''
  ) AS [GroupOrganisations],
  stuff(
    (
      SELECT
        N',' + [QuestionGroups].[name]
      FROM
        dbo.[QGroupIncludeQTypes] 
        LEFT JOIN dbo.[QuestionGroups] ON [QGroupIncludeQTypes].[group_question_id] = [QuestionGroups].Id
        LEFT JOIN dbo.[QuestionTypes] AS [QTypes] ON [QGroupIncludeQTypes].type_question_id = [QTypes].Id 
      WHERE
        dbo.[QGroupIncludeQTypes].[type_question_id] = [QueTypes].Id FOR XML PATH('')
    ),
    1,
    1,
    N''
  ) AS [GroupQuestionTypes],
  [ReceiptSources].name [ReceiptSources],
  [QueTypes].[Id] AS [QuestionTypeId],
  QueTypes.[name] AS [QuestionTypeName],
  CASE
    WHEN [AssState].[name] = N'Зареєстровано' THEN 1
    ELSE 0
  END AS stateRegistered,
  CASE
    WHEN [AssState].[name] = N'В роботі' THEN 1
    ELSE 0
  END AS stateInWork,
  CASE
    WHEN [AssState].[name] = N'На перевірці' THEN 1
    ELSE 0
  END AS stateOnCheck,
  CASE
    WHEN [AssState].[name] = N'Не виконано' THEN 1
    ELSE 0
  END AS stateOnRefinement,
  CASE
    WHEN [AssState].[name] = N'Закрито' THEN 1
    ELSE 0
  END AS stateClose,
  [Obj].[name] AS objectName,
  isnull([Resolution].[name], N'Невідомо') AS resolution,
  isnull([Result].[name], N'Невідомо') AS result,
  [Que].question_content,
  [Que].[registration_number]
FROM
 dbo.[Assignments] AS [Ass] with (nolock)   
  INNER JOIN dbo.[Questions] AS [Que] with (nolock) ON [Que].Id = [Ass].question_id
  LEFT JOIN dbo.[QuestionTypes] AS [QueTypes] with (nolock) ON [Que].question_type_id = [QueTypes].Id
  LEFT JOIN dbo.[QuestionStates] AS [QuesStates] with (nolock) ON [QuesStates].Id = [Que].question_state_id
  LEFT JOIN dbo.[AssignmentStates] AS [AssState] with (nolock) ON Ass.assignment_state_id = [AssState].Id
  LEFT JOIN dbo.[Appeals] with (nolock) ON [Que].appeal_id = [Appeals].Id
  LEFT JOIN dbo.[ReceiptSources] with (nolock) ON [Appeals].receipt_source_id = [ReceiptSources].Id

  LEFT JOIN dbo.[Objects] AS [Obj] with (nolock) ON [Que].[object_id] = [Obj].Id
  LEFT JOIN dbo.[AssignmentResolutions] AS [Resolution] with (nolock) ON [Resolution].Id = [Ass].AssignmentResolutionsId
  LEFT JOIN dbo.[AssignmentResults] AS [Result] with (nolock) ON [Result].Id = [Ass].AssignmentResultsId
  LEFT JOIN (
    SELECT
      [Id],
      [ParentId],
      [Name],
      [Level],
      [LabelCode],
      [LabelName],
      [LabelName2],
      [Label_Level1],
      [Label_Level2],
      [Label_Level3],
      [Label_Level4],
      [OrgName_Level1],
      [OrgName_Level2],
      [OrgName_Level3],
      [OrgName_Level4]
    FROM
      [dbo].[ReportConctructor_Organizations]
    WHERE
      Id IN (
        SELECT
          OrgId
        FROM
          #temp_OUT)
      ) [Organizations1] ON [Ass].executor_organization_id = [Organizations1].Id
      LEFT JOIN (
        SELECT
          assignment_id,
          Log_Date
        FROM
          (
            SELECT
              [Assignment_History].assignment_id,
              ROW_NUMBER() OVER (
                PARTITION BY assignment_id
                ORDER BY
                  Id ASC
              ) n,
              Log_Date
            FROM
              dbo.[Assignment_History]  with (nolock)
            WHERE
              assignment_state_id = 3
              /*На перевірці*/
          ) t
        WHERE
          n = 1
      ) Vykon ON [Ass].Id = Vykon.assignment_id
      LEFT JOIN (
        SELECT
          assignment_id,
          Log_Date
        FROM
          (
            SELECT
              [Assignment_History].assignment_id,
              ROW_NUMBER() OVER (
                PARTITION BY assignment_id
                ORDER BY
                  Id ASC
              ) n,
              Log_Date
            FROM
              dbo.[Assignment_History] with (nolock)
            WHERE
              assignment_state_id = 5 
              /*Закрито*/
          ) t
        WHERE
          n = 1
      ) Closed ON [Ass].Id = Closed.assignment_id
    WHERE 
      DATEADD(hh, DATEDIFF(hh, GETUTCDATE(), GETDATE()), [Ass].Registration_date ) 
      BETWEEN @RegistrationDateFrom
      AND @RegistrationDateTo
      AND (
        [Ass].[executor_organization_id] IN (
          SELECT
            OrgId
          FROM
            #temp_OUT))
            AND (
              [ReceiptSources].[Id] = @ReceiptSourcesId
              OR @ReceiptSourcesId IS NULL
            )
            AND [Que].question_type_id IN (
              SELECT
                QueTypeId
              FROM
                #temp_OUT_QuestionGroup)
             AND  #filter_columns#
			 option (OPTIMIZE FOR UNKNOWN)
			  ;