/*
DECLARE @user_id NVARCHAR(128) = N'cd01fea0-760c-4b66-9006-152e5b2a87e9';
DECLARE @organization_id INT = 2008;
DECLARE @navigation NVARCHAR(40) = N'Усі';
 */

IF EXISTS (SELECT orr.*
  FROM [dbo].[OrganizationInResponsibilityRights] orr
  INNER JOIN dbo.Positions p ON orr.position_id=P.Id
  WHERE orr.organization_id=@organization_Id 
  AND P.programuser_id=@user_id)

	BEGIN
		DECLARE @NavigationTable TABLE (
	Id NVARCHAR(400)
);

IF @navigation = N'Усі'
BEGIN
	INSERT INTO @NavigationTable (Id)
		SELECT
			N'Інші доручення' n
		UNION ALL
		SELECT
			N'УГЛ' n
		UNION ALL
		SELECT
			N'Зауваження' n
		UNION ALL
		SELECT
			N'Електронні джерела' n
		UNION ALL
		SELECT
			N'Пріоритетне';
END
ELSE
BEGIN
	INSERT INTO @NavigationTable (Id)
		SELECT
			@navigation;
END;

IF OBJECT_ID('tempdb..#temp_positions_user') IS NOT NULL
			BEGIN
				DROP TABLE #temp_positions_user;
			END;

  --пункт1 подивився до яких посад має відношення користувач
  SELECT *
  INTO #temp_positions_user
  FROM
  (SELECT p.Id, [is_main], organizations_id
  FROM [dbo].[Positions] p
  WHERE p.[programuser_id]=@user_id
  UNION 
  SELECT p2.Id, p2.is_main, p2.organizations_id
  FROM [dbo].[Positions] p
  INNER JOIN [dbo].[PositionsHelpers] ph ON p.Id=ph.main_position_id
  INNER JOIN [dbo].[Positions] p2 ON ph.helper_position_id=p2.Id
  WHERE p.[programuser_id]=@user_id
  UNION 
  SELECT p2.Id, p2.is_main, p2.organizations_id
  FROM [dbo].[Positions] p
  INNER JOIN [dbo].[PositionsHelpers] ph ON p.Id=ph.helper_position_id
  INNER JOIN [dbo].[Positions] p2 ON ph.main_position_id=p2.Id
  WHERE p.[programuser_id]=@user_id) t

  --select * from #temp_positions_user

  -- создадим временную табличку для п2
  IF OBJECT_ID('tempdb..#tpu_organization') IS NOT NULL
			BEGIN
				DROP TABLE #tpu_organization;
			END;


  SELECT DISTINCT organizations_id
  INTO #tpu_organization
  FROM #temp_positions_user
  WHERE is_main='true' AND organizations_id=@organization_Id
  
  --SELECT * FROM #tpu_organization

  -- создадим временную табличку для п3
  IF OBJECT_ID('tempdb..#tpu_position') IS NOT NULL
			BEGIN
				DROP TABLE #tpu_position;
			END;


  SELECT DISTINCT Id position_id
  INTO #tpu_position
  FROM #temp_positions_user;

  --SELECT * FROM #tpu_position;

