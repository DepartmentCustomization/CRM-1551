
-- DECLARE @organization_id INT =2000;
-- DECLARE @user_id NVARCHAR(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
-- DECLARE @OtKuda NVARCHAR(20)=N'Усі';
-- DECLARE @TypeEvent NVARCHAR(20)=N'Прострочені';

DECLARE @TypeEvent_table TABLE (name NVARCHAR(20));
DECLARE @OtKuda_table TABLE (name NVARCHAR(20));
DECLARE @ObjectInOrg TABLE ([object_id] INT)

IF @TypeEvent=N'Усі'
BEGIN
  INSERT INTO @TypeEvent_table(name)
    SELECT N'В роботі'
  UNION ALL
    SELECT N'Не активні'
  UNION ALL
    SELECT N'Прострочені'
END
ELSE
BEGIN
  INSERT INTO @TypeEvent_table(name)
    SELECT @TypeEvent
END


IF @OtKuda=N'Усі'
BEGIN
  INSERT INTO @OtKuda_table(name)
    SELECT N'Городок'
  UNION ALL
    SELECT N'Система'
END
ELSE
BEGIN
  INSERT INTO @OtKuda_table (name)
    SELECT @OtKuda
END


DECLARE @Organization TABLE(Id INT);

--select 8 id;
-- ЕСЛИ НУЖНО ВЫБИРАТЬ ЮЗЕРА
--declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
-- МОЖНО ПРОСТО ИД ОРГАНИЗАЦИИ ВЛЕПИТЬ

DECLARE @OrganizationId INT = 
CASE 
	WHEN @organization_id IS NOT NULL THEN @organization_id
	ELSE (SELECT Id FROM [CRM_1551_Analitics].[dbo].[Organizations] WHERE Id IN 
		      (SELECT organization_id FROM [CRM_1551_Analitics].[dbo].[Workers] WHERE worker_user_id=@user_id))
END

DECLARE @IdT TABLE (Id INT);

-- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
INSERT INTO @IdT (Id)
  SELECT Id FROM [CRM_1551_Analitics].[dbo].[Organizations]
    WHERE (Id=@OrganizationId OR [parent_organization_id]=@OrganizationId) AND Id NOT IN (SELECT Id FROM @IdT)

--  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
WHILE (SELECT count(id)
        FROM (SELECT Id FROM [CRM_1551_Analitics].[dbo].[Organizations]
          WHERE [parent_organization_id] IN (SELECT Id FROM @IdT) 
          AND Id NOT IN (SELECT Id FROM @IdT)) q) != 0
BEGIN

INSERT INTO @IdT
  SELECT Id FROM [CRM_1551_Analitics].[dbo].[Organizations]
    WHERE [parent_organization_id] IN (SELECT Id FROM @IdT)  AND Id NOT IN (SELECT Id FROM @IdT)
END

INSERT INTO @Organization (Id)
  SELECT Id FROM @IdT
-- select * from @Organization

-- for global Gorodok
INSERT INTO @ObjectInOrg  (object_id)
  SELECT
    -- isnull(eo.object_id, eo.building_id) AS obj_id
    eo.object_id AS obj_id
  FROM @Organization org
    JOIN ExecutorInRoleForObject AS eo ON eo.executor_id = org.Id
  WHERE eo.object_id IS NOT NULL
  -- WHERE isnull(eo.object_id, eo.building_id) IS NOT NULL

-- select * from @ObjectInOrg

;WITH
  [Events_1]
  AS
  (
    SELECT
        [Events].Id,
        [Events].active,
        [Events].[plan_end_date],
        isnull([Events].gorodok_id, 0) as gorodok_id,
        [Events].event_type_id,
        [Events].start_date,
        [Event_Class].name EventName
      FROM [CRM_1551_Analitics].[dbo].[Events]
        INNER JOIN [CRM_1551_Analitics].[dbo].[EventOrganizers] ON [Events].Id=[EventOrganizers].event_id
        LEFT JOIN [Event_Class] ON [Events].event_class_id=[Event_Class].id
      WHERE [EventOrganizers].organization_id IN (SELECT id
      FROM @Organization)
    UNION
      SELECT [Events].Id, [Events].active, [Events].[plan_end_date], [Events].gorodok_id, [Events].event_type_id, [Events].start_date,
        [Event_Class].name EventName
      FROM [CRM_1551_Analitics].[dbo].[Events]
        INNER JOIN [CRM_1551_Analitics].[dbo].[EventObjects] ON [Events].Id=[EventObjects].event_id
        LEFT JOIN [CRM_1551_Analitics].[dbo].[Objects] ON [EventObjects].object_id=[Objects].Id
        LEFT JOIN [CRM_1551_Analitics].[dbo].[Buildings] ON [Buildings].Id=[Objects].builbing_id
        LEFT JOIN [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject] ON [ExecutorInRoleForObject].object_id=[Buildings].Id
        LEFT JOIN [Event_Class] ON [Events].event_class_id=[Event_Class].id
      WHERE [ExecutorInRoleForObject].[executor_role_id] IN (1, 68) /*балансоутримувач, генпідрядник*/
        AND [ExecutorInRoleForObject].executor_id IN (SELECT id FROM @Organization)

  ),

  [Events_gorodok]
  AS
  (
    SELECT
      gl.[claim_number] AS Id
		,case when gl.fact_finish_date is null then 1
		    else 0 end as active  
		, gl.[plan_finish_date] AS plan_end_date
		, 1 AS [gorodok_id]
		, NULL AS event_type_id
		, gl.[registration_date] AS [start_date]
		, gl.claims_type AS EventName
    FROM [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_global] AS gl
      JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[AllObjectInClaim] AS oc ON oc.claims_number_id = gl.claim_number
	  JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] gh ON gh.gorodok_houses_id = oc.object_id
      WHERE gh.[1551_houses_id] IN (SELECT [object_id] FROM @ObjectInOrg)

      -- JOIN (SELECT * FROM [CRM_1551_GORODOK_Integrartion].[dbo].[AllObjectInClaim]
      -- WHERE object_id IN (SELECT object_id FROM @ObjectInOrg)) AS oc ON oc.claims_number_id = gl.claim_number
  ),

  -- [Events_2] as 
  -- (
  -- select 
  --[Events].Id, 
  --[Events].active, 
  --[Events].[plan_end_date], 
  --[Events].gorodok_id, 
  --[EventObjects].object_id, 
  ----[Events].question_type_id, 
  --[EventOrganizers].organization_id
  -- from [CRM_1551_Analitics].[dbo].[Events]
  -- inner join [CRM_1551_Analitics].[dbo].[EventOrganizers] on [Events].Id=[EventOrganizers].event_id
  -- left join [CRM_1551_Analitics].[dbo].[EventObjects] on [Events].Id=[EventObjects].event_id
  -- where [EventOrganizers].organization_id in (select id from @Organization)

  -- union

  -- select 
  --[Events].Id, 
  --[Events].active, 
  --[Events].[plan_end_date], 
  --[Events].gorodok_id, 
  --[Objects].Id, 
  ----[Events].question_type_id, 
  --[ExecutorInRoleForObject].executor_id
  -- from [CRM_1551_Analitics].[dbo].[Events] 
  -- inner join [CRM_1551_Analitics].[dbo].[EventObjects] on [Events].Id=[EventObjects].event_id
  -- left join [CRM_1551_Analitics].[dbo].[Objects] on [EventObjects].object_id=[Objects].Id
  -- left join [CRM_1551_Analitics].[dbo].[Buildings] on [Buildings].Id=[Objects].builbing_id
  -- left join [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject] on [ExecutorInRoleForObject].building_id=[Buildings].Id
  -- where [ExecutorInRoleForObject].[executor_role_id] in (1, 68) /*балансоутримувач, генпідрядник*/
  -- and [ExecutorInRoleForObject].executor_id in (select id from @Organization)

  -- ),

  main
  AS
  (
    SELECT
        [Events_1].Id event_Id,
        [Events_1].event_type_id,
        [EventTypes].name EventType,
        Questions.Id question_Id,
        [Events_1].start_date,
        [Events_1].plan_end_date,
        [Events_1].EventName,
        CASE WHEN [Events_1].active =1 AND [Events_1].[plan_end_date]>getutcdate() THEN N'В роботі'
            WHEN [Events_1].active =1 AND [Events_1].[plan_end_date]<=getutcdate() THEN N'Прострочені'
            WHEN [Events_1].active =0 THEN N'Не активні' END TypeEvent,
        CASE WHEN [Events_1].gorodok_id=1 THEN N'Городок' ELSE N'Система' END OtKuda
        ,isnull(gorodok_id, 0) as gorodok_id
    FROM [Events_1]
        LEFT JOIN EventQuestionsTypes ON EventQuestionsTypes.event_id = [Events_1].Id
        LEFT JOIN [EventObjects] ON [EventObjects].event_id = [Events_1].Id
    --left join Questions on Questions.question_type_id = EventQuestionsTypes.question_type_id and [Questions].[object_id] = [EventObjects].[object_id]
	left join (select 
					   --count(q.Id)
					   q.Id
					   ,q.question_type_id
					   ,q.object_id
					   ,e.id as event_id
					FROM [Events] as e
    					left join EventQuestionsTypes as eqt on eqt.event_id = e.Id 
    					left join [EventObjects] as eo on eo.event_id = e.Id
    					left join Questions as q on q.question_type_id = eqt.question_type_id and q.[object_id] = eo.[object_id]
    					left join Assignments on Assignments.Id = q.last_assignment_for_execution_id
					where  q.registration_date >= e.registration_date
					and eqt.[is_hard_connection] = 1
					AND Assignments.main_executor = 1
					AND Assignments.assignment_state_id <> 5
					and q.question_state_id <> 5
				) as Questions on Questions.event_id =[Events_1].Id and  Questions.question_type_id = EventQuestionsTypes.question_type_id and [Questions].[object_id] = [EventObjects].[object_id]
    left join [EventTypes] on [Events_1].event_type_id=[EventTypes].Id

    UNION ALL

    SELECT
        [Events_gorodok].Id event_Id,
        [Events_gorodok].event_type_id,
        '...' AS EventType,
        NULL question_Id,
        [Events_gorodok].start_date,
        [Events_gorodok].plan_end_date,
        [Events_gorodok].EventName,
        CASE WHEN [Events_gorodok].active =1 AND [Events_gorodok].[plan_end_date]>getutcdate() THEN N'В роботі'
	          WHEN [Events_gorodok].active =1 AND [Events_gorodok].[plan_end_date]<=getutcdate() THEN N'Прострочені'
	          WHEN [Events_gorodok].active =0 THEN N'Не активні' END TypeEvent,
        CASE WHEN [Events_gorodok].gorodok_id=1 THEN N'Городок' ELSE N'Система' END OtKuda
        ,gorodok_id
    FROM [Events_gorodok]
  )


SELECT
  event_Id EventId,
  OtKuda as base,
  gorodok_id,
  EventType, 
  EventName,
  start_date,
  plan_end_date,
  count(question_Id) CountQuestions
FROM main
WHERE main.TypeEvent IN (SELECT name FROM @TypeEvent_table) AND main.OtKuda IN 
                        (SELECT name FROM @OtKuda_table)
GROUP BY event_Id, EventType, EventName, start_date, plan_end_date, OtKuda,gorodok_id
-- ORDER BY  gorodok_id