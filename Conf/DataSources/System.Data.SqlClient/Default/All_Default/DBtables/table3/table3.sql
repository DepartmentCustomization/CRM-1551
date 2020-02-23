

  --DECLARE @organization_Id INT =1762;
  --DECLARE @user_id NVARCHAR(300)=N'29796543-b903-48a6-9399-4840f6eac396';

  IF EXISTS
  (SELECT orr.*
  FROM [dbo].[OrganizationInResponsibilityRights] orr
  INNER JOIN dbo.Positions p ON orr.position_id=P.Id
  WHERE orr.organization_id=@organization_Id 
  AND P.programuser_id=@user_id)

	BEGIN
		DECLARE @role NVARCHAR(500) = (SELECT
		[Roles].name
	FROM [dbo].[Positions] WITH (NOLOCK)
	LEFT JOIN [dbo].[Roles] WITH (NOLOCK)
		ON [Positions].role_id = [Roles].Id
	WHERE [Positions].programuser_id = @user_id);

--SELECT @role



DECLARE @Organization TABLE (
	Id INT
);

--------------новейшие разработки
DECLARE @t TABLE (
	Id INT
   ,PId INT
);
-- declare @OrganizationT_id int =6704;
--declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
DECLARE @OrganizationT TABLE (
	Id INT
);
DECLARE @Par TABLE (
	Id0 INT IDENTITY (1, 1)
   ,Id INT
);
DECLARE @n INT = 1;
DECLARE @OrganizationTId INT;

INSERT INTO @Par (Id)
	SELECT
		Id
	FROM [dbo].[Organizations] WITH (NOLOCK)
	WHERE parent_organization_id = @organization_id;


--select * FROM @Par

WHILE @n <= (SELECT
		MAX(Id0)
	FROM @Par)
BEGIN
SET @OrganizationTId = (SELECT Id
	FROM @Par
	WHERE Id0 = @n);--@OrganizationT_id;


DECLARE @IdTT TABLE (
	Id INT
);

-- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
INSERT INTO @IdTT (Id)
	SELECT
		Id
	FROM [dbo].[Organizations] WITH (NOLOCK)
	WHERE (Id = @OrganizationTId
	OR [parent_organization_id] = @OrganizationTId)
	AND Id NOT IN (SELECT
			Id
		FROM @IdTT);

--  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
WHILE (SELECT
		COUNT(Id)
	FROM (SELECT
			Id
		FROM [dbo].[Organizations] WITH (NOLOCK)
		WHERE [parent_organization_id] IN (SELECT
				Id
			FROM @IdTT) --or Id in (select Id FROM @IdT)
		AND Id NOT IN (SELECT
				Id
			FROM @IdTT)) q)
!= 0
BEGIN

INSERT INTO @IdTT
	SELECT
		Id
	FROM [dbo].[Organizations] WITH (NOLOCK)
	WHERE [parent_organization_id] IN (SELECT
			Id
		FROM @IdTT) --or Id in (select Id FROM @IdT)
	AND Id NOT IN (SELECT
			Id
		FROM @IdTT);
END

INSERT INTO @OrganizationT (Id)
	SELECT
		Id
	FROM @IdTT;

INSERT INTO @t (Id, PId)
	SELECT
		Id
	   ,@OrganizationTId PId
	FROM @OrganizationT;

SET @n = @n + 1;

DELETE FROM @OrganizationT;
DELETE FROM @IdTT;
END



DECLARE @OrganizationId INT =
CASE
	WHEN @organization_id IS NOT NULL THEN @organization_id
	ELSE (SELECT
				Id
			FROM [dbo].[Organizations] WITH (NOLOCK)
			WHERE Id IN (SELECT
					organization_id
				FROM [dbo].[Workers] WITH (NOLOCK)
				WHERE worker_user_id = @user_id))
END;


DECLARE @IdT TABLE (
	Id INT
);

-- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
INSERT INTO @IdT (Id)
	SELECT
		Id
	FROM [dbo].[Organizations] WITH (NOLOCK)
	WHERE ([parent_organization_id] = @OrganizationId)
	AND Id NOT IN (SELECT
			Id
		FROM @IdT);

--  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
WHILE (SELECT
		COUNT(Id)
	FROM (SELECT
			Id
		FROM [dbo].[Organizations] WITH (NOLOCK)
		WHERE [parent_organization_id] IN (SELECT
				Id
			FROM @IdT) --or Id in (select Id FROM @IdT)
		AND Id NOT IN (SELECT
				Id
			FROM @IdT)) q)
!= 0
BEGIN

INSERT INTO @IdT
	SELECT
		Id
	FROM [dbo].[Organizations] WITH (NOLOCK)
	WHERE [parent_organization_id] IN (SELECT
			Id
		FROM @IdT)-- or Id in (select Id FROM @IdT)
	AND Id NOT IN (SELECT
			Id
		FROM @IdT);
END

INSERT INTO @Organization (Id)
	SELECT
		Id
	FROM @IdT;

--select Id, @organization_id FROM @Organization

--існуючі доручення в організації
DECLARE @Organizations_is TABLE (
	Id INT
);
INSERT INTO @Organizations_is (Id)
	SELECT DISTINCT
		[executor_organization_id]
	FROM [dbo].[Assignments] WITH (NOLOCK)
	WHERE [executor_organization_id] IN (SELECT
			Id
		FROM @Organization);

DECLARE @Organization_nevkonp TABLE (
	Id INT
);

