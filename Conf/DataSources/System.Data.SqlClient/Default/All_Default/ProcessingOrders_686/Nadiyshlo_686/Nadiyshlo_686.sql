
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


	DECLARE @NavigationTable TABLE (
	Id NVARCHAR(40)
);

--set @navigations=case when @navigation=N'Усі' 

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


WITH main
AS
(SELECT
		[Assignments].Id
	   ,[Organizations].Id OrganizationsId
	   ,[Organizations].name OrganizationsName
	   ,[Applicants].full_name zayavnyk
	   ,ISNULL([Districts].name + N' р-н, ', N'')
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

	   ,[Applicants].Id zayavnykId
	   ,[Questions].Id QuestionId
	   ,[Organizations].short_name vykonavets
	   ,[Assignments].[registration_date]

	   ,[Applicants].[ApplicantAdress] zayavnyk_adress
	   ,[Questions].question_content zayavnyk_zmist
	   ,[Organizations2].Id [transfer_to_organization_id]
	   ,[Organizations2].[short_name] [transfer_to_organization_name]
	   ,[Assignments].[registration_date] ass_registration_date
	   ,[Organizations3].short_name balans_name
	   ,[Questions].control_date
	FROM [dbo].[Assignments]
	INNER JOIN [dbo].[AssignmentStates]
		ON [Assignments].assignment_state_id = [AssignmentStates].Id
	LEFT JOIN [dbo].[AssignmentTypes]
		ON [Assignments].assignment_type_id = [AssignmentTypes].Id
	INNER JOIN [dbo].[AssignmentResults]
		ON [Assignments].[AssignmentResultsId] = [AssignmentResults].Id -- +
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
		END =nt.Id

	LEFT JOIN [dbo].[AssignmentConsiderations]
		ON [Assignments].[current_assignment_consideration_id] = [AssignmentConsiderations].Id
	LEFT JOIN [dbo].[AssignmentResolutions]
		ON [Assignments].[AssignmentResolutionsId] = [AssignmentResolutions].Id
	LEFT JOIN [dbo].[Organizations]
		ON [Assignments].executor_organization_id = [Organizations].Id
	LEFT JOIN [dbo].[Objects]
		ON [Questions].[object_id] = [Objects].Id
	LEFT JOIN [dbo].[Buildings]
		ON [Objects].builbing_id = [Buildings].Id
	LEFT JOIN [dbo].[Streets]
		ON [Buildings].street_id = [Streets].Id
	LEFT JOIN [dbo].[Applicants]
		ON [Appeals].applicant_id = [Applicants].Id
	LEFT JOIN [dbo].[StreetTypes]
		ON [Streets].street_type_id = [StreetTypes].Id
	LEFT JOIN [dbo].[Districts]
		ON [Buildings].district_id = [Districts].Id
	LEFT JOIN [dbo].[Organizations] [Organizations2]
		ON [AssignmentConsiderations].[transfer_to_organization_id] = [Organizations2].Id
	LEFT JOIN (SELECT
			[building_id]
		   ,[executor_id]
		FROM [dbo].[ExecutorInRoleForObject]
		WHERE [executor_role_id] = 1 /*Балансоутримувач*/) balans
		ON [Buildings].Id = balans.building_id

	LEFT JOIN [dbo].[Organizations] [Organizations3]
		ON balans.executor_id = [Organizations3].Id
	
	--left join [dbo].[AssignmentRevisions] on [AssignmentResolutions].Id=[AssignmentRevisions].assignment_resolution_id
	WHERE --[Assignments].[executor_organization_id] = @organization_id AND
	 
	(([AssignmentTypes].code <> N'ToAttention'
	AND [AssignmentStates].code = N'Registered'
	AND [AssignmentResults].[name] = N'Очікує прийому в роботу')
	OR ([AssignmentResults].code = N'ReturnedToTheArtist'
	AND [AssignmentStates].code = N'Registered'))

	AND ((tpuo.organizations_id IS NOT NULL AND [Assignments].executor_person_id IS NULL)
	OR (tpuop.position_id IS NOT NULL))
	--
--then 1 else 0 end =1
)


SELECT /*ROW_NUMBER() over(order by registration_number)*/
	main.Id
   ,navigation
   ,registration_number
   ,QuestionType
   ,zayavnyk
   ,adress
   ,vykonavets
   ,zayavnykId
   ,QuestionId
   ,zayavnyk_adress
   ,zayavnyk_zmist
   ,[transfer_to_organization_id]
   ,[transfer_to_organization_name]
   ,ass_registration_date
   ,balans_name
   ,control_date
FROM main
ORDER BY [registration_date]

END

ELSE

BEGIN
SELECT 1 Id
   ,NULL navigation
   ,NULL registration_number
   ,NULL QuestionType
   ,NULL zayavnyk
   ,NULL adress
   ,NULL vykonavets
   ,NULL zayavnykId
   ,NULL QuestionId
   ,NULL zayavnyk_adress
   ,NULL zayavnyk_zmist
   ,NULL [transfer_to_organization_id]
   ,NULL [transfer_to_organization_name]
   ,NULL ass_registration_date
   ,NULL balans_name
   ,NULL control_date
WHERE 1=2
END