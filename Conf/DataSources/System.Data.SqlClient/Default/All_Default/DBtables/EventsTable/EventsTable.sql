/*
DECLARE @organization_id INT = 1;
DECLARE @user_id NVARCHAR(300) = N'42613f8b-e5fc-4365-83d6-a11126dfc820'; --29796543-b903-48a6-9399-4840f6eac396 42613f8b-e5fc-4365-83d6-a11126dfc820
DECLARE @OtKuda NVARCHAR(20) = N'Городок';
DECLARE @TypeEvent NVARCHAR(20) = N'В роботі';
-- N'Усі'
*/

DECLARE @TypeEvent_table TABLE (name NVARCHAR(20));

DECLARE @OtKuda_table TABLE (name NVARCHAR(20));

IF OBJECT_ID('tempdb..#temp_orgs') IS NOT NULL 
BEGIN
	DROP TABLE #temp_orgs;
END
IF OBJECT_ID('tempdb..#temp_ob_in_org') IS NOT NULL 
BEGIN
	DROP TABLE #temp_ob_in_org;
END

if OBJECT_ID('tempdb..#temp_orgs_and_help') is not null drop table #temp_orgs_and_help
create table #temp_orgs_and_help (organization_id int)

	--begin
			declare @organization_id_temp int=
		  (select organizations_id from [dbo].[Positions] where programuser_id=@user_id)

		  insert into #temp_orgs_and_help (organization_id)
		  select organizations_id
		  from [dbo].[Positions]
		  where organizations_id=@organization_id_temp
		  and programuser_id=@user_id
		  union
		  select [Positions2].organizations_id
		  from [dbo].[Positions]
		  inner join [dbo].[PositionsHelpers] on [Positions].Id=[PositionsHelpers].helper_position_id
		  inner join [dbo].[Positions] [Positions2] on [PositionsHelpers].main_position_id=[Positions2].Id
		  where [Positions].organizations_id=@organization_id_temp and [Positions].programuser_id=@user_id
	--end

--убрать начало
-- DECLARE @OrganizationId INT = CASE
--   WHEN @organization_id IS NOT NULL THEN @organization_id
--   ELSE (
--     SELECT
--       organization_id
--     FROM
--         [dbo].[Workers]
--     WHERE
--       worker_user_id = @user_id
--   )
-- END;
--убрать конец

;WITH it AS --дети @id
(
  SELECT
    Id,
    [parent_organization_id] ParentId,
    name
  FROM
    [dbo].[Organizations] t WITH (nolock)
	inner join #temp_orgs_and_help on t.Id=#temp_orgs_and_help.organization_id
  --WHERE
  --  id = @OrganizationId
  UNION
  ALL
  SELECT
    t.Id,
    t.[parent_organization_id] ParentId,
    t.name
  FROM
    [dbo].[Organizations] t WITH (nolock)
    INNER JOIN it ON t.[parent_organization_id] = it.Id
)
SELECT
  Id INTO #temp_orgs
FROM
  it; -- pit it
  CREATE INDEX in_id ON #temp_orgs (Id); -- создание индекса
SELECT
  DISTINCT eo.object_id INTO #temp_ob_in_org
FROM
  #temp_orgs org
  INNER JOIN dbo.ExecutorInRoleForObject AS eo WITH (nolock) ON eo.executor_id = org.Id 
WHERE
  eo.object_id IS NOT NULL;
CREATE INDEX in_object_id ON #temp_ob_in_org (object_id); -- создание индекса
  --SELECT * FROM #temp_questions
IF OBJECT_ID('tempdb..#temp_ObjectsEvent') IS NOT NULL 
BEGIN
  DROP TABLE #temp_ObjectsEvent;
END
CREATE TABLE #temp_ObjectsEvent (event_id INT, object_id INT, object_name NVARCHAR(500)) WITH (DATA_COMPRESSION = PAGE);

