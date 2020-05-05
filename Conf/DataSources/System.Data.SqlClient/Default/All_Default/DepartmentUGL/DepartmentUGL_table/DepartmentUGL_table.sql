  --declare @user_id nvarchar(128)=N'29796543-b903-48a6-9399-4840f6eac396';

  IF OBJECT_ID('tempdb..#temp_all') IS NOT NULL
BEGIN
	DROP TABLE #temp_all
END;
  
  declare @role nvarchar(500)=
  (select [Roles].name
  from [Positions]
  left join [Roles] on [Positions].role_id=[Roles].Id
  where [Positions].programuser_id=@user_id);


SELECT 
N'УГЛ' navigation,
ISNULL(SUM(count_nevkomp), 0) [neVKompetentsii], 
ISNULL(SUM(count_doopr), 0) [doopratsiovani],
ISNULL(SUM(count_rozyasn), 0) [rozyasneno], 
ISNULL(SUM(count_vykon), 0) [vykon], 
ISNULL(SUM(count_prostr), 0) [prostrocheni], 
ISNULL(SUM(count_plan_prog), 0) [neVykonNeMozhl]
INTO #temp_all
FROM
(
select [Assignments].Id, --[Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName,
N'УГЛ' navigation, 
CASE WHEN 
		  [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code<>N'Closed' and [AssignmentResults].code=N'NotInTheCompetence'
		  and [AssignmentResolutions].name in (N'Повернуто в 1551', N'Повернуто в батьківську організацію') 
		  and [AssignmentConsiderations].[turn_organization_id] is not null

		  and (case when @role=N'Конролер' and [AssignmentResolutions].name=N'Повернуто в 1551' then 1
		  when @role<>N'Конролер' and [AssignmentResolutions].name=N'Повернуто в батьківську організацію'
		  then 1 end)=1 and [ReceiptSources].code=N'UGL'
	 THEN 1 ELSE 0 END count_nevkomp,

CASE WHEN 
		  [AssignmentStates].code=N'OnCheck' and [AssignmentResults].code=N'WasExplained ' and [AssignmentResolutions].code=N'Requires1551ChecksByTheController' and [AssignmentRevisions].rework_counter in (1,2)
		  and  [ReceiptSources].code=N'UGL'
	 THEN 1 ELSE 0 END count_doopr,

CASE WHEN 
		  [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'OnCheck' and [AssignmentResults].code=N'WasExplained ' and [AssignmentResolutions].code=N'Requires1551ChecksByTheController'
		  and  [ReceiptSources].code=N'UGL'
	 THEN 1 ELSE 0 END count_rozyasn,

CASE WHEN 
		  [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'OnCheck' and 
		  [AssignmentResults].code=N'WasExplained ' and [AssignmentResolutions].code=N'Requires1551ChecksByTheController' and
		  [Questions].control_date<=getutcdate() 
		  and  [ReceiptSources].code=N'UGL'
	 THEN 1 ELSE 0 END count_prostr,

CASE WHEN 
		  [AssignmentStates].code=N'OnCheck' and [AssignmentResults].code=N'ItIsNotPossibleToPerformThisPeriod' and [AssignmentResolutions].code=N'RequiresFunding_IncludedInThePlan'
		  and  [ReceiptSources].code=N'UGL'
	 THEN 1 ELSE 0 END count_plan_prog,

CASE WHEN 
		  [AssignmentStates].code=N'OnCheck' and [AssignmentResults].code=N'Done'
		  and  [ReceiptSources].code=N'UGL'
	 THEN 1 ELSE 0 END count_vykon
from 
[Assignments] with (nolock)
inner join [AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
inner join [AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
left join [AssignmentConsiderations] with (nolock) on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
left join [AssignmentResolutions] with (nolock) on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
inner join [AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
inner join [Questions] with (nolock) on [Assignments].question_id=[Questions].Id
inner join [Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
inner join [ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [AssignmentRevisions] with (nolock) on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
--left join [QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
--left join [AssignmentConsiderations] on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
--left join [Organizations] on [Assignments].executor_organization_id=[Organizations].Id
--left join [Objects] on [Questions].object_id=[Objects].Id
--left join [Buildings] [Buildings5] on [Objects].builbing_id=[Buildings5].Id
--left join [Districts] [Districts5] on [Buildings5].district_id=[Districts5].Id
--where [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code<>N'Closed' and [AssignmentResults].code=N'NotInTheCompetence'
--  and [AssignmentResolutions].name in (N'Повернуто в 1551', N'Повернуто в батьківську організацію') 
--  and [AssignmentConsiderations].[turn_organization_id] is not null

--  and (case when @role=N'Конролер' and [AssignmentResolutions].name=N'Повернуто в 1551' then 1
--  when @role<>N'Конролер' and [AssignmentResolutions].name=N'Повернуто в батьківську організацію'
--  then 1 end)=1 and [ReceiptSources].code=N'UGL'
where [AssignmentStates].code<>N'Closed'  
and AssignmentResults.code in (N'NotInTheCompetence', N'WasExplained ', N'ItIsNotPossibleToPerformThisPeriod', N'Done')
and  [ReceiptSources].code=N'UGL'
) t

 SELECT 1 Id, N'УГЛ' navigation, 
[neVKompetentsii], 
[doopratsiovani], 
[rozyasneno], 
[vykon], 
[prostrocheni], 
[neVykonNeMozhl]
 FROM #temp_all
 UNION ALL
 SELECT 7 Id, N'Сума' navigation, 
[neVKompetentsii], 
[doopratsiovani], 
[rozyasneno], 
[vykon], 
[prostrocheni], 
[neVykonNeMozhl]
 FROM #temp_all