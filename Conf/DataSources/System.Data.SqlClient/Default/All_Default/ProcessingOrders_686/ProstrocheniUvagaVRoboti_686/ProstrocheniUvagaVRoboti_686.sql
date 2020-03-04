/*
DECLARE @user_id NVARCHAR(128) = N'cd01fea0-760c-4b66-9006-152e5b2a87e9';
DECLARE @organization_id INT = 2008;
DECLARE @navigation NVARCHAR(40) = N'Усі';
declare @column nvarchar(400)=N'Прострочені';
*/

IF EXISTS (SELECT orr.*
  FROM [OrganizationInResponsibilityRights] orr with (nolock)
  INNER JOIN dbo.Positions p with (nolock) ON orr.position_id=P.Id
  WHERE orr.organization_id=@organization_Id 
  AND P.programuser_id=@user_id)

	BEGIN
		
DECLARE @comment_prost NVARCHAR(max) = (SELECT
		CASE
			WHEN @column = N'Прострочені' THEN N' '
			ELSE N'--'
		END);
DECLARE @comment_uvaga NVARCHAR(max) = (SELECT
		CASE
			WHEN @column = N'Увага' THEN N' '
			ELSE N'--'
		END);
DECLARE @comment_vroboti NVARCHAR(max) = (SELECT
		CASE
			WHEN @column = N'В роботі' THEN N' '
			ELSE N'--'
		END);

DECLARE @Nav_Ids NVARCHAR(max);

IF @navigation = N'Усі'
BEGIN
SET @Nav_Ids=N'SELECT N''Інші доручення'' Id UNION SELECT N''УГЛ'' Id UNION SELECT N''Електронні джерела'' Id 
UNION SELECT N''Зауваження'' Id UNION SELECT N''Пріоритетне'' Id'
END
ELSE
BEGIN
SET @Nav_Ids=N'SELECT N'''+ISNULL(@navigation,N'')+N''' Id'
END;

DECLARE @exec_code1 NVARCHAR(MAX) = N'
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
case when [ReceiptSources].name=N''УГЛ'' then N''УГЛ'' 
when [ReceiptSources].name=N''Сайт/моб. додаток'' then N''Електронні джерела''
when [QuestionTypes].emergency=N''true'' then N''Пріоритетне''
when [QuestionTypes].parent_organization_is=N''true'' then N''Зауваження''
else N''Інші доручення''
end navigation,

 [Applicants].Id zayavnykId, [Questions].Id QuestionId, [Organizations].short_name vykonavets,

 convert(datetime, [Questions].[control_date]) control_date, 
 
 [Assignments].registration_date
  , [Applicants].[ApplicantAdress] zayavnyk_adress, [Questions].question_content zayavnyk_zmist
  ,[Organizations3].short_name balans_name, [Questions].[receipt_date]

from 
[Assignments] with (nolock)
INNER JOIN [dbo].[Questions] with (nolock) on [Assignments].question_id=[Questions].Id
INNER JOIN [dbo].[Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
INNER JOIN [dbo].[ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
left JOIN [dbo].[QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
INNER JOIN nav ON
case when [ReceiptSources].code=N''UGL'' then N''УГЛ'' 
when [ReceiptSources].code=N''Website_mob.addition'' then N''Електронні джерела''
when [QuestionTypes].emergency=N''true'' then N''Пріоритетне''
when [QuestionTypes].parent_organization_is=N''true'' then N''Зауваження''
else N''Інші доручення''
end	= nav.Id

INNER JOIN [dbo].[AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
INNER JOIN [dbo].[AssignmentTypes] with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id

LEFT JOIN tpu_organization tpuo 
	ON [Assignments].executor_organization_id=tpuo.organizations_id
LEFT JOIN tpu_position tpuop 
	ON [Assignments].executor_person_id=tpuop.position_id

left JOIN [dbo].[AssignmentResults] with (nolock) on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id 
left JOIN [dbo].[AssignmentResolutions] with (nolock) on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left JOIN [dbo].[Organizations] with (nolock) on [Assignments].executor_organization_id=[Organizations].Id
left JOIN [dbo].[Objects] with (nolock) on [Questions].[object_id]=[Objects].Id
left JOIN [dbo].[Buildings] with (nolock) on [Objects].builbing_id=[Buildings].Id
left JOIN [dbo].[Streets] with (nolock) on [Buildings].street_id=[Streets].Id
left JOIN [dbo].[Applicants] with (nolock) on [Appeals].applicant_id=[Applicants].Id
left JOIN [dbo].[StreetTypes] with (nolock) on [Streets].street_type_id=[StreetTypes].Id
left JOIN [dbo].[Districts] with (nolock) on [Buildings].district_id=[Districts].Id

left join (select [building_id], [executor_id]
  from [ExecutorInRoleForObject] with (nolock)
  where [executor_role_id]=1) balans on [Buildings].Id=balans.building_id

left JOIN [dbo].[Organizations] [Organizations3] with (nolock) on balans.executor_id=[Organizations3].Id


where
' + @comment_uvaga + N' (DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.25*-1, [Questions].control_date)<getutcdate() and [Questions].control_date>=getutcdate() and [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''InWork'')
 ' + @comment_prost + N' ([Questions].control_date<=getutcdate() and [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''InWork'' )
 ' + @comment_vroboti + N' (DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.75, [Questions].registration_date)>=getutcdate() and [Questions].control_date>=getutcdate() and [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''InWork'')
and ((tpuo.organizations_id IS NOT NULL AND [Assignments].executor_person_id IS NULL) OR (tpuop.position_id IS NOT NULL))'


DECLARE @exec_ruzult NVARCHAR(MAX) =
N'with
temp_positions_user as
 (
 SELECT p.Id, [is_main], organizations_id
  FROM [Positions] p with (nolock)
  WHERE p.[programuser_id]=N'''+@user_id+N'''
  UNION 
  SELECT p2.Id, p2.is_main, p2.organizations_id
  FROM [Positions] p with (nolock)
  INNER JOIN [dbo].[PositionsHelpers] ph with (nolock) ON p.Id=ph.main_position_id
  INNER JOIN [dbo].[Positions] p2 with (nolock) ON ph.helper_position_id=p2.Id
  WHERE p.[programuser_id]=N'''+@user_id+N'''
  UNION 
  SELECT p2.Id, p2.is_main, p2.organizations_id
  FROM [Positions] p with (nolock)
  INNER JOIN [dbo].[PositionsHelpers] ph with (nolock) ON p.Id=ph.helper_position_id
  INNER JOIN [dbo].[Positions] p2 with (nolock) ON ph.main_position_id=p2.Id
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

   ,nav as 
(
'+@Nav_Ids+N' 
)

,main as
(' +
@exec_code1
+
N')

select Id, navigation, registration_number, QuestionType, zayavnyk, adress, vykonavets, control_date, zayavnykId, QuestionId
, zayavnyk_adress, zayavnyk_zmist, balans_name, receipt_date
 from main order by registration_date'

EXEC (@exec_ruzult);
--SELECT @exec_ruzult
	END

ELSE
	
	BEGIN
	SELECT 1 Id, NULL  navigation, NULL  registration_number, NULL  QuestionType, NULL  zayavnyk, NULL  adress, 
	NULL  vykonavets, NULL  control_date, NULL  zayavnykId, NULL  QuestionId, NULL  zayavnyk_adress, NULL  zayavnyk_zmist, 
	NULL  balans_name, NULL  receipt_date
   WHERE 1=3;
	END


	--select @Nav_Ids