INSERT INTO @Organization_nevkonp (Id)

	SELECT DISTINCT
		[turn_organization_id]
	FROM [dbo].[AssignmentConsiderations] WITH (NOLOCK)
	WHERE [turn_organization_id] IN (SELECT
			Id
		FROM @Organization);


		-------------------------------------------------------------------------------------------------------------------------------
			-------------------------------------------------------------------------------------------------------------------------------
			------------для плана/програми---
			
			IF OBJECT_ID('tempdb..#temp_main_end') IS NOT NULL
			BEGIN
				DROP TABLE #temp_main_end;
			END;
			SELECT
				Id INTO #temp_main_end
			FROM [dbo].[Assignments] WITH (NOLOCK)
			WHERE assignment_state_id = 5
			AND AssignmentResultsId = 7
			AND executor_organization_id IN (SELECT Id FROM @Organizations_is);


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
			   ,[Questions].[registration_date] INTO #temp_AllAss
			FROM [dbo].[Assignments] WITH (NOLOCK)
			LEFT JOIN [dbo].[Questions] WITH (NOLOCK)
				ON [Assignments].question_id = [Questions].Id
			LEFT JOIN [dbo].[Appeals] WITH (NOLOCK)
				ON [Questions].appeal_id = [Appeals].Id
			LEFT JOIN [dbo].[ReceiptSources] WITH (NOLOCK)
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
			LEFT JOIN [dbo].[Organizations] WITH (NOLOCK)
				ON [Assignments].executor_organization_id = [Organizations].Id
			LEFT JOIN [dbo].[AssignmentConsiderations] WITH (NOLOCK)
					ON [Assignments].current_assignment_consideration_id = [AssignmentConsiderations].Id
			LEFT JOIN [dbo].[Organizations] as [turn_org] WITH (NOLOCK)
				ON [AssignmentConsiderations].turn_organization_id = [turn_org].Id
			WHERE [Assignments].[executor_organization_id] IN (SELECT Id FROM @Organizations_is)
			or [AssignmentConsiderations].turn_organization_id IN (SELECT Id FROM @Organizations_is);


			CREATE NONCLUSTERED INDEX [NONCLUSTERED_INDEX_temp_AllAss]
			ON #temp_AllAss ([AssignmentResult_Code],[AssignmentType_Code],[AssignmentState_Code],[AssignmentResolution_Name])
			INCLUDE ([Id],[OrganizationsId],[turn_organization_id],[turn_organization_name]);
	
			CREATE NONCLUSTERED INDEX [NONCLUSTERED_INDEX_temp_AllAss_INCLUDE]
			ON #temp_AllAss ([AssignmentState_Code],[AssignmentType_Code],[control_date])
			INCLUDE ([Id],[OrganizationsId],[OrganizationsName],[registration_date]);

			-----------------основное-----
			IF OBJECT_ID('tempdb..#temp_nadiishlo') IS NOT NULL
			BEGIN
				DROP TABLE #temp_nadiishlo;
			END;
			SELECT
				Id
			   ,OrganizationsId
			   ,OrganizationsName 
			INTO #temp_nadiishlo
			FROM #temp_AllAss
			WHERE (
					([AssignmentType_Code] <> N'ToAttention'
						AND [AssignmentState_Code] = N'Registered'
					    AND [AssignmentResult_Name] = N'Очікує прийому в роботу')
					OR ([AssignmentResult_Code] = N'ReturnedToTheArtist'
						AND [AssignmentState_Code] = N'Registered')
				   )
			AND OrganizationsId in (SELECT Id FROM @Organizations_is);



			IF OBJECT_ID('tempdb..#temp_nevkomp') IS NOT NULL
			BEGIN
				DROP TABLE #temp_nevkomp;
			END;
			SELECT
				Id
			   ,turn_organization_id as OrganizationsId
			   ,turn_organization_name as OrganizationsName
			INTO #temp_nevkomp
			FROM #temp_AllAss
			WHERE [AssignmentType_Code] <> N'ToAttention'
			AND [AssignmentState_Code] <> N'Closed'
			AND [AssignmentResult_Code] = N'NotInTheCompetence'
			AND [AssignmentResolution_Name] IN (N'Повернуто в 1551', N'Повернуто в батьківську організацію')
			AND (CASE
				 	WHEN @role = N'Конролер' AND
				 		[AssignmentResolution_Name] = N'Повернуто в 1551' THEN 1
				 	WHEN @role <> N'Конролер' AND
				 		[AssignmentResolution_Name] = N'Повернуто в батьківську організацію' THEN 1
				 END) = 1
			AND turn_organization_id IN (SELECT Id FROM @Organizations_is)




			IF OBJECT_ID('tempdb..#temp_prostr') IS NOT NULL
			BEGIN
				DROP TABLE #temp_prostr;
			END;
			SELECT
				Id
			   ,OrganizationsId
			   ,OrganizationsName 
			INTO #temp_prostr
			FROM #temp_AllAss
			WHERE ([control_date] <= GETUTCDATE()
					AND [AssignmentType_Code] <> N'ToAttention'
					AND [AssignmentState_Code] = N'InWork')
			AND OrganizationsId IN (SELECT Id FROM @Organizations_is);
			




			IF OBJECT_ID('tempdb..#temp_uvaga') IS NOT NULL
			BEGIN
				DROP TABLE #temp_uvaga;
			END;
			SELECT
				Id
			   ,OrganizationsId
			   ,OrganizationsName 
			INTO #temp_uvaga
			FROM #temp_AllAss
			WHERE [control_date] >= GETUTCDATE()
			AND (DATEADD(MI, DATEDIFF(MI, [registration_date], [control_date]) * 0.25 * -1, [control_date]) < GETUTCDATE()
			AND [control_date] >= GETUTCDATE()
			AND [AssignmentType_Code] <> N'ToAttention'
			AND [AssignmentState_Code] = N'InWork')
			AND OrganizationsId IN (SELECT Id FROM @Organizations_is);



			IF OBJECT_ID('tempdb..#temp_vroboti') IS NOT NULL
			BEGIN
				DROP TABLE #temp_vroboti;
			END;
			SELECT
				Id
			   ,OrganizationsId
			   ,OrganizationsName 
			INTO #temp_vroboti
			FROM #temp_AllAss
			WHERE [control_date] >= GETUTCDATE()
			AND (DATEADD(MI, DATEDIFF(MI, [registration_date], [control_date]) * 0.75, [registration_date]) >= GETUTCDATE()
			AND [control_date] >= GETUTCDATE()
			AND [AssignmentType_Code] <> N'ToAttention'
			AND [AssignmentState_Code] = N'InWork')
			AND [OrganizationsId] IN (SELECT Id FROM @Organizations_is);


			IF OBJECT_ID('tempdb..#temp_dovidoma') IS NOT NULL
			BEGIN
				DROP TABLE #temp_dovidoma;
			END;
			SELECT
				Id
			   ,OrganizationsId
			   ,OrganizationsName 
			INTO #temp_dovidoma
			FROM #temp_AllAss
			WHERE [AssignmentType_Code] = N'ToAttention'
			AND [AssignmentState_Code] = N'Registered'
			AND [OrganizationsId] IN (SELECT Id FROM @Organizations_is);




			IF OBJECT_ID('tempdb..#temp_nadoopr') IS NOT NULL
			BEGIN
				DROP TABLE #temp_nadoopr;
			END;
			SELECT
				Id
			   ,OrganizationsId
			   ,OrganizationsName 
			INTO #temp_nadoopr
			FROM #temp_AllAss
			WHERE [AssignmentState_Code] = N'NotFulfilled'
				  AND ([AssignmentResult_Code] = N'ForWork'
				  OR [AssignmentResult_Code] = N'Actually')
			AND [OrganizationsId] IN (SELECT Id FROM @Organizations_is);



			IF OBJECT_ID('tempdb..#temp_plan_p') IS NOT NULL
			BEGIN
				DROP TABLE #temp_plan_p
			END;
			SELECT
				[Assignments].Id
			   ,[Organizations].Id OrganizationsId
			   ,[Organizations].short_name OrganizationsName INTO #temp_plan_p
			FROM [dbo].[Assignments] WITH (NOLOCK)
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
   ,OrganizationsId
   ,OrganizationsName INTO #temp_main
