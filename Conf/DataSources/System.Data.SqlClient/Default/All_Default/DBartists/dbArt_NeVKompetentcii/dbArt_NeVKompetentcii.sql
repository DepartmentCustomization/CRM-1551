/*
DECLARE @user_id NVARCHAR(128) = N'  ';--= N'c8848a30-38ec-459b-aeaa-db906f3bc141';
DECLARE @organization_id INT = 1762;
DECLARE @navigation NVARCHAR(40) = N'Електронні джерела';
 */

IF EXISTS 
--(SELECT orr.*
--  FROM [dbo].[OrganizationInResponsibilityRights] orr
--  INNER JOIN dbo.Positions p ON orr.position_id=P.Id
--  WHERE orr.organization_id=@organization_Id 
--  AND P.programuser_id=@user_id)
  (SELECT p.*
  FROM [dbo].[Positions] p
  LEFT JOIN [dbo].[PositionsHelpers] pm ON p.Id=pm.main_position_id
  LEFT JOIN [dbo].[PositionsHelpers] ph on p.Id=ph.helper_position_id
  WHERE p.[programuser_id]=@user_id
  AND (pm.main_position_id IS NOT NULL OR ph.helper_position_id IS NOT NULL))

	BEGIN

	IF object_id('tempdb..#user_organizations') IS NOT NULL DROP TABLE #user_organizations

  SELECT r.[name] role_name, p.Id position_id, p.organizations_id, p.programuser_id
  INTO #user_organizations
  FROM [dbo].[Positions] p
  LEFT JOIN [dbo].[Roles] r ON p.role_id=r.Id
  WHERE p.programuser_id=@user_id

	--	DECLARE @role NVARCHAR(500) = (SELECT
	--	[Roles].name
	--FROM [dbo].[Positions]
	--LEFT JOIN [dbo].[Roles]
	--	ON [Positions].role_id = [Roles].Id
	--WHERE [Positions].programuser_id = @user_id);

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
			N'Пріоритетне'
END
ELSE
BEGIN
	INSERT INTO @NavigationTable (Id)
		SELECT
			@navigation
END;

--пункт 2 права
if object_id('tempdb..#organizations_rights') IS NOT NULL DROP TABLE #organizations_rights

SELECT DISTINCT r.organization_id
INTO #organizations_rights
  FROM [dbo].[Positions] p
  INNER JOIN [dbo].[OrganizationInResponsibilityRights] r ON p.organizations_id=r.organization_id AND p.Id=r.position_id
  WHERE p.programuser_id=@user_id

IF OBJECT_ID('tempdb..#temp_positions_user') IS NOT NULL
			BEGIN
				DROP TABLE #temp_positions_user;
			END;

  --пункт1 подивився до яких посад має відношення користувач #temp_positions_user
  /* версия 1 начало
  SELECT *
  INTO #temp_positions_user
  FROM
  (SELECT p.Id, [is_main], organizations_id, r.name role_name
  FROM [dbo].[Positions] p
  LEFT JOIN [dbo].[Roles] r ON p.role_id=r.Id 
  WHERE p.[programuser_id]=@user_id
  UNION 
  SELECT p2.Id, p2.is_main, p2.organizations_id, r.name role_name
  FROM [dbo].[Positions] p
  INNER JOIN [dbo].[PositionsHelpers] ph ON p.Id=ph.main_position_id
  INNER JOIN [dbo].[Positions] p2 ON ph.helper_position_id=p2.Id
  LEFT JOIN [dbo].[Roles] r ON p2.role_id=r.Id
  WHERE p.[programuser_id]=@user_id
  UNION 
  SELECT p2.Id, p2.is_main, p2.organizations_id, r.name role_name
  FROM [dbo].[Positions] p
  INNER JOIN [dbo].[PositionsHelpers] ph ON p.Id=ph.helper_position_id
  INNER JOIN [dbo].[Positions] p2 ON ph.main_position_id=p2.Id
  LEFT JOIN [dbo].[Roles] r ON p2.role_id=r.Id
  WHERE p.[programuser_id]=@user_id) t
версия1 конец*/
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
select p.id, p.position, p.organizations_id, r.name role_name
INTO #temp_positions_user
from [dbo].[Positions] p
left join [dbo].[Roles] r on p.role_id=r.id
where organizations_id IN
(
select organizations_id
from [dbo].[Positions]
where programuser_id=@user_id)
  --select * from #temp_positions_user --ок
  --end

  -- создадим временную табличку для п2
  IF OBJECT_ID('tempdb..#tpu_organization') IS NOT NULL
			BEGIN
				DROP TABLE #tpu_organization;
			END;


  SELECT DISTINCT organizations_id
  INTO #tpu_organization
  FROM #temp_positions_user;
  --WHERE is_main='true' AND organizations_id=@organization_Id
  
  --SELECT * FROM #tpu_organization

  -- создадим временную табличку для п3
  --IF OBJECT_ID('tempdb..#tpu_position') IS NOT NULL
		--	BEGIN
		--		DROP TABLE #tpu_position;
		--	END;


  --SELECT DISTINCT Id position_id
  --INTO #tpu_position
  --FROM #temp_positions_user;

  --SELECT * FROM #tpu_position;
  --SELECT DISTINCT organizations_id, role_name FROM #temp_positions_user;