IF OBJECT_ID('tempdb..#temp_Events_1') IS NOT NULL 
BEGIN
  DROP TABLE #temp_Events_1;
END
SELECT
  Id,
  active,
  [plan_end_date],
  gorodok_id,
  event_type_id,
  start_date,
  EventName INTO #temp_Events_1
FROM
  (
    SELECT
      [Events].Id,
      [Events].active,
      [Events].[plan_end_date],
      [Events].gorodok_id,
      [Events].event_type_id,
      [Events].start_date,
      [Event_Class].name EventName
    FROM
        [dbo].[Events] [Events] WITH (nolock)
      INNER JOIN   [dbo].[EventOrganizers] [EventOrganizers] WITH (nolock) ON [Events].Id = [EventOrganizers].event_id
      INNER JOIN #temp_orgs orgs ON [EventOrganizers].organization_id=orgs.Id
      LEFT JOIN [Event_Class] [Event_Class] WITH (nolock) ON [Events].event_class_id = [Event_Class].id
    WHERE
      CASE
        WHEN @OtKuda = N'Усі' THEN 5
        WHEN @OtKuda = N'Городок' THEN [Events].gorodok_id
        WHEN @OtKuda = N'Система'
        AND ISNULL([Events].gorodok_id, 2) <> 1 THEN 2
      END = CASE
        WHEN @OtKuda = N'Усі' THEN 5
        WHEN @OtKuda = N'Городок' THEN 1
        WHEN @OtKuda = N'Система' THEN 2
      END
      AND CASE
        WHEN @TypeEvent = N'В роботі'
        AND [Events].active = 1
        AND [Events].[plan_end_date] > getutcdate() THEN 4
        WHEN @TypeEvent = N'Прострочені'
        AND [Events].active = 1
        AND [Events].[plan_end_date] <= getutcdate() THEN 4
        WHEN @TypeEvent = N'Не активні'
        AND [Events].active = 0 THEN 4
      END = 4
    UNION
    SELECT
      [Events].Id,
      [Events].active,
      [Events].[plan_end_date],
      [Events].gorodok_id,
      [Events].event_type_id,
      [Events].start_date,
      [Event_Class].name EventName
    FROM
        [dbo].[Events] [Events] WITH (nolock)
      INNER JOIN   [dbo].[EventObjects] [EventObjects] WITH (nolock) ON [Events].Id = [EventObjects].event_id --AND [EventObjects].in_form = 1
      INNER JOIN   [dbo].[Objects] [Objects] WITH (nolock) ON [EventObjects].object_id = [Objects].Id
      INNER JOIN   [dbo].[Buildings] [Buildings] WITH (nolock) ON [Buildings].Id = [Objects].builbing_id
      INNER JOIN   [dbo].[ExecutorInRoleForObject] [ExecutorInRoleForObject] WITH (nolock) ON [ExecutorInRoleForObject].object_id = [Buildings].Id
      INNER JOIN #temp_orgs orgs ON [ExecutorInRoleForObject].executor_id=orgs.Id
      LEFT JOIN [Event_Class] [Event_Class] WITH (nolock) ON [Events].event_class_id = [Event_Class].id
    WHERE
      CASE
        WHEN @OtKuda = N'Усі' THEN 5
        WHEN @OtKuda = N'Городок' THEN [Events].gorodok_id
        WHEN @OtKuda = N'Система'
        AND ISNULL([Events].gorodok_id, 2) <> 1 THEN 2
      END = CASE
        WHEN @OtKuda = N'Усі' THEN 5
        WHEN @OtKuda = N'Городок' THEN 1
        WHEN @OtKuda = N'Система' THEN 2
      END
      AND CASE
        WHEN @TypeEvent = N'В роботі'
        AND [Events].active = 1
        AND [Events].[plan_end_date] > getutcdate() THEN 4
        WHEN @TypeEvent = N'Прострочені'
        AND [Events].active = 1
        AND [Events].[plan_end_date] <= getutcdate() THEN 4
        WHEN @TypeEvent = N'Не активні'
        AND [Events].active = 0 THEN 4
      END = 4
  ) t;

