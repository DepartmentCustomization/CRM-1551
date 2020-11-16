--   DECLARE @user_id NVARCHAR(128) = N'871e2902-8915-4a07-95af-101c05092dab';

IF OBJECT_ID('tempdb..#temp_all') IS NOT NULL 
BEGIN
	DROP TABLE #temp_all;
END

DECLARE @role NVARCHAR(500) = (
	SELECT
		[Roles].[name]
	FROM
		[dbo].[Positions] [Positions]
		LEFT JOIN [dbo].[Roles] [Roles] ON [Positions].role_id = [Roles].Id 
	WHERE
		[Positions].programuser_id = @user_id
);

SELECT
	N'УГЛ' navigation,
	ISNULL(SUM(count_nevkomp), 0) [neVKompetentsii],
	ISNULL(SUM(count_doopr), 0) [doopratsiovani],
	ISNULL(SUM(count_rozyasn), 0) [rozyasneno],
	ISNULL(SUM(count_vykon), 0) [vykon],
	ISNULL(SUM(count_prostr), 0) [prostrocheni],
	ISNULL(SUM(count_plan_prog), 0) [neVykonNeMozhl] INTO #temp_all
FROM
	(
		SELECT
			[Assignments].Id,
			N'УГЛ' navigation,
			CASE
				WHEN [AssignmentStates].code IN ('Registered', N'OnCheck')
				AND AssignmentResults.code = (N'NotInTheCompetence')
				AND [ReceiptSources].code = N'UGL' THEN 1
				ELSE 0
			END count_nevkomp,
			CASE
				WHEN [AssignmentStates].code = N'OnCheck'
				AND [AssignmentResults].code = N'WasExplained '
				AND [AssignmentResolutions].code = N'Requires1551ChecksByTheController'
				AND [AssignmentRevisions].rework_counter IN (1, 2)
				AND [ReceiptSources].code = N'UGL' THEN 1
				ELSE 0
			END count_doopr,
			CASE
				WHEN [AssignmentTypes].code <> N'ToAttention'
				AND [AssignmentStates].code = N'OnCheck'
				AND [AssignmentResults].code = N'WasExplained '
				AND [AssignmentResolutions].code = N'Requires1551ChecksByTheController'
				AND [ReceiptSources].code = N'UGL' THEN 1
				ELSE 0
			END count_rozyasn,
			CASE
				WHEN [AssignmentTypes].code <> N'ToAttention'
				AND [AssignmentStates].code = N'OnCheck'
				AND [AssignmentResults].code = N'WasExplained '
				AND [AssignmentResolutions].code = N'Requires1551ChecksByTheController'
				AND [Questions].control_date <= getutcdate()
				AND [ReceiptSources].code = N'UGL' THEN 1
				ELSE 0
			END count_prostr,
			CASE
				WHEN [AssignmentStates].code = N'OnCheck'
				AND [AssignmentResults].code = N'ItIsNotPossibleToPerformThisPeriod'
				AND [AssignmentResolutions].code = N'RequiresFunding_IncludedInThePlan'
				AND [ReceiptSources].code = N'UGL' THEN 1
				ELSE 0
			END count_plan_prog,
			CASE
				WHEN [AssignmentStates].code = N'OnCheck'
				AND [AssignmentResults].code = N'Done'
				AND [ReceiptSources].code = N'UGL' THEN 1
				ELSE 0
			END count_vykon
		FROM
			[dbo].[Assignments] [Assignments] WITH (nolock)
			INNER JOIN [dbo].[AssignmentStates] [AssignmentStates] ON [Assignments].assignment_state_id = [AssignmentStates].Id
			INNER JOIN [dbo].[AssignmentResults] [AssignmentResults] ON [Assignments].[AssignmentResultsId] = [AssignmentResults].Id -- +
			LEFT JOIN [dbo].[AssignmentConsiderations] [AssignmentConsiderations] WITH (nolock) ON [Assignments].current_assignment_consideration_id = [AssignmentConsiderations].Id
			LEFT JOIN [dbo].[AssignmentResolutions] [AssignmentResolutions] WITH (nolock) ON [Assignments].[AssignmentResolutionsId] = [AssignmentResolutions].Id
			INNER JOIN [dbo].[AssignmentTypes] [AssignmentTypes] ON [Assignments].assignment_type_id = [AssignmentTypes].Id
			INNER JOIN [dbo].[Questions] [Questions] WITH (nolock) ON [Assignments].question_id = [Questions].Id
			INNER JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Questions].appeal_id = [Appeals].Id
			INNER JOIN [dbo].[ReceiptSources] [ReceiptSources] ON [Appeals].receipt_source_id = [ReceiptSources].Id
			LEFT JOIN [dbo].[AssignmentRevisions] [AssignmentRevisions] WITH (nolock) ON [AssignmentConsiderations].Id = [AssignmentRevisions].assignment_consideration_іd
		WHERE
			[AssignmentStates].code <> N'Closed'  
			AND AssignmentResults.code IN (N'NotInTheCompetence', N'WasExplained ', N'ItIsNotPossibleToPerformThisPeriod', N'Done')
			AND [ReceiptSources].code = N'UGL'
	) t;
SELECT
	1 Id,
	N'УГЛ' navigation,
	[neVKompetentsii],
	[doopratsiovani],
	[rozyasneno],
	[vykon],
	[prostrocheni],
	[neVykonNeMozhl]
FROM
	#temp_all
UNION
ALL
SELECT
	7 Id,
	N'Сума' navigation,
	[neVKompetentsii],
	[doopratsiovani],
	[rozyasneno],
	[vykon],
	[prostrocheni],
	[neVykonNeMozhl]
FROM
	#temp_all;