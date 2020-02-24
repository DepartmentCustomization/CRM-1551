/* 
DECLARE @user_id NVARCHAR(128) = N'cd01fea0-760c-4b66-9006-152e5b2a87e9';
DECLARE @organization_id INT = 2008;
DECLARE @navigation NVARCHAR(40) = N'Усі';
 declare @column nvarchar(400)=N'План/Програма'; --План/Програма
*/

IF EXISTS (SELECT orr.*
  FROM [dbo].[OrganizationInResponsibilityRights] orr
  INNER JOIN dbo.Positions p ON orr.position_id=P.Id
  WHERE orr.organization_id=@organization_Id 
  AND P.programuser_id=@user_id)

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
SET @Nav_Ids=N'SELECT N'''+ISNULL(@navigation,N'')+N'Id'
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
 SELECT p.Id, [is_main], organizations_id
  FROM [dbo].[Positions] p
  WHERE p.[programuser_id]=N'''+@user_id+N'''
  UNION 
  SELECT p2.Id, p2.is_main, p2.organizations_id
  FROM [dbo].[Positions] p
  INNER JOIN [dbo].[PositionsHelpers] ph ON p.Id=ph.main_position_id
  INNER JOIN [dbo].[Positions] p2 ON ph.helper_position_id=p2.Id
  WHERE p.[programuser_id]=N'''+@user_id+N'''
  UNION 
  SELECT p2.Id, p2.is_main, p2.organizations_id
  FROM [dbo].[Positions] p
  INNER JOIN [dbo].[PositionsHelpers] ph ON p.Id=ph.helper_position_id
  INNER JOIN [dbo].[Positions] p2 ON ph.main_position_id=p2.Id
  WHERE p.[programuser_id]=N'''+@user_id+N'''
 )

 ,tpu_organization as
 (SELECT DISTINCT organizations_id
  FROM temp_positions_user
  WHERE is_main=''true'' AND organizations_id='+LTRIM(@organization_Id)+N'
  )

  ,tpu_position AS 
  (SELECT DISTINCT Id position_id
  FROM temp_positions_user)
    ------------для плана/програми---
 ,main_end as 
  (
  select Id
  from [Assignments] with (nolock)
  where assignment_state_id=5 and AssignmentResultsId=7 and [executor_organization_id]=' + LTRIM(@organization_id) + N'
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

,main as
(
select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].name OrganizationsName,
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

-- [AssignmentRevisions].[control_comment] short_answer, 

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
from 
[Assignments] with (nolock)
--
LEFT JOIN tpu_organization tpuo 
	ON [Assignments].executor_organization_id=tpuo.organizations_id
LEFT JOIN tpu_position tpuop 
	ON [Assignments].executor_person_id=tpuop.position_id
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


where 

 ' + @comment_naDoopr + N'((tpuo.organizations_id IS NOT NULL AND [Assignments].executor_person_id IS NULL) OR (tpuop.position_id IS NOT NULL)) and ([AssignmentStates].code=N''NotFulfilled'' and ([AssignmentResults].code=N''ForWork'' or [AssignmentResults].code=N''Actually''))
 ' + @comment_planProg + N' end_result.assignment_id is not null and end_result.assignment_id is not null and [Questions].event_id is null
 
)


select /*ROW_NUMBER() over(order by registration_number)*/ main.Id, registration_number, QuestionType, zayavnyk, adress, control_date, zayavnykId,
zayavnyk_adress, zayavnyk_zmist, short_answer, rework_counter, balans_name
 from main 
 order by case when rework_counter=2 then 1 else 2 end, Id'

EXEC (@qcode);
	END

ELSE
	
	BEGIN
   SELECT 1 Id, NULL  registration_number, NULL  QuestionType, NULL  zayavnyk, NULL  adress, NULL  control_date, NULL  zayavnykId, NULL 
zayavnyk_adress, NULL  zayavnyk_zmist, NULL  short_answer, NULL  rework_counter, NULL  balans_name
   WHERE 1=3;
	END