FROM #temp_nadiishlo
UNION ALL
SELECT
	Id
   ,N'neVKompetentsii' name
   ,OrganizationsId
   ,OrganizationsName
FROM #temp_nevkomp
UNION ALL
SELECT
	Id
   ,N'prostrocheni' name
   ,OrganizationsId
   ,OrganizationsName
FROM #temp_prostr
UNION ALL
SELECT
	Id
   ,N'uvaga' name
   ,OrganizationsId
   ,OrganizationsName
FROM #temp_uvaga
UNION ALL
SELECT
	Id
   ,N'vroboti' name
   ,OrganizationsId
   ,OrganizationsName
FROM #temp_vroboti
UNION ALL
SELECT
	Id
   ,N'dovidoma' name
   ,OrganizationsId
   ,OrganizationsName
FROM #temp_dovidoma
UNION ALL
SELECT
	Id 
   ,N'naDoopratsiyvanni' name
   ,OrganizationsId
   ,OrganizationsName
FROM #temp_nadoopr
UNION ALL
SELECT
	Id
   ,N'neVykonNeMozhl' name
   ,OrganizationsId
   ,OrganizationsName
FROM #temp_plan_p;





SELECT
	[OrganizationsId] [OrganizationId]
   ,[OrganizationsName] [OrganizationName]
   ,[nadiyshlo]
   ,[neVKompetentsii]
   ,[prostrocheni]
   ,[uvaga]
   ,[vroboti]
   ,[dovidoma]
   ,[naDoopratsiyvanni]
   ,[neVykonNeMozhl]
FROM #temp_main
PIVOT
(
COUNT(Id) FOR name IN ([nadiyshlo], [neVKompetentsii], [prostrocheni], [uvaga], [vroboti], [dovidoma], [naDoopratsiyvanni], [neVykonNeMozhl])
) pvt
ORDER BY [OrganizationsId];
	END
   
   ELSE 

	BEGIN
		SELECT 1 [OrganizationId]
   ,N'' [OrganizationName]
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
   