WITH main
AS
(SELECT DISTINCT
		[Assignments].Id
	   ,CASE
			WHEN [ReceiptSources].code = N'UGL' THEN N'УГЛ'
			WHEN [ReceiptSources].code = N'Website_mob.addition' THEN N'Електронні джерела'
			WHEN [QuestionTypes].emergency = N'true' THEN N'Пріоритетне'
			WHEN [QuestionTypes].parent_organization_is = N'true' THEN N'Зауваження'
			ELSE N'Інші доручення'
		END navigation
	   ,[Questions].registration_number
	   ,[QuestionTypes].name QuestionType
	   ,[Applicants].full_name zayavnyk
	   ,[StreetTypes].shortname + N' ' + Streets.name + N', ' + [Buildings].name adress_place
	   ,[Organizations].name pidlegliy
	   ,[Applicants].Id zayavnikId
	   ,[Questions].Id QuestionId
	   ,[Assignments].Id AS Id2
	   ,[Applicants].[ApplicantAdress] zayavnyk_adress
	   ,[Questions].question_content zayavnyk_zmist
	   ,[AssignmentConsiderations].short_answer comment
	   ,[Organizations2].Id [transfer_to_organization_id]
	   ,[Organizations2].[short_name] [transfer_to_organization_name]
	   ,STUFF((SELECT
				N', ' + [Organizations].short_name
			FROM [dbo].[ExecutorInRoleForObject]
			INNER JOIN [dbo].[Organizations]
				ON [ExecutorInRoleForObject].executor_id = [Organizations].Id
			WHERE [ExecutorInRoleForObject].object_id = [Buildings].Id--ex.building_id
			AND [executor_role_id] = 1 /*Балансоутримувач*/
			FOR XML PATH (''))
		, 1, 2, N'') balans_name
		,CASE WHEN o_rights.organization_id IS NOT NULL THEN 'true' ELSE 'false' END [is_rights]
	--,[Organizations3].short_name balans_name
	FROM [dbo].[Assignments]
	INNER JOIN [dbo].[AssignmentStates]
		ON [Assignments].assignment_state_id = [AssignmentStates].Id
	INNER JOIN [dbo].[AssignmentResults]
		ON [Assignments].[AssignmentResultsId] = [AssignmentResults].Id -- +
	INNER JOIN [dbo].[AssignmentResolutions]
		ON [Assignments].[AssignmentResolutionsId] = [AssignmentResolutions].Id
	INNER JOIN [dbo].[AssignmentTypes]
		ON [Assignments].assignment_type_id = [AssignmentTypes].Id
	LEFT JOIN [dbo].[AssignmentConsiderations]
		ON [Assignments].current_assignment_consideration_id = [AssignmentConsiderations].Id

	INNER JOIN (SELECT DISTINCT organizations_id, role_name FROM #temp_positions_user where Id=@organization_id) uo 
		ON [AssignmentConsiderations].turn_organization_id=uo.organizations_id
	--
	--LEFT JOIN #tpu_organization tpuo 
	--	--ON [Assignments].executor_organization_id=tpuo.organizations_id
	--	ON [AssignmentConsiderations].turn_organization_id=tpuo.organizations_id
	--LEFT JOIN #tpu_position tpuop 
	--	ON [Assignments].executor_person_id=tpuop.position_id
	--INNER JOIN #user_organizations uo 
	--	ON [AssignmentConsiderations].turn_organization_id=uo.organizations_id
	--
	INNER JOIN [dbo].[Questions]
		ON [Assignments].question_id = [Questions].Id	
	LEFT JOIN [dbo].[QuestionTypes]
		ON [Questions].question_type_id = [QuestionTypes].Id
	INNER JOIN [dbo].[Appeals]
		ON [Questions].appeal_id = [Appeals].Id
	INNER JOIN [dbo].[ReceiptSources]
		ON [Appeals].receipt_source_id = [ReceiptSources].Id
	
	INNER JOIN @NavigationTable nt 
		ON CASE
			WHEN [ReceiptSources].code = N'UGL' THEN N'УГЛ'
			WHEN [ReceiptSources].code = N'Website_mob.addition' THEN N'Електронні джерела'
			WHEN [QuestionTypes].emergency = N'true' THEN N'Пріоритетне'
			WHEN [QuestionTypes].parent_organization_is = N'true' THEN N'Зауваження'
			ELSE N'Інші доручення'
		END=nt.Id
	-- left join [dbo].[AssignmentConsiderations] on [Assignments].Id=[AssignmentConsiderations].assignment_id	
	LEFT JOIN [dbo].[Objects]
		ON [Questions].[object_id] = [Objects].Id
	LEFT JOIN [dbo].[Applicants]
		ON [Appeals].applicant_id = [Applicants].Id
	LEFT JOIN [dbo].[Organizations]
		ON [Assignments].executor_organization_id = [Organizations].Id
	LEFT JOIN [dbo].[Buildings]
		ON [Objects].builbing_id = [Buildings].Id
	LEFT JOIN [dbo].[Streets]
		ON [Buildings].street_id = [Streets].Id
	LEFT JOIN [dbo].[StreetTypes]
		ON [Streets].street_type_id = [StreetTypes].Id
	LEFT JOIN [dbo].[Organizations] [Organizations2]
		ON [AssignmentConsiderations].[transfer_to_organization_id] = [Organizations2].Id
	LEFT JOIN #organizations_rights o_rights 
		ON [Assignments].executor_organization_id=o_rights.organization_id
	
	WHERE
	[AssignmentTypes].code <> N'ToAttention'
	AND [AssignmentStates].code <> N'Closed'
	AND [AssignmentResults].code = N'NotInTheCompetence'
	AND [AssignmentResolutions].name IN (N'Повернуто в 1551', N'Повернуто в батьківську організацію')
	--AND (CASE
	--	WHEN @role = N'Конролер' AND
	--		[AssignmentResolutions].name = N'Повернуто в 1551' THEN 1
	--	WHEN @role <> N'Конролер' AND
	--		[AssignmentResolutions].name = N'Повернуто в батьківську організацію' THEN 1
	--END) = 1
	AND (CASE
	WHEN uo.role_name = N'Конролер' AND
		[AssignmentResolutions].name = N'Повернуто в 1551' THEN 1
	WHEN ISNULL(uo.role_name, N'')  <> N'Конролер' AND
		[AssignmentResolutions].name = N'Повернуто в батьківську організацію' THEN 1
END) = 1
	--AND [AssignmentConsiderations].turn_organization_id = @organization_id
	--AND ((tpuo.organizations_id IS NOT NULL AND [Assignments].executor_person_id IS NULL)
	--OR (tpuop.position_id IS NOT NULL))
	)

SELECT
	Id
   ,navigation
   ,registration_number
   ,QuestionType
   ,zayavnyk
   ,adress_place
   ,pidlegliy
   ,zayavnikId
   ,QuestionId
   ,Id2
   ,zayavnyk_adress
   ,zayavnyk_zmist
   ,comment
   ,[transfer_to_organization_id]
   ,[transfer_to_organization_name]
   ,[balans_name]
   ,[is_rights]
FROM main;
	END

ELSE
	
	BEGIN
		SELECT
	1 Id
   ,NULL navigation
   ,NULL registration_number
   ,NULL QuestionType
   ,NULL zayavnyk
   ,NULL adress_place
   ,NULL pidlegliy
   ,NULL zayavnikId
   ,NULL QuestionId
   ,NULL Id2
   ,NULL zayavnyk_adress
   ,NULL zayavnyk_zmist
   ,NULL comment
   ,NULL [transfer_to_organization_id]
   ,NULL [transfer_to_organization_name]
   ,NULL [balans_name]
   ,NULL [is_rights]
   WHERE 1=3;
	END