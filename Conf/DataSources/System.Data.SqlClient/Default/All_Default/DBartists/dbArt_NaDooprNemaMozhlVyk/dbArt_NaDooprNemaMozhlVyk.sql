/* 
DECLARE @user_id NVARCHAR(128) = N'  ';--= N'c8848a30-38ec-459b-aeaa-db906f3bc141';
DECLARE @organization_id INT = 1762;
DECLARE @navigation NVARCHAR(40) = N'Усі';
 declare @column nvarchar(400)=N'На доопрацюванні'; --План/Програма На доопрацюванні
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
		DECLARE @comment_naDoopr NVARCHAR(6) = (SELECT
		CASE
			WHEN @column = N'На доопрацюванні' THEN N' '
			ELSE N'--'
		END);
DECLARE @comment_planProg NVARCHAR(6) = (SELECT
		CASE
			WHEN @column = N'План/Програма' THEN N' '
			ELSE N'--'
		END);


DECLARE @NavigationTable TABLE (
	Id NVARCHAR(400)
);
DECLARE @Nav_Ids NVARCHAR(200);

IF @navigation = N'Усі'
BEGIN
SET @Nav_Ids=N'SELECT N''Інші доручення'' Id UNION SELECT N''УГЛ'' Id UNION SELECT N''Електронні джерела'' Id 
UNION SELECT N''Зауваження'' Id UNION SELECT N''Пріоритетне'' Id'

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
SET @Nav_Ids=N'SELECT N'''+ISNULL(@navigation,N'')+N''' Id'
	INSERT INTO @NavigationTable (Id)
		SELECT
			@navigation;
END;

--SELECT @Nav_Ids
--END
DECLARE @IdS NVARCHAR(MAX) = (SELECT
		STUFF((SELECT
				N',' + N'''' + Id + ''''
			FROM @NavigationTable
			FOR XML PATH (''))
		, 1, 1, ''));


DECLARE @qcode NVARCHAR(MAX) = N'

  
 with
    --основные для организаций
 temp_positions_user as
 (
 select p.id, p.organizations_id
from [dbo].[Positions] p
where organizations_id IN
(
select organizations_id
from [dbo].[Positions]
where programuser_id=N'''+@user_id+''')
 )

 ,tpu_organization as
 (SELECT DISTINCT organizations_id
  FROM temp_positions_user
  )

    ------------для плана/програми---
 ,main_end as 
  (
  select Id
  from [Assignments] with (nolock)
  inner join tpu_organization on [Assignments].[executor_organization_id]=tpu_organization.organizations_id
  where assignment_state_id=5 and AssignmentResultsId=7
  ), 
  end_state as
  (
  select [Assignment_History].Id, [Assignment_History].assignment_id, [Assignment_History].assignment_state_id
  from [Assignment_History] with (nolock) inner join main_end on [Assignment_History].assignment_id=main_end.Id
  inner join [AssignmentStates] with (nolock) on [Assignment_History].assignment_state_id=[AssignmentStates].Id

  where [AssignmentStates].code=N''OnCheck'' and
  [AssignmentStates].code<>N''Closed'' and [Assignment_History].id in
  (select max([Assignment_History].id) id_max
  from [Assignment_History] with (nolock) inner join main_end on [Assignment_History].assignment_id=main_end.Id
  where [Assignment_History].assignment_state_id<>5
  group by [Assignment_History].assignment_id)
  ),
  end_result as
  (select [Assignment_History].Id, [Assignment_History].assignment_id, [Assignment_History].AssignmentResultsId
  from [Assignment_History] with (nolock) inner join main_end on [Assignment_History].assignment_id=main_end.Id
  inner join [AssignmentResults] with (nolock) on [Assignment_History].AssignmentResultsId=[AssignmentResults].Id

  where [AssignmentResults].code=N''ItIsNotPossibleToPerformThisPeriod'' and
  [AssignmentResults].code<>N''WasExplained '' and [Assignment_History].id in
  (select max([Assignment_History].id) id_max
  from [Assignment_History] inner join main_end on [Assignment_History].assignment_id=main_end.Id
  where [Assignment_History].AssignmentResultsId<>7
  group by [Assignment_History].assignment_id)),


 -----------------основное-----
 nav as 
(
'+@Nav_Ids+N' 
)
, o_rights as
(
SELECT DISTINCT r.organization_id
  FROM [dbo].[Positions] p
  INNER JOIN [dbo].[OrganizationInResponsibilityRights] r ON p.organizations_id=r.organization_id AND p.Id=r.position_id
  WHERE p.programuser_id='''+@user_id+N'''
)
,main as
(
select distinct [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].name OrganizationsName,
[Applicants].full_name zayavnyk,  
isnull([Districts].name+N'' р-н, '', N'''')
  +isnull([StreetTypes].shortname, N'''')
  +isnull([Streets].name,N'''')
  +isnull(N'', ''+[Buildings].name,N'''')
  +isnull(N'', п. ''+[Questions].[entrance], N'''')
  +isnull(N'', кв. ''+[Questions].flat, N'''') adress, 
[Questions].registration_number,
[QuestionTypes].name QuestionType,
case when [ReceiptSources].code=N''UGL'' then N''УГЛ'' 
when [ReceiptSources].code=N''Website_mob.addition'' then N''Електронні джерела''
when [QuestionTypes].emergency=N''true'' then N''Пріоритетне''
when [QuestionTypes].parent_organization_is=N''true'' then N''Зауваження''
else N''Інші доручення''
end navigation

 ,[Applicants].Id zayavnykId, [Questions].Id QuestionId, [Organizations].short_name vykonavets, [Assignments].[registration_date],

 ( SELECT TOP 1 	control_comment 
FROM AssignmentRevisions AS ar
JOIN AssignmentConsiderations AS ac ON ac.Id = ar.assignment_consideration_іd
WHERE ac.assignment_id = [Assignments].Id 
ORDER BY ar.id DESC ) as short_answer,


 convert(datetime, [Questions].[control_date]) control_date
  , [Applicants].[ApplicantAdress] zayavnyk_adress, [Questions].question_content zayavnyk_zmist
    --, [AssignmentRevisions].[rework_counter]
	,(select count(id) from AssignmentRevisions where assignment_consideration_іd in
	    (select Id from AssignmentConsiderations where assignment_id= [Assignments].Id) and control_result_id = 5 )  as rework_counter

	,[Organizations3].short_name balans_name
	,CASE WHEN o_rights.organization_id IS NOT NULL THEN ''true'' ELSE ''false'' END [is_rights]
from 
[Assignments] with (nolock)
--
INNER JOIN tpu_organization tpuo 
	ON [Assignments].executor_organization_id=tpuo.organizations_id
	--

left join end_result on [Assignments].Id=end_result.assignment_id
left join end_state on [Assignments].Id=end_state.assignment_id

INNER JOIN [AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [AssignmentResults] with (nolock) on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +

INNER JOIN [Questions] with (nolock) on [Assignments].question_id=[Questions].Id
INNER JOIN [Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
INNER JOIN [ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id

INNER JOIN nav ON
case when [ReceiptSources].code=N''UGL'' then N''УГЛ'' 
when [ReceiptSources].code=N''Website_mob.addition'' then N''Електронні джерела''
when [QuestionTypes].emergency=N''true'' then N''Пріоритетне''
when [QuestionTypes].parent_organization_is=N''true'' then N''Зауваження''
else N''Інші доручення''
end	= nav.Id

left join [AssignmentTypes] with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id

left join [AssignmentConsiderations] with (nolock) on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id

left join [AssignmentResolutions] with (nolock) on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left join [Organizations] with (nolock) on [Assignments].executor_organization_id=[Organizations].Id
left join [Objects] with (nolock) on [Questions].[object_id]=[Objects].Id
left join [Buildings] with (nolock) on [Objects].builbing_id=[Buildings].Id
left join [Streets] with (nolock) on [Buildings].street_id=[Streets].Id
left join [Applicants] with (nolock) on [Appeals].applicant_id=[Applicants].Id
left join [StreetTypes] with (nolock) on [Streets].street_type_id=[StreetTypes].Id
left join [Districts] with (nolock) on [Buildings].district_id=[Districts].Id
left join [AssignmentRevisions] with (nolock) on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
--left join [AssignmentConsiderations] [AssignmentConsiderations2] on [Assignments].Id=[AssignmentConsiderations2].assignment_id
--left join [AssignmentRevisions] [AssignmentRevisions2] on [AssignmentConsiderations2].Id=[AssignmentRevisions2].assignment_consideration_іd


left join (select [building_id], [executor_id]
  from [ExecutorInRoleForObject] with (nolock)
  where [executor_role_id]=1 /*Балансоутримувач*/) balans on [Buildings].Id=balans.building_id

