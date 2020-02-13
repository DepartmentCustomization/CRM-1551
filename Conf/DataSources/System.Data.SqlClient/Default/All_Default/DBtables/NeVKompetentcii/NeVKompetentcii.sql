/*
 declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
 declare @organization_id int =4013;
 declare @navigation nvarchar(400)=N'Усі';
 */

IF EXISTS (SELECT orr.*
  FROM [dbo].[OrganizationInResponsibilityRights] orr
  INNER JOIN dbo.Positions p ON orr.position_id=P.Id
  WHERE orr.organization_id=@organization_Id 
  AND P.programuser_id=@user_id)

	BEGIN
		DECLARE @role NVARCHAR(500) = (SELECT
		[Roles].name
	FROM [dbo].[Positions]
	LEFT JOIN [dbo].[Roles]
		ON [Positions].role_id = [Roles].Id
	WHERE [Positions].programuser_id = @user_id);

DECLARE @Organization TABLE (
	Id INT
);


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


DECLARE @OrganizationId INT =
CASE
	WHEN @organization_id IS NOT NULL THEN @organization_id
	ELSE (SELECT
				Id
			FROM [dbo].[Organizations]
			WHERE Id IN (SELECT
					organization_id
				FROM [dbo].[Workers]
				WHERE worker_user_id = @user_id))
END


DECLARE @IdT TABLE (
	Id INT
);

-- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
INSERT INTO @IdT (Id)
	SELECT
		Id
	FROM [dbo].[Organizations]
	WHERE (Id = @OrganizationId
	OR [parent_organization_id] = @OrganizationId)
	AND Id NOT IN (SELECT
			Id
		FROM @IdT);

--  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
WHILE (SELECT
		COUNT(Id)
	FROM (SELECT
			Id
		FROM [dbo].[Organizations]
		WHERE [parent_organization_id] IN (SELECT
				Id
			FROM @IdT) --or Id in (select Id from @IdT)
		AND Id NOT IN (SELECT
				Id
			FROM @IdT)) q)
!= 0
BEGIN

INSERT INTO @IdT
	SELECT
		Id
	FROM [dbo].[Organizations]
	WHERE [parent_organization_id] IN (SELECT
			Id
		FROM @IdT) --or Id in (select Id from @IdT)
	AND Id NOT IN (SELECT
			Id
		FROM @IdT);
END

INSERT INTO @Organization (Id)
	SELECT
		Id
	FROM @IdT;

WITH main
AS
(SELECT
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

	--,[Organizations3].short_name balans_name
	FROM [dbo].[Assignments]
	LEFT JOIN [dbo].[Questions]
		ON [Assignments].question_id = [Questions].Id
	LEFT JOIN [dbo].[Appeals]
		ON [Questions].appeal_id = [Appeals].Id
	LEFT JOIN [dbo].[ReceiptSources]
		ON [Appeals].receipt_source_id = [ReceiptSources].Id
	LEFT JOIN [dbo].[QuestionTypes]
		ON [Questions].question_type_id = [QuestionTypes].Id
	LEFT JOIN [dbo].[AssignmentTypes]
		ON [Assignments].assignment_type_id = [AssignmentTypes].Id
	LEFT JOIN [dbo].[AssignmentStates]
		ON [Assignments].assignment_state_id = [AssignmentStates].Id
	-- left join [dbo].[AssignmentConsiderations] on [Assignments].Id=[AssignmentConsiderations].assignment_id
	LEFT JOIN [dbo].[AssignmentConsiderations]
		ON [Assignments].current_assignment_consideration_id = [AssignmentConsiderations].Id
	LEFT JOIN [dbo].[AssignmentResults]
		ON [Assignments].[AssignmentResultsId] = [AssignmentResults].Id -- +
	LEFT JOIN [dbo].[AssignmentResolutions]
		ON [Assignments].[AssignmentResolutionsId] = [AssignmentResolutions].Id
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

	WHERE [AssignmentTypes].code <> N'ToAttention'
	AND [AssignmentStates].code <> N'Closed'
	AND [AssignmentResults].code = N'NotInTheCompetence'
	AND [AssignmentResolutions].name IN (N'Повернуто в 1551', N'Повернуто в батьківську організацію')
	AND (CASE
		WHEN @role = N'Конролер' AND
			[AssignmentResolutions].name = N'Повернуто в 1551' THEN 1
		WHEN @role <> N'Конролер' AND
			[AssignmentResolutions].name = N'Повернуто в батьківську організацію' THEN 1
	END) = 1

	AND [AssignmentConsiderations].turn_organization_id = @organization_id)

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
FROM main
WHERE navigation IN (SELECT
		Id
	FROM @NavigationTable);
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
   WHERE 1=3;
	END