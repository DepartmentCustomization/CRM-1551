
/*
DECLARE @organization_id INT =1774--1762;
DECLARE @user_id NVARCHAR(300)=N'  '--N'  ';
*/

    IF EXISTS

    (SELECT p.*
  FROM [dbo].[Positions] p
  LEFT JOIN [dbo].[PositionsHelpers] pm ON p.Id=pm.main_position_id
  LEFT JOIN [dbo].[PositionsHelpers] ph on p.Id=ph.helper_position_id
  WHERE p.[programuser_id]=@user_id
  AND (pm.main_position_id IS NOT NULL OR ph.helper_position_id IS NOT NULL))
	BEGIN

   /*
	IF object_id('tempdb..#user_organizations') IS NOT NULL DROP TABLE #user_organizations

  SELECT r.name role_name, p.Id position_id, p.organizations_id, p.programuser_id
  INTO #user_organizations
  FROM [dbo].[Positions] p
  LEFT JOIN [dbo].[Roles] r ON p.role_id=r.Id
  WHERE p.programuser_id=@user_id*/
  

  --

  	--пункт 5 сортировка
	if object_id ('tempbd..#temp_sort') is not null drop table #temp_sort

  select position_id, min(sort) sort
  into #temp_sort
  from (
  --своя посада
  SELECT p.Id position_id, 1 sort 
  FROM [dbo].[Positions] p
  where programuser_id=@user_id
  union 
  --посада директора її організації
  select ph.main_position_id, 2 sort
  from [dbo].[Positions] p
  inner join [dbo].[PositionsHelpers] ph on p.Id=ph.helper_position_id
  where p.programuser_id=@user_id
  union
  --посади в її організації
  select po.Id, 3 sort
  from [dbo].[Positions] p
  inner join [dbo].[Positions] po on p.organizations_id=po.organizations_id
  where p.programuser_id=@user_id) t
  group by position_id


  -- на ДБ виводити доручення всіх посад, до яких відпоситься користувач, що зайшов в систему
	IF OBJECT_ID('tempdb..#temp_positions_user') IS NOT NULL
			BEGIN
				DROP TABLE #temp_positions_user;
			END;



  --пункт4 подивився до яких посад має відношення користувач
  /* версия1 начало
  SELECT *
  INTO #temp_positions_user
  FROM
  (SELECT p.Id, p.position, organizations_id, r.name role_name
  FROM [dbo].[Positions] p
  LEFT JOIN [dbo].[Roles] r ON p.role_id=r.Id 
  WHERE p.[programuser_id]=@user_id
  UNION 
  SELECT p2.Id, p2.position, p2.organizations_id, r.name role_name
  FROM [dbo].[Positions] p
  INNER JOIN [dbo].[PositionsHelpers] ph ON p.Id=ph.main_position_id
  INNER JOIN [dbo].[Positions] p2 ON ph.helper_position_id=p2.Id
  LEFT JOIN [dbo].[Roles] r ON p2.role_id=r.Id
  WHERE p.[programuser_id]=@user_id
  UNION 
  SELECT p2.Id, p2.position, p2.organizations_id, r.name role_name
  FROM [dbo].[Positions] p
  INNER JOIN [dbo].[PositionsHelpers] ph ON p.Id=ph.helper_position_id
  INNER JOIN [dbo].[Positions] p2 ON ph.main_position_id=p2.Id
  LEFT JOIN [dbo].[Roles] r ON p2.role_id=r.Id
  WHERE p.[programuser_id]=@user_id) t
 версия 1 конец*/
 -- в2