left join [Organizations] [Organizations3] with (nolock) on balans.executor_id=[Organizations3].Id

left join (select count(AssignmentRevisions.id) rework_counter, AssignmentConsiderations.assignment_id
from AssignmentRevisions with (nolock)
inner join AssignmentConsiderations with (nolock) on AssignmentRevisions.assignment_consideration_іd=AssignmentConsiderations.Id
where AssignmentRevisions.control_result_id = 5
group by AssignmentConsiderations.assignment_id) rework_counter on Assignments.Id=rework_counter.assignment_id

left join o_rights on [Assignments].executor_organization_id=o_rights.organization_id

where [Assignments].executor_person_id='+LTRIM(@organization_id)+N' AND

 ' + @comment_naDoopr + N' ([AssignmentStates].code=N''NotFulfilled'' and ([AssignmentResults].code=N''ForWork'' or [AssignmentResults].code=N''Actually''))
 ' + @comment_planProg + N' end_result.assignment_id is not null and end_result.assignment_id is not null and [Questions].event_id is null
 
)


select main.Id, registration_number, QuestionType, zayavnyk, adress, control_date, zayavnykId,
zayavnyk_adress, zayavnyk_zmist, short_answer, rework_counter, balans_name, [is_rights]
 from main 
 order by case when rework_counter=2 then 1 else 2 end, Id'

EXEC (@qcode);
	END

ELSE
	
	BEGIN
   SELECT 1 Id, NULL  registration_number, NULL  QuestionType, NULL  zayavnyk, NULL  adress, NULL  control_date, NULL  zayavnykId, NULL 
zayavnyk_adress, NULL  zayavnyk_zmist, NULL  short_answer, NULL  rework_counter, NULL  balans_name, NULL [is_rights]
   WHERE 1=3;
	END