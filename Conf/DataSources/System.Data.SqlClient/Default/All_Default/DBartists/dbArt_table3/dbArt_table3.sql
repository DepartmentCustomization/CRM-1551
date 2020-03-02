/*
DECLARE @organization_Id INT =1762--1762;
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
  /* версия 1 начало
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
  версия 1 конец */
  
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



--SELECT * FROM #temp_assingments

  --


		-------------------------------------------------------------------------------------------------------------------------------
			-------------------------------------------------------------------------------------------------------------------------------
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
			WHERE [Assignment_History].assignment_id in (select Id FROM #temp_main_end);


			IF OBJECT_ID('tempdb..#temp_end_state') IS NOT NULL
			BEGIN
				DROP TABLE #temp_end_state;
			END;
			SELECT
				[Assignment_History].Id
			   ,[Assignment_History].assignment_id
			   ,[Assignment_History].assignment_state_id INTO #temp_end_state
			FROM [dbo].[Assignment_History] WITH (NOLOCK)
			INNER JOIN [dbo].[AssignmentStates]
				ON [Assignment_History].assignment_state_id = [AssignmentStates].Id
			WHERE [AssignmentStates].code = N'OnCheck'
			AND [AssignmentStates].code <> N'Closed'
			AND [Assignment_History].Id IN (SELECT MAX(id) FROM #temp_TempAssHistory WHERE assignment_state_id <> 5 GROUP BY assignment_id);

		

			IF OBJECT_ID('tempdb..#temp_end_result') IS NOT NULL
			BEGIN
				DROP TABLE #temp_end_result;
			END;
			SELECT
				[Assignment_History].Id
			   ,[Assignment_History].assignment_id
			   ,[Assignment_History].AssignmentResultsId INTO #temp_end_result
			FROM [dbo].[Assignment_History] WITH (NOLOCK)
			INNER JOIN [dbo].[AssignmentResults]
				ON [Assignment_History].AssignmentResultsId = [AssignmentResults].Id
			WHERE [AssignmentResults].code = N'ItIsNotPossibleToPerformThisPeriod'
			AND [AssignmentResults].code <> N'WasExplained '
			AND [Assignment_History].Id IN (SELECT max(id) FROM #temp_TempAssHistory WHERE AssignmentResultsId <> 7 GROUP BY assignment_id);


			IF OBJECT_ID('tempdb..#temp_AllAss') IS NOT NULL
			BEGIN
				DROP TABLE #temp_AllAss;
			END;

			SELECT
				[Assignments].[Id]
			   ,[Organizations].[Id] OrganizationsId
			   ,[Organizations].[short_name] OrganizationsName
			   ,[AssignmentTypes].[code] [AssignmentType_Code]
			   ,[AssignmentStates].[code] [AssignmentState_Code]
			   ,[AssignmentResults].[name] [AssignmentResult_Name]
			   ,[AssignmentResults].[code] [AssignmentResult_Code]
			   ,[AssignmentResolutions].name [AssignmentResolution_Name]
			   ,[AssignmentConsiderations].[turn_organization_id]
			   ,[turn_org].[short_name] [turn_organization_name]
			   ,[Questions].[control_date]
			   ,[Questions].[registration_date]
			   ,[Assignments].[executor_person_id]
			   ,[Positions].Id Positions_Id
			   ,ISNULL([Positions].position,N'')+ISNULL(N' ('+[Positions].name+N')',N'') Positions_Name
			   INTO #temp_AllAss
			FROM [dbo].[Assignments] WITH (NOLOCK)
			INNER JOIN [dbo].[Positions] 
				ON [Assignments].executor_person_id=[Positions].Id
			INNER JOIN [dbo].[Questions] WITH (NOLOCK)
				ON [Assignments].question_id = [Questions].Id
			INNER JOIN [dbo].[Appeals] WITH (NOLOCK)
				ON [Questions].appeal_id = [Appeals].Id
			INNER JOIN [dbo].[ReceiptSources] WITH (NOLOCK)
				ON [Appeals].receipt_source_id = [ReceiptSources].Id
			LEFT JOIN [dbo].[QuestionTypes] WITH (NOLOCK)
				ON [Questions].question_type_id = [QuestionTypes].Id
			LEFT JOIN [dbo].[AssignmentTypes]
				ON [Assignments].assignment_type_id = [AssignmentTypes].Id
			LEFT JOIN [dbo].[AssignmentStates]
				ON [Assignments].assignment_state_id = [AssignmentStates].Id
			LEFT JOIN [dbo].[AssignmentResults] WITH (NOLOCK)
				ON [Assignments].[AssignmentResultsId] = [AssignmentResults].Id
			LEFT JOIN [dbo].[AssignmentResolutions] WITH (NOLOCK)
				ON [Assignments].[AssignmentResolutionsId] = [AssignmentResolutions].Id
			LEFT JOIN [dbo].[AssignmentConsiderations] WITH (NOLOCK)
					ON [Assignments].current_assignment_consideration_id = [AssignmentConsiderations].Id

			LEFT JOIN [dbo].[Organizations] WITH (NOLOCK)
				ON [Assignments].executor_organization_id = [Organizations].Id
			LEFT JOIN [dbo].[Organizations] as [turn_org] WITH (NOLOCK)
				ON [AssignmentConsiderations].turn_organization_id = [turn_org].Id

			WHERE [Assignments].[executor_organization_id] IN (SELECT organizations_id FROM #organizations_user)
			or [AssignmentConsiderations].turn_organization_id IN (SELECT organizations_id FROM #organizations_user);

			
			CREATE NONCLUSTERED INDEX [NONCLUSTERED_INDEX_temp_AllAss]
			ON #temp_AllAss ([AssignmentResult_Code],[AssignmentType_Code],[AssignmentState_Code],[AssignmentResolution_Name])
			INCLUDE ([Id],[OrganizationsId],[turn_organization_id],[turn_organization_name], [Positions_Id], [Positions_Name]);
	
			CREATE NONCLUSTERED INDEX [NONCLUSTERED_INDEX_temp_AllAss_INCLUDE]
			ON #temp_AllAss ([AssignmentState_Code],[AssignmentType_Code],[control_date])
			INCLUDE ([Id],[OrganizationsId],[OrganizationsName],[registration_date], [Positions_Id], [Positions_Name]);
			
			-----------------основное-----
			IF OBJECT_ID('tempdb..#temp_nadiishlo') IS NOT NULL
			BEGIN
				DROP TABLE #temp_nadiishlo;
			END
			SELECT
				taa.Id
			   ,taa.Positions_Id
			   ,taa.Positions_Name 
			INTO #temp_nadiishlo
			FROM #temp_AllAss taa
			INNER JOIN #temp_assingments ta ON taa.Id=ta.Id
			WHERE (
					([AssignmentType_Code] <> N'ToAttention'
						AND [AssignmentState_Code] = N'Registered'
					    AND [AssignmentResult_Name] = N'Очікує прийому в роботу')
					OR ([AssignmentResult_Code] = N'ReturnedToTheArtist'
						AND [AssignmentState_Code] = N'Registered')
				   )
			--AND OrganizationsId in (SELECT organizations_id FROM #user_organizations);

			

			IF OBJECT_ID('tempdb..#temp_nevkomp') IS NOT NULL
			BEGIN
				DROP TABLE #temp_nevkomp;
			END;
			SELECT
				ta.Id
			   ,ta.Positions_Id--turn_organization_id as OrganizationsId
			   ,ta.Positions_Name--turn_organization_name as OrganizationsName
			INTO #temp_nevkomp
			FROM #temp_AllAss ta
			INNER JOIN (SELECT DISTINCT Id, organizations_id, role_name  FROM #temp_positions_user) uo
			ON ta.turn_organization_id=uo.organizations_id and ta.Positions_Id=uo.Id
			WHERE ta.[AssignmentType_Code] <> N'ToAttention'
			AND ta.[AssignmentState_Code] <> N'Closed'
			AND ta.[AssignmentResult_Code] = N'NotInTheCompetence'
			AND ta.[AssignmentResolution_Name] IN (N'Повернуто в 1551', N'Повернуто в батьківську організацію')
			AND (CASE
				 	WHEN ISNULL(uo.role_name,N'') = N'Конролер' AND
				 		[AssignmentResolution_Name] = N'Повернуто в 1551' THEN 1
				 	WHEN ISNULL(uo.role_name,N'') <> N'Конролер' AND
				 		[AssignmentResolution_Name] = N'Повернуто в батьківську організацію' THEN 1
				 END) = 1
			AND turn_organization_id IN (SELECT organizations_id FROM #organizations_user)




			IF OBJECT_ID('tempdb..#temp_prostr') IS NOT NULL
			BEGIN
				DROP TABLE #temp_prostr;
			END;
			SELECT
				taa.Id
			   ,taa.Positions_Id--OrganizationsId
			   ,taa.Positions_Name--OrganizationsName 
			INTO #temp_prostr
			FROM #temp_AllAss taa
			INNER JOIN #temp_assingments ta ON taa.Id=ta.Id
			WHERE ([control_date] <= GETUTCDATE()
					AND [AssignmentType_Code] <> N'ToAttention'
					AND [AssignmentState_Code] = N'InWork')
			--AND OrganizationsId IN (SELECT organizations_id FROM #user_organizations);
			




			IF OBJECT_ID('tempdb..#temp_uvaga') IS NOT NULL
			BEGIN
				DROP TABLE #temp_uvaga;
			END;
			SELECT
				taa.Id
			   ,taa.Positions_Id--OrganizationsId
			   ,taa.Positions_Name--OrganizationsName 
			INTO #temp_uvaga
			FROM #temp_AllAss taa
			INNER JOIN #temp_assingments ta ON taa.Id=ta.Id
			WHERE taa.[control_date] >= GETUTCDATE()
			AND (DATEADD(MI, DATEDIFF(MI, taa.[registration_date], taa.[control_date]) * 0.25 * -1, taa.[control_date]) < GETUTCDATE()
			AND taa.[control_date] >= GETUTCDATE()
			AND [AssignmentType_Code] <> N'ToAttention'
			AND [AssignmentState_Code] = N'InWork')
			--AND OrganizationsId IN (SELECT organizations_id FROM #user_organizations);



			IF OBJECT_ID('tempdb..#temp_vroboti') IS NOT NULL
			BEGIN
				DROP TABLE #temp_vroboti;
			END;
			SELECT
				taa.Id
			   ,taa.Positions_Id--OrganizationsId
			   ,taa.Positions_Name--OrganizationsName 
			INTO #temp_vroboti
			FROM #temp_AllAss taa
			INNER JOIN #temp_assingments ta ON taa.Id=ta.Id
			WHERE [control_date] >= GETUTCDATE()
			AND (DATEADD(MI, DATEDIFF(MI, taa.[registration_date], [control_date]) * 0.75, taa.[registration_date]) >= GETUTCDATE()
			AND [control_date] >= GETUTCDATE()
			AND [AssignmentType_Code] <> N'ToAttention'
			AND [AssignmentState_Code] = N'InWork')
			--AND [OrganizationsId] IN (SELECT organizations_id FROM #user_organizations);


			IF OBJECT_ID('tempdb..#temp_dovidoma') IS NOT NULL
			BEGIN
				DROP TABLE #temp_dovidoma;
			END;
			SELECT
				taa.Id
			   ,taa.Positions_Id--OrganizationsId
			   ,taa.Positions_Name--OrganizationsName 
			INTO #temp_dovidoma
			FROM #temp_AllAss taa
			INNER JOIN #temp_assingments ta ON taa.Id=ta.Id
			WHERE [AssignmentType_Code] = N'ToAttention'
			AND [AssignmentState_Code] = N'Registered'
			--AND [OrganizationsId] IN (SELECT organizations_id FROM #user_organizations);




			IF OBJECT_ID('tempdb..#temp_nadoopr') IS NOT NULL
			BEGIN
				DROP TABLE #temp_nadoopr;
			END;
			SELECT
				taa.Id
			   ,taa.Positions_Id--OrganizationsId
			   ,taa.Positions_Name--OrganizationsName 
			INTO #temp_nadoopr
			FROM #temp_AllAss taa
			INNER JOIN #temp_assingments ta ON taa.Id=ta.Id
			WHERE [AssignmentState_Code] = N'NotFulfilled'
				  AND ([AssignmentResult_Code] = N'ForWork'
				  OR [AssignmentResult_Code] = N'Actually')
			--AND [OrganizationsId] IN (SELECT organizations_id FROM #organizations_user);



			IF OBJECT_ID('tempdb..#temp_plan_p') IS NOT NULL
			BEGIN
				DROP TABLE #temp_plan_p
			END;
			SELECT
				[Assignments].Id
			   --,[Organizations].Id OrganizationsId
			   --,[Organizations].short_name OrganizationsName 
			   ,[Positions].Id Positions_Id
			   ,[Positions].position Positions_Name
			   INTO #temp_plan_p
			FROM [dbo].[Assignments] WITH (NOLOCK)
			INNER JOIN [dbo].[Positions] 
				ON [Assignments].executor_person_id=[Positions].Id
			INNER JOIN #temp_end_result
				ON [Assignments].Id = #temp_end_result.assignment_id
			INNER JOIN #temp_end_state
				ON [Assignments].Id = #temp_end_state.assignment_id
			LEFT JOIN [dbo].[Questions] WITH (NOLOCK)
				ON [Assignments].question_id = [Questions].Id
			LEFT JOIN [dbo].[Appeals] WITH (NOLOCK)
				ON [Questions].appeal_id = [Appeals].Id
			LEFT JOIN [dbo].[ReceiptSources] WITH (NOLOCK)
				ON [Appeals].receipt_source_id = [ReceiptSources].Id
			LEFT JOIN [dbo].[QuestionTypes] WITH (NOLOCK)
				ON [Questions].question_type_id = [QuestionTypes].Id
			LEFT JOIN [dbo].[AssignmentTypes] WITH (NOLOCK)
				ON [Assignments].assignment_type_id = [AssignmentTypes].Id
			LEFT JOIN [dbo].[AssignmentStates] WITH (NOLOCK)
				ON [Assignments].assignment_state_id = [AssignmentStates].Id
			LEFT JOIN [dbo].[AssignmentResults] WITH (NOLOCK)
				ON [Assignments].[AssignmentResultsId] = [AssignmentResults].Id
			LEFT JOIN [dbo].[AssignmentResolutions] WITH (NOLOCK)
				ON [Assignments].[AssignmentResolutionsId] = [AssignmentResolutions].Id
			LEFT JOIN [dbo].[Organizations] WITH (NOLOCK)
				ON [Assignments].executor_organization_id = [Organizations].Id
			WHERE [Questions].event_id IS NULL;


IF OBJECT_ID('tempdb..#temp_main') IS NOT NULL
BEGIN
	DROP TABLE #temp_main;
END;

SELECT
	Id
   ,N'nadiyshlo' name
   ,Positions_Id
   ,Positions_Name 
   INTO #temp_main
FROM #temp_nadiishlo
UNION
SELECT
	Id
   ,N'neVKompetentsii' name
   ,Positions_Id
   ,Positions_Name
FROM #temp_nevkomp
UNION
SELECT
	Id
   ,N'prostrocheni' name
   ,Positions_Id
   ,Positions_Name
FROM #temp_prostr
UNION
SELECT
	Id
   ,N'uvaga' name
   ,Positions_Id
   ,Positions_Name
FROM #temp_uvaga
UNION
SELECT
	Id
   ,N'vroboti' name
   ,Positions_Id
   ,Positions_Name
FROM #temp_vroboti
UNION
SELECT
	Id
   ,N'dovidoma' name
   ,Positions_Id
   ,Positions_Name
FROM #temp_dovidoma
UNION 
SELECT
	Id 
   ,N'naDoopratsiyvanni' name
   ,Positions_Id
   ,Positions_Name
FROM #temp_nadoopr
UNION 
SELECT
	Id
   ,N'neVykonNeMozhl' name
   ,Positions_Id
   ,Positions_Name
FROM #temp_plan_p;


SELECT
	--[OrganizationsId] [OrganizationId]
   --,[OrganizationsName] [OrganizationName]
   [Positions_Id] [OrganizationId]
   ,[Positions_Name] [OrganizationName]
   ,[nadiyshlo]
   ,[neVKompetentsii]
   ,[prostrocheni]
   ,[uvaga]
   ,[vroboti]
   ,[dovidoma]
   ,[naDoopratsiyvanni]
   ,[neVykonNeMozhl]
   --into #for_organizations
FROM (SELECT tm.Id, tm.Positions_Id, tm.[Positions_Name], s.sort, tm.name 
FROM #temp_main tm 
LEFT JOIN #temp_sort s ON tm.Positions_Id=s.position_id) t
PIVOT
(
COUNT(Id) FOR name IN ([nadiyshlo], [neVKompetentsii], [prostrocheni], [uvaga], [vroboti], [dovidoma], [naDoopratsiyvanni], [neVykonNeMozhl])
) pvt
ORDER BY ISNULL(sort,100)

drop table #temp_sort



	END
   
   ELSE 

	BEGIN
		SELECT 1  [OrganizationId] --[Positions_Id]
   ,N'' [OrganizationName] --[Positions_Name] 
   ,1 [nadiyshlo]
   ,1 [neVKompetentsii]
   ,1 [prostrocheni]
   ,1 [uvaga]
   ,1 [vroboti]
   ,1 [dovidoma]
   ,1 [naDoopratsiyvanni]
   ,1 [neVykonNeMozhl]
		WHERE 1=2;

		
	END
   