CREATE INDEX in_id ON #temp_Events_1 (Id); -- создание индекса
IF OBJECT_ID('tempdb..#temp_questions') IS NOT NULL 
BEGIN
  DROP TABLE #temp_questions;
END

SELECT
  q.Id,
  q.event_id INTO #temp_questions
FROM
  dbo.[Questions] AS q WITH (nolock) 
  INNER JOIN #temp_Events_1 AS e ON q.event_id = e.Id;

IF OBJECT_ID('tempdb..#temp_Events_gorodok') IS NOT NULL 
BEGIN
  DROP TABLE #temp_Events_gorodok;
END

SELECT
  DISTINCT gl.[claim_number] AS Id,
CASE
    WHEN gl.fact_finish_date IS NULL THEN 1
    ELSE 0
  END AS active,
  gl.[plan_finish_date] AS plan_end_date,
  1 AS [gorodok_id],
  NULL AS event_type_id,
  gl.[registration_date] AS [start_date],
  gl.claims_type AS EventName INTO #temp_Events_gorodok 
FROM
  [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_global] AS gl WITH (nolock)
  INNER JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[AllObjectInClaim] AS oc WITH (nolock) ON oc.claims_number_id = gl.claim_number
  INNER JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] gh WITH (nolock) ON gh.gorodok_houses_id = oc.object_id
  INNER JOIN #temp_ob_in_org temp_ob_in_org ON gh.[1551_houses_id]=temp_ob_in_org.object_id
WHERE
  CASE
    WHEN @OtKuda IN (N'Усі', N'Городок') THEN 1
    ELSE 2
  END = 1
  AND CASE
    WHEN @TypeEvent = N'В роботі'
    AND gl.fact_finish_date IS NULL
    AND gl.[plan_finish_date] > getutcdate() THEN 4
    WHEN @TypeEvent = N'Прострочені'
    AND gl.fact_finish_date IS NULL
    AND gl.[plan_finish_date] <= getutcdate() THEN 4
    WHEN @TypeEvent = N'Не активні'
    AND gl.fact_finish_date IS NOT NULL THEN 4
  END = 4; 

CREATE INDEX in_id ON #temp_Events_gorodok (Id); -- создание индекса
  --добавление объетков начало
INSERT INTO
  #temp_ObjectsEvent (event_id, object_id, object_name)
SELECT
  e1.Id event_id,
  [EventObjects].object_id,
  [Objects].name object_name
FROM
  #temp_Events_1 e1
  INNER JOIN [dbo].[EventObjects] [EventObjects] ON e1.Id = [EventObjects].event_id
  INNER JOIN [dbo].[Objects] [Objects] ON [EventObjects].object_id = [Objects].Id
UNION
SELECT
  e1.Id event_id,
  [ExecutorInRoleForObject].object_id,
  [Objects].name object_name
FROM
  #temp_Events_1 e1
  INNER JOIN   [dbo].[EventObjects] [EventObjects] WITH (nolock) ON e1.Id = [EventObjects].event_id --AND [EventObjects].in_form = 1
  INNER JOIN   [dbo].[Objects] [Objects] WITH (nolock) ON [EventObjects].object_id = [Objects].Id
  INNER JOIN   [dbo].[Buildings] [Buildings] WITH (nolock) ON [Buildings].Id = [Objects].builbing_id
  INNER JOIN   [dbo].[ExecutorInRoleForObject] [ExecutorInRoleForObject] WITH (nolock) ON [ExecutorInRoleForObject].object_id = [Buildings].Id
WHERE
  [ExecutorInRoleForObject].[executor_role_id] IN (1, 68)
  /*балансоутримувач, генпідрядник*/
UNION
SELECT
  teg.Id event_id,
  o.Id,
  o.name object_name