--   select po.Id, po.position, po.organizations_id, r.name role_name
--   INTO #temp_positions_user
--   from [dbo].[Positions] po 
--   INNER JOIN
--   (
--   --посади, які зв.язані з тим, хто зайшов
--   SELECT p.Id position_id
--   FROM [dbo].[Positions] p
--   WHERE p.[programuser_id]=@user_id
--   UNION 
--   SELECT p2.Id position_id
--   FROM [dbo].[Positions] p
--   INNER JOIN [dbo].[PositionsHelpers] ph ON p.Id=ph.main_position_id
--   INNER JOIN [dbo].[Positions] p2 ON ph.helper_position_id=p2.Id
--   WHERE p.[programuser_id]=@user_id
--   UNION 
--   SELECT p2.Id position_id
--   FROM [dbo].[Positions] p
--   INNER JOIN [dbo].[PositionsHelpers] ph ON p.Id=ph.helper_position_id
--   INNER JOIN [dbo].[Positions] p2 ON ph.main_position_id=p2.Id
--   WHERE p.[programuser_id]=@user_id) pp ON po.Id=pp.position_id
--   LEFT JOIN [Roles] r ON po.role_id=r.Id
-- select p.id, p.position, p.organizations_id, r.name role_name
-- INTO #temp_positions_user
-- from [dbo].[Positions] p
-- left join [dbo].[Roles] r on p.role_id=r.id
-- where organizations_id IN
-- (
-- select organizations_id
-- from [dbo].[Positions]
-- where programuser_id=@user_id)
select p.id, p.position, p.organizations_id, r.name role_name
INTO #temp_positions_user
from [dbo].[Positions] p
left join [dbo].[Roles] r on p.role_id=r.id
where organizations_id IN
(
select p.organizations_id
from [dbo].[Positions] p
where p.programuser_id=@user_id
union
select pm.organizations_id
from [dbo].[PositionsHelpers] ph
inner join [dbo].[Positions] pm on ph.main_position_id=pm.id
where ph.helper_position_id in
(select p.Id
from [dbo].[Positions] p
where p.programuser_id=@user_id)
) 
  --select * from #temp_positions_user
	--end
   if object_id('tempdb..#organizations_user') is not null drop table #organizations_user

   select distinct organizations_id
   into #organizations_user
   from #temp_positions_user

   if object_id('tempdb..#position_user') is not null drop table #position_user
   select distinct id position_id
   into #position_user
   from #temp_positions_user
  
  --select * from #position_organization
  --end

  if object_id('tempdb..#temp_assingments') is not null drop table #temp_assingments

  SELECT a.*
  INTO #temp_assingments
  FROM [dbo].[Assignments] a
  INNER JOIN #position_user pu ON a.executor_person_id=pu.position_id
  INNER JOIN #organizations_user ou ON a.executor_organization_id=ou.organizations_id
  WHERE a.executor_person_id=@organization_id



--SELECT * FROM #temp_assingments




------------для плана/програми---
IF OBJECT_ID('tempdb..#temp_main_end') IS NOT NULL
			BEGIN
				DROP TABLE #temp_main_end;
			END;
			SELECT
				Id INTO #temp_main_end
			FROM #temp_assingments [Assignments] WITH (NOLOCK)
			WHERE assignment_state_id = 5
			AND AssignmentResultsId = 7
			--AND executor_organization_id IN (SELECT organizations_id FROM #user_organizations);


			IF OBJECT_ID('tempdb..#temp_TempAssHistory') IS NOT NULL
			BEGIN
				DROP TABLE #temp_TempAssHistory;
			END;
			SELECT
				[Assignment_History].Id id,
				[Assignment_History].assignment_id,
				[Assignment_History].AssignmentResultsId,
				[Assignment_History].assignment_state_id
			into #temp_TempAssHistory
			FROM [dbo].[Assignment_History] WITH (NOLOCK)
			INNER JOIN #temp_main_end tme ON [Assignment_History].assignment_id=tme.Id
			--WHERE [Assignment_History].assignment_id in (select Id FROM #temp_main_end);


			IF OBJECT_ID('tempdb..#temp_end_state') IS NOT NULL
			BEGIN
				DROP TABLE #temp_end_state;
			END;
			SELECT
				[Assignment_History].Id
			   ,[Assignment_History].assignment_id
			   ,[Assignment_History].assignment_state_id INTO #temp_end_state
			FROM 
			#temp_TempAssHistory [Assignment_History] WITH (NOLOCK)
			INNER JOIN (SELECT MAX(id) mid FROM #temp_TempAssHistory WHERE assignment_state_id <> 5 GROUP BY assignment_id) temp_h ON [Assignment_History].id=temp_h.mid
			INNER JOIN [dbo].[AssignmentStates]
				ON [Assignment_History].assignment_state_id = [AssignmentStates].Id
			WHERE [AssignmentStates].code = N'OnCheck'
			AND [AssignmentStates].code <> N'Closed'
			--AND [Assignment_History].Id IN (SELECT MAX(id) FROM #temp_TempAssHistory WHERE assignment_state_id <> 5 GROUP BY assignment_id);

		--select * from #temp_end_state

			IF OBJECT_ID('tempdb..#temp_end_result') IS NOT NULL
			BEGIN
				DROP TABLE #temp_end_result;
			END;
			SELECT
				[Assignment_History].Id
			   ,[Assignment_History].assignment_id
			   ,[Assignment_History].AssignmentResultsId INTO #temp_end_result
			FROM #temp_TempAssHistory [Assignment_History] WITH (NOLOCK)
			INNER JOIN (SELECT MAX(id) mid FROM #temp_TempAssHistory WHERE AssignmentResultsId <> 7 GROUP BY assignment_id) temp_h ON [Assignment_History].id=temp_h.mid
			INNER JOIN [dbo].[AssignmentResults]
				ON [Assignment_History].AssignmentResultsId = [AssignmentResults].Id
			WHERE [AssignmentResults].code = N'ItIsNotPossibleToPerformThisPeriod'
			AND [AssignmentResults].code <> N'WasExplained '
			--AND [Assignment_History].Id IN (SELECT max(id) FROM #temp_TempAssHistory WHERE AssignmentResultsId <> 7 GROUP BY assignment_id);

			--select * from #temp_end_result
--end
-----------------основное-----

IF OBJECT_ID('tempdb..#temp_navig') IS NOT NULL
BEGIN
	DROP TABLE #temp_navig;
END;

SELECT * INTO #temp_navig
FROM (SELECT
		1 Id
	   ,N'УГЛ' name
	UNION ALL
	SELECT
		2 Id
	   ,N'Електронні джерела'
	UNION ALL
	SELECT
		3 Id
	   ,N'Пріоритетне'
	UNION ALL
	SELECT
		4 Id
	   ,N'Інші доручення'
	UNION ALL
	SELECT
		5 Id
	   ,N'Зауваження') AS t;

--SELECT DISTINCT Id, organizations_id, role_name FROM #temp_positions_user --where Id=@organization_id

IF OBJECT_ID('tempdb..#temp_nadiishlo') IS NOT NULL
BEGIN
	DROP TABLE #temp_nadiishlo
END;

SELECT
	[Assignments].Id
   ,CASE
		WHEN [ReceiptSources].code = N'UGL' THEN 1
		WHEN [ReceiptSources].code = N'Website_mob.addition' THEN 2
		WHEN [QuestionTypes].emergency = N'true' THEN 3
		WHEN [QuestionTypes].parent_organization_is = N'true' THEN 5
		ELSE 4
	END navigation INTO #temp_nadiishlo
FROM #temp_assingments [Assignments] WITH (NOLOCK)
INNER JOIN [dbo].[AssignmentStates] WITH (NOLOCK)
	ON [Assignments].assignment_state_id = [AssignmentStates].Id
INNER JOIN [dbo].[AssignmentResults] WITH (NOLOCK)
	ON [Assignments].[AssignmentResultsId] = [AssignmentResults].Id
INNER JOIN [dbo].[AssignmentTypes] WITH (NOLOCK)
	ON [Assignments].assignment_type_id = [AssignmentTypes].Id
INNER JOIN [dbo].[Questions] WITH (NOLOCK)
	ON [Assignments].question_id = [Questions].Id
INNER JOIN [dbo].[Appeals] WITH (NOLOCK)
	ON [Questions].appeal_id = [Appeals].Id
INNER JOIN [dbo].[ReceiptSources] WITH (NOLOCK)
	ON [Appeals].receipt_source_id = [ReceiptSources].Id
LEFT JOIN [dbo].[QuestionTypes] WITH (NOLOCK)
	ON [Questions].question_type_id = [QuestionTypes].Id
WHERE (([AssignmentTypes].code <> N'ToAttention'
AND [AssignmentStates].code = N'Registered'
AND [AssignmentResults].[name] = N'Очікує прийому в роботу')
OR ([AssignmentResults].code = N'ReturnedToTheArtist'
AND [AssignmentStates].code = N'Registered'))
--AND [Assignments].[executor_organization_id] IN (SELECT organizations_id FROM #user_organizations);


IF OBJECT_ID('tempdb..#temp_nevkomp') IS NOT NULL
BEGIN
	DROP TABLE #temp_nevkomp;
END;
SELECT
	[Assignments].Id
   ,CASE
		WHEN [ReceiptSources].code = N'UGL' THEN 1
		WHEN [ReceiptSources].code = N'Website_mob.addition' THEN 2
		WHEN [QuestionTypes].emergency = N'true' THEN 3
		WHEN [QuestionTypes].parent_organization_is = N'true' THEN 5
		ELSE 4
	END navigation INTO #temp_nevkomp
FROM [Assignments] WITH (NOLOCK)
INNER JOIN [dbo].[AssignmentStates] WITH (NOLOCK)
	ON [Assignments].assignment_state_id = [AssignmentStates].Id
INNER JOIN [dbo].[AssignmentResults] WITH (NOLOCK)
	ON [Assignments].[AssignmentResultsId] = [AssignmentResults].Id -- +
INNER JOIN [dbo].[AssignmentResolutions] WITH (NOLOCK)
	ON [Assignments].[AssignmentResolutionsId] = [AssignmentResolutions].Id
LEFT JOIN [dbo].[AssignmentConsiderations] WITH (NOLOCK)
	ON [Assignments].current_assignment_consideration_id = [AssignmentConsiderations].Id
INNER JOIN (SELECT DISTINCT organizations_id, role_name FROM #temp_positions_user where Id=@organization_id) uo 
	ON [AssignmentConsiderations].turn_organization_id=uo.organizations_id
INNER JOIN [dbo].[Questions] WITH (NOLOCK)
	ON [Assignments].question_id = [Questions].Id
INNER JOIN [dbo].[Appeals] WITH (NOLOCK)
	ON [Questions].appeal_id = [Appeals].Id
INNER JOIN [dbo].[ReceiptSources] WITH (NOLOCK)
	ON [Appeals].receipt_source_id = [ReceiptSources].Id
LEFT JOIN [dbo].[QuestionTypes] WITH (NOLOCK)
	ON [Questions].question_type_id = [QuestionTypes].Id
LEFT JOIN [dbo].[AssignmentTypes] WITH (NOLOCK)
	ON [Assignments].assignment_type_id = [AssignmentTypes].Id
WHERE [AssignmentTypes].code <> N'ToAttention'
AND [AssignmentStates].code <> N'Closed'
AND [AssignmentResults].code = N'NotInTheCompetence'
AND [AssignmentResolutions].name IN (N'Повернуто в 1551', N'Повернуто в батьківську організацію')

--AND (CASE
--	WHEN @role = N'Конролер' AND
--		[AssignmentResolutions].name = N'Повернуто в 1551' THEN 1
--	WHEN @role <> N'Конролер' AND
--		[AssignmentResolutions].name = N'Повернуто в батьківську організацію' THEN 1
--END) = 1
--AND [AssignmentConsiderations].turn_organization_id IN (SELECT Id FROM @user_org_t);

AND (CASE
	WHEN uo.role_name = N'Конролер' AND
		[AssignmentResolutions].name = N'Повернуто в 1551' THEN 1
	WHEN ISNULL(uo.role_name, N'')  <> N'Конролер' AND
		[AssignmentResolutions].name = N'Повернуто в батьківську організацію' THEN 1
END) = 1


IF OBJECT_ID('tempdb..#temp_prostr') IS NOT NULL
BEGIN
	DROP TABLE #temp_prostr;
END;
SELECT
	[Assignments].Id
   ,CASE
		WHEN [ReceiptSources].code = N'UGL' THEN 1
		WHEN [ReceiptSources].code = N'Website_mob.addition' THEN 2
		WHEN [QuestionTypes].emergency = N'true' THEN 3
		WHEN [QuestionTypes].parent_organization_is = N'true' THEN 5
		ELSE 4
	END navigation INTO #temp_prostr
FROM #temp_assingments [Assignments] WITH (NOLOCK)
INNER JOIN [dbo].[Questions] WITH (NOLOCK)
	ON [Assignments].question_id = [Questions].Id
INNER JOIN [dbo].[AssignmentStates] WITH (NOLOCK)
	ON [Assignments].assignment_state_id = [AssignmentStates].Id
INNER JOIN [dbo].[AssignmentTypes] WITH (NOLOCK)
	ON [Assignments].assignment_type_id = [AssignmentTypes].Id
INNER JOIN [dbo].[Appeals] WITH (NOLOCK)
	ON [Questions].appeal_id = [Appeals].Id
INNER JOIN [dbo].[ReceiptSources] WITH (NOLOCK)
	ON [Appeals].receipt_source_id = [ReceiptSources].Id
LEFT JOIN [dbo].[QuestionTypes] WITH (NOLOCK)
	ON [Questions].question_type_id = [QuestionTypes].Id
WHERE
--[AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork' and 
--[Questions].control_date<=getutcdate()
([Questions].control_date <= GETUTCDATE()
AND [AssignmentTypes].code <> N'ToAttention'
AND [AssignmentStates].code = N'InWork')
--AND [Assignments].[executor_organization_id] IN (SELECT organizations_id FROM #user_organizations);


IF OBJECT_ID('tempdb..#temp_uvaga') IS NOT NULL
BEGIN
	DROP TABLE #temp_uvaga;
END;
SELECT
	[Assignments].Id
   ,CASE
		WHEN [ReceiptSources].code = N'UGL' THEN 1
		WHEN [ReceiptSources].code = N'Website_mob.addition' THEN 2
		WHEN [QuestionTypes].emergency = N'true' THEN 3
		WHEN [QuestionTypes].parent_organization_is = N'true' THEN 5
		ELSE 4
	END navigation INTO #temp_uvaga
FROM #temp_assingments [Assignments] WITH (NOLOCK)
INNER JOIN [dbo].[Questions] WITH (NOLOCK)
	ON [Assignments].question_id = [Questions].Id
INNER JOIN [dbo].[AssignmentStates] WITH (NOLOCK)
	ON [Assignments].assignment_state_id = [AssignmentStates].Id
INNER JOIN [dbo].[AssignmentTypes] WITH (NOLOCK)
	ON [Assignments].assignment_type_id = [AssignmentTypes].Id
INNER JOIN [dbo].[Appeals] WITH (NOLOCK)
	ON [Questions].appeal_id = [Appeals].Id
INNER JOIN [dbo].[ReceiptSources] WITH (NOLOCK)
	ON [Appeals].receipt_source_id = [ReceiptSources].Id
LEFT JOIN [dbo].[QuestionTypes] WITH (NOLOCK)
	ON [Questions].question_type_id = [QuestionTypes].Id
WHERE
--[AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork' and 
--datediff(HH, [Assignments].registration_date, getdate())>[Attention_term_hours]
--and datediff(HH, [Assignments].registration_date, getdate())<=[execution_term]
-- DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.25*-1, [Questions].control_date)<getutcdate()
-- [Questions].control_date>=getutcdate()
(DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date) * 0.25 * -1, [Questions].control_date) < GETUTCDATE()
AND [Questions].control_date >= GETUTCDATE()
AND [AssignmentTypes].code <> N'ToAttention'
AND [AssignmentStates].code = N'InWork')
--AND [Assignments].[executor_organization_id] IN (SELECT organizations_id FROM #user_organizations)


IF OBJECT_ID('tempdb..#temp_vroboti') IS NOT NULL
BEGIN
	DROP TABLE #temp_vroboti;
END;
SELECT
	[Assignments].Id
   ,CASE
		WHEN [ReceiptSources].code = N'UGL' THEN 1
		WHEN [ReceiptSources].code = N'Website_mob.addition' THEN 2
		WHEN [QuestionTypes].emergency = N'true' THEN 3
		WHEN [QuestionTypes].parent_organization_is = N'true' THEN 5
		ELSE 4
	END navigation INTO #temp_vroboti
FROM #temp_assingments [Assignments] WITH (NOLOCK)
INNER JOIN [dbo].[Questions] WITH (NOLOCK)
	ON [Assignments].question_id = [Questions].Id
INNER JOIN [dbo].[AssignmentStates] WITH (NOLOCK)
	ON [Assignments].assignment_state_id = [AssignmentStates].Id
INNER JOIN [dbo].[AssignmentTypes] WITH (NOLOCK)
	ON [Assignments].assignment_type_id = [AssignmentTypes].Id
INNER JOIN [dbo].[Appeals] WITH (NOLOCK)
	ON [Questions].appeal_id = [Appeals].Id
INNER JOIN [dbo].[ReceiptSources] WITH (NOLOCK)
	ON [Appeals].receipt_source_id = [ReceiptSources].Id
LEFT JOIN [dbo].[QuestionTypes] WITH (NOLOCK)
	ON [Questions].question_type_id = [QuestionTypes].Id
WHERE
--[AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork' and
--datediff(HH, [Assignments].registration_date, getdate())<=[Attention_term_hours]
-- DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.75, [Questions].registration_date)>=getutcdate()
-- and [Questions].control_date>=getutcdate()
--[Assignments].[executor_organization_id] IN (SELECT organizations_id FROM #user_organizations)
(DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date) * 0.75, [Questions].registration_date) >= GETUTCDATE()
AND [Questions].control_date >= GETUTCDATE()
AND [AssignmentTypes].code <> N'ToAttention'
AND [AssignmentStates].code = N'InWork');



IF OBJECT_ID('tempdb..#temp_dovidoma') IS NOT NULL
BEGIN
	DROP TABLE #temp_dovidoma;
END;
SELECT
	[Assignments].Id
   ,CASE
		WHEN [ReceiptSources].code = N'UGL' THEN 1
		WHEN [ReceiptSources].code = N'Website_mob.addition' THEN 2
		WHEN [QuestionTypes].emergency = N'true' THEN 3
		WHEN [QuestionTypes].parent_organization_is = N'true' THEN 5
		ELSE 4
	END navigation INTO #temp_dovidoma
FROM #temp_assingments [Assignments] WITH (NOLOCK)
INNER JOIN [dbo].[Questions] WITH (NOLOCK)
	ON [Assignments].question_id = [Questions].Id
INNER JOIN [dbo].[AssignmentStates] WITH (NOLOCK)
	ON [Assignments].assignment_state_id = [AssignmentStates].Id
INNER JOIN [dbo].[AssignmentTypes] WITH (NOLOCK)
	ON [Assignments].assignment_type_id = [AssignmentTypes].Id
INNER JOIN [dbo].[Appeals] WITH (NOLOCK)
	ON [Questions].appeal_id = [Appeals].Id
INNER JOIN [dbo].[ReceiptSources] WITH (NOLOCK)
	ON [Appeals].receipt_source_id = [ReceiptSources].Id
LEFT JOIN [dbo].[QuestionTypes] WITH (NOLOCK)
	ON [Questions].question_type_id = [QuestionTypes].Id
WHERE [AssignmentTypes].code = N'ToAttention'
AND [AssignmentStates].code = N'Registered'
--AND [Assignments].[executor_organization_id] IN (SELECT organizations_id FROM #user_organizations)



IF OBJECT_ID('tempdb..#temp_nadoopr') IS NOT NULL
BEGIN
	DROP TABLE #temp_nadoopr;
END;
SELECT
	[Assignments].Id
   ,CASE
		WHEN [ReceiptSources].code = N'UGL' THEN 1
		WHEN [ReceiptSources].code = N'Website_mob.addition' THEN 2
		WHEN [QuestionTypes].emergency = N'true' THEN 3
		WHEN [QuestionTypes].parent_organization_is = N'true' THEN 5
		ELSE 4
	END navigation INTO #temp_nadoopr
FROM #temp_assingments [Assignments] WITH (NOLOCK)
INNER JOIN [dbo].[AssignmentStates] WITH (NOLOCK)
	ON [Assignments].assignment_state_id = [AssignmentStates].Id
INNER JOIN [dbo].[AssignmentResults] WITH (NOLOCK)
	ON [Assignments].[AssignmentResultsId] = [AssignmentResults].Id -- +
INNER JOIN [dbo].[Questions] WITH (NOLOCK)
	ON [Assignments].question_id = [Questions].Id
INNER JOIN [dbo].[Appeals] WITH (NOLOCK)
	ON [Questions].appeal_id = [Appeals].Id
INNER JOIN [dbo].[ReceiptSources] WITH (NOLOCK)
	ON [Appeals].receipt_source_id = [ReceiptSources].Id
LEFT JOIN [dbo].[QuestionTypes] WITH (NOLOCK)
	ON [Questions].question_type_id = [QuestionTypes].Id
WHERE [AssignmentStates].code = N'NotFulfilled'
AND ([AssignmentResults].code = N'ForWork'
OR [AssignmentResults].code = N'Actually')
--AND [Assignments].[executor_organization_id] IN (SELECT organizations_id FROM #user_organizations)



IF OBJECT_ID('tempdb..#temp_plan_p') IS NOT NULL
BEGIN
	DROP TABLE #temp_plan_p;
END;
SELECT
	[Assignments].Id
   ,CASE
		WHEN [ReceiptSources].code = N'UGL' THEN 1
		WHEN [ReceiptSources].code = N'Website_mob.addition' THEN 2
		WHEN [QuestionTypes].emergency = N'true' THEN 3
		WHEN [QuestionTypes].parent_organization_is = N'true' THEN 5
		ELSE 4
	END navigation INTO #temp_plan_p
FROM #temp_assingments [Assignments] WITH (NOLOCK)
INNER JOIN #temp_end_result
	ON [Assignments].Id = #temp_end_result.assignment_id
INNER JOIN #temp_end_state
	ON [Assignments].Id = #temp_end_state.assignment_id
INNER JOIN [dbo].[Questions] WITH (NOLOCK)
	ON [Assignments].question_id = [Questions].Id
INNER JOIN [dbo].[Appeals] WITH (NOLOCK)
	ON [Questions].appeal_id = [Appeals].Id
INNER JOIN [dbo].[ReceiptSources] WITH (NOLOCK)
	ON [Appeals].receipt_source_id = [ReceiptSources].Id
LEFT JOIN [dbo].[QuestionTypes] WITH (NOLOCK)
	ON [Questions].question_type_id = [QuestionTypes].Id
WHERE [Questions].event_id IS NULL
--where 
--[AssignmentStates].code=N'NotFulfilled' and [AssignmentResults].code=N'ItIsNotPossibleToPerformThisPeriod'

--and [Assignments].[executor_organization_id]=@organization_id


IF OBJECT_ID('tempdb..#temp_main') IS NOT NULL
BEGIN
	DROP TABLE #temp_main;
END;

SELECT
	Id
   ,navigation
   ,N'nadiishlo' name INTO #temp_main
FROM #temp_nadiishlo
UNION
SELECT
	Id
   ,navigation
   ,N'nevkomp' name
FROM #temp_nevkomp
UNION
SELECT
	Id
   ,navigation
   ,N'prostr' name
FROM #temp_prostr
UNION
SELECT
	Id
   ,navigation
   ,N'uvaga' name
FROM #temp_uvaga
UNION
SELECT
	Id
   ,navigation
   ,N'vroboti' name
FROM #temp_vroboti
UNION
SELECT
	Id
   ,navigation
   ,N'dovidoma' name
FROM #temp_dovidoma
UNION
SELECT
	Id
   ,navigation
   ,N'nadoopr' name
FROM #temp_nadoopr
UNION
SELECT
	Id
   ,navigation
   ,N'neVykonNeMozhl' name
FROM #temp_plan_p;



SELECT
	Id
   ,name [navigation]
   ,ISNULL([nadiishlo], 0) [nadiyshlo]
   ,ISNULL([nevkomp], 0) [neVKompetentsii]
   ,ISNULL([prostr], 0) [prostrocheni]
   ,ISNULL([uvaga], 0) [uvaga]
   ,ISNULL([vroboti], 0) [vroboti]
   ,ISNULL([dovidoma], 0) [dovidoma]
   ,ISNULL([nadoopr], 0) [naDoopratsiyvanni]
   ,ISNULL([neVykonNeMozhl], 0) [neVykonNeMozhl]
FROM (SELECT
		#temp_navig.Id
	   ,#temp_navig.name
	   ,main.name main_name
	   ,cc
	FROM #temp_navig
	LEFT JOIN (SELECT
			navigation
		   ,name
		   ,COUNT(Id) cc
		FROM #temp_main
		GROUP BY navigation
				,name) main
		ON #temp_navig.Id = main.navigation) t
PIVOT
(SUM(cc) FOR main_name IN ([nadiishlo], [nevkomp], [prostr], [uvaga], [vroboti], [dovidoma], [nadoopr], [neVykonNeMozhl])
) pvt;

--SELECT * FROM #temp_positions_user

drop table #temp_sort
	END
   
   ELSE 

	BEGIN
		SELECT 1 Id, 2 [nadiyshlo], 2 [neVKompetentsii], 2 [prostrocheni], 2 [uvaga], 2 [vroboti], 2 [dovidoma], 2 [naDoopratsiyvanni], 2 [neVykonNeMozhl]
		WHERE 1=2;
	END;

   