WITH main
AS
(SELECT
		[Assignments].Id
	   ,[Organizations].Id OrganizationsId
	   ,[Organizations].name OrganizationsName
	   ,[Applicants].full_name zayavnyk
	   ,
		--[StreetTypes].shortname+N' '+Streets.name+N', '+[Buildings].name adress, 
		ISNULL([Districts].name + N' р-н, ', N'')
		+ ISNULL([StreetTypes].shortname, N'')
		+ ISNULL([Streets].name, N'')
		+ ISNULL(N', ' + [Buildings].name, N'')
		+ ISNULL(N', п. ' + [Questions].[entrance], N'')
		+ ISNULL(N', кв. ' + [Questions].flat, N'') adress
	   ,[Questions].registration_number
	   ,[QuestionTypes].name QuestionType
	   ,CASE
			WHEN [ReceiptSources].code = N'UGL' THEN N'УГЛ'
			WHEN [ReceiptSources].code = N'Website_mob.addition' THEN N'Електронні джерела'
			WHEN [QuestionTypes].emergency = N'true' THEN N'Пріоритетне'
			WHEN [QuestionTypes].parent_organization_is = N'true' THEN N'Зауваження'
			ELSE N'Інші доручення'
		END navigation
	   /*,CASE
			WHEN [AssignmentTypes].code = N'ToAttention' AND
				[AssignmentStates].code = N'Registered' THEN 1
			ELSE 0
		END dovidima
	   ,*/
	   ,1 dovidima,
		/*
	    case when [AssignmentStates].code=N'NotFulfilled' and [AssignmentResults].code=N'ForWork' then 1 else 0 end naDoopratsiyvanni,
	    case when [AssignmentStates].code=N'NotFulfilled' and [AssignmentResults].code=N'ItIsNotPossibleToPerformThisPeriod' then 1 else 0 end neVykonNeMozhl,
	    null NotUse,*/[Applicants].Id zayavnykId
	   ,[Questions].Id QuestionId
	   ,[Applicants].[ApplicantAdress] zayavnyk_adress
	   ,[Questions].question_content zayavnyk_zmist
	   ,[Organizations3].short_name balans_name

	FROM [dbo].[Assignments]
	INNER JOIN [dbo].[AssignmentStates]
		ON [Assignments].assignment_state_id = [AssignmentStates].Id
	LEFT JOIN [dbo].[AssignmentTypes]
		ON [Assignments].assignment_type_id = [AssignmentTypes].Id
	--
	LEFT JOIN #tpu_organization tpuo 
	ON [Assignments].executor_organization_id=tpuo.organizations_id
	LEFT JOIN #tpu_position tpuop 
	ON [Assignments].executor_person_id=tpuop.position_id
	--
	INNER JOIN [dbo].[Questions]
		ON [Assignments].question_id = [Questions].Id
	INNER JOIN [dbo].[Appeals]
		ON [Questions].appeal_id = [Appeals].Id
	INNER JOIN [dbo].[ReceiptSources]
		ON [Appeals].receipt_source_id = [ReceiptSources].Id
	LEFT JOIN [dbo].[QuestionTypes]
		ON [Questions].question_type_id = [QuestionTypes].Id

	INNER JOIN @NavigationTable nt 
		ON CASE
			WHEN [ReceiptSources].code = N'UGL' THEN N'УГЛ'
			WHEN [ReceiptSources].code = N'Website_mob.addition' THEN N'Електронні джерела'
			WHEN [QuestionTypes].emergency = N'true' THEN N'Пріоритетне'
			WHEN [QuestionTypes].parent_organization_is = N'true' THEN N'Зауваження'
			ELSE N'Інші доручення'
		END=nt.Id

	--left join [dbo].[AssignmentConsiderations] on [Assignments].Id=[AssignmentConsiderations].assignment_id
	LEFT JOIN [dbo].[AssignmentResults]
		ON [Assignments].[AssignmentResultsId] = [AssignmentResults].Id -- +
	--LEFT JOIN [dbo].[AssignmentResolutions]
	--	ON [Assignments].[AssignmentResolutionsId] = [AssignmentResolutions].Id
	LEFT JOIN [dbo].[Organizations]
		ON [Assignments].executor_organization_id = [Organizations].Id
	LEFT JOIN [dbo].[Objects]
		ON [Questions].[object_id] = [Objects].Id
	LEFT JOIN [dbo].[Buildings]
		ON [Objects].builbing_id = [Buildings].Id
	LEFT JOIN [dbo].[Streets]
		ON [Buildings].street_id = [Streets].Id
	LEFT JOIN [dbo].[StreetTypes]
		ON [Streets].street_type_id = [StreetTypes].Id
	LEFT JOIN [dbo].[Applicants]
		ON [Appeals].applicant_id = [Applicants].Id
	LEFT JOIN [dbo].[Districts]
		ON [Buildings].district_id = [Districts].Id

	LEFT JOIN (SELECT
			[building_id]
		   ,[executor_id]
		FROM [dbo].[ExecutorInRoleForObject]
		WHERE [executor_role_id] = 1 /*Балансоутримувач*/) balans
		ON [Buildings].Id = balans.building_id

	LEFT JOIN [dbo].[Organizations] [Organizations3]
		ON balans.executor_id = [Organizations3].Id
	
	--left join [dbo].[AssignmentRevisions] on [AssignmentResolutions].Id=[AssignmentRevisions].assignment_resolution_id
	WHERE 
	[AssignmentStates].code = N'Registered' AND
	[AssignmentTypes].code = N'ToAttention' AND

	--[Assignments].[executor_organization_id] = @organization_id
 ((tpuo.organizations_id IS NOT NULL AND [Assignments].executor_person_id IS NULL)
OR (tpuop.position_id IS NOT NULL))
)
/*,
nav
AS
(SELECT
		1 Id
	   ,N'УГЛ' name
	UNION ALL
	SELECT
		2 Id
	   ,N'Електронні джерела' name
	UNION ALL
	SELECT
		3 Id
	   ,N'Пріоритетне' name
	UNION ALL
	SELECT
		4 Id
	   ,N'Інші доручення' name
	UNION ALL
	SELECT
		5 Id
	   ,N'Зауваження' name)
	   */
SELECT
	Id
   ,registration_number
   ,QuestionType
   ,zayavnyk
   ,adress
   ,zayavnykId
   ,QuestionId--, null vykonavets
   ,zayavnyk_adress
   ,zayavnyk_zmist
   ,balans_name
FROM main;
	END

ELSE
	
	BEGIN
	SELECT
	1 Id
   , NULL registration_number
   , NULL QuestionType
   , NULL zayavnyk
   , NULL adress
   , NULL zayavnykId
   , NULL QuestionId
   , NULL zayavnyk_adress
   , NULL zayavnyk_zmist
   , NULL balans_name
   WHERE 1=3;
	END