FROM
  #temp_Events_gorodok teg
  INNER JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[AllObjectInClaim] AS oc WITH (nolock) ON oc.claims_number_id = teg.id
  INNER JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] gh WITH (nolock) ON gh.gorodok_houses_id = oc.object_id
  INNER JOIN [dbo].[Objects] o ON o.builbing_id = gh.[1551_houses_id];
  --добавление объетков #temp_Events_gorodok конец
  --select * from #temp_Events_gorodok

CREATE INDEX in_event_id ON #temp_ObjectsEvent (event_id); -- создание индекса
IF OBJECT_ID('tempdb..#temp_main') IS NOT NULL 
BEGIN 
  DROP TABLE #temp_main;
END

SELECT
  event_Id,
  EventType,
  question_Id,
  gorodok_id,
  start_date,
  plan_end_date,
  EventName,
  TypeEvent,
  OtKuda INTO #temp_main
FROM
  (
    SELECT
      [Events_1].Id event_Id,
      [EventTypes].name EventType,
      Questions.Id question_Id,
      [Events_1].gorodok_id,
      [Events_1].start_date,
      [Events_1].plan_end_date,
      [Events_1].EventName,
      CASE
        WHEN [Events_1].active = 1
        AND [Events_1].[plan_end_date] > getutcdate() THEN N'В роботі'
        WHEN [Events_1].active = 1
        AND [Events_1].[plan_end_date] <= getutcdate() THEN N'Прострочені'
        WHEN [Events_1].active = 0 THEN N'Не активні'
      END TypeEvent,
      CASE
        WHEN [Events_1].gorodok_id = 1 THEN N'Городок'
        ELSE N'Система'
      END OtKuda
    FROM
      #temp_Events_1 [Events_1]
      --left join EventQuestionsTypes with (nolock) on EventQuestionsTypes.event_id = [Events_1].Id 
      --left join [EventObjects] with (nolock) on [EventObjects].event_id = [Events_1].Id
      LEFT JOIN #temp_questions AS Questions ON Questions.event_id =[Events_1].Id 
      LEFT JOIN [EventTypes] [EventTypes] ON [Events_1].event_type_id = [EventTypes].Id
    UNION
    SELECT
      [Events_gorodok].Id event_Id,
      N'...' AS EventType,
      NULL AS question_Id,
      [Events_gorodok].gorodok_id,
      [Events_gorodok].start_date,
      [Events_gorodok].plan_end_date,
      [Events_gorodok].EventName,
      CASE
        WHEN [Events_gorodok].active = 1
        AND [Events_gorodok].[plan_end_date] > getutcdate() THEN N'В роботі'
        WHEN [Events_gorodok].active = 1
        AND [Events_gorodok].[plan_end_date] <= getutcdate() THEN N'Прострочені'
        WHEN [Events_gorodok].active = 0 THEN N'Не активні'
      END TypeEvent,
      CASE
        WHEN [Events_gorodok].gorodok_id = 1 THEN N'Городок'
        ELSE N'Система'
      END OtKuda
    FROM
      #temp_Events_gorodok [Events_gorodok]
  ) t; 

CREATE INDEX in_id ON #temp_main (event_Id); -- создание индекса
SELECT
  event_Id EventId,
  OtKuda AS base,
  ISNULL(gorodok_id, 0) gorodok_id,
  EventType,
  EventName,
  stuff(
    (
      SELECT
        N', ' + ISNULL(object_name, N'')
      FROM
        #temp_ObjectsEvent 
        WHERE event_id=tm.event_Id 
        FOR XML PATH('')),1,2,N'') 
        objectName,
        start_date,
        plan_end_date,
        count(question_Id) CountQuestions
      FROM
        #temp_main tm
      --WHERE #filter_columns#
      GROUP BY
        event_Id,
        OtKuda,
        gorodok_id,
        EventType,
        EventName,
        start_date,
        plan_end_date
      ORDER BY 1 
      --OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY;