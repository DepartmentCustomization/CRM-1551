/*
DECLARE @user_id NVARCHAR(128) = N'  ';--= N'c8848a30-38ec-459b-aeaa-db906f3bc141';
DECLARE @organization_id INT = 1762;
DECLARE @navigation NVARCHAR(40) = N'Електронні джерела'; -- 40
declare @column nvarchar(40)=N'Прострочені'; --40
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
		
DECLARE @comment_prost NVARCHAR(MAX) = (SELECT
		CASE
			WHEN @column = N'Прострочені' THEN N' '
			ELSE N'--'
		END);
DECLARE @comment_uvaga NVARCHAR(MAX) = (SELECT
		CASE
			WHEN @column = N'Увага' THEN N' '
			ELSE N'--'
		END);
DECLARE @comment_vroboti NVARCHAR(MAX) = (SELECT
		CASE
			WHEN @column = N'В роботі' THEN N' '
			ELSE N'--'
		END);

DECLARE @Nav_Ids NVARCHAR(MAX);

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
select DISTINCT [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].name OrganizationsName,
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
  ,CASE WHEN o_rights.organization_id IS NOT NULL THEN ''true'' ELSE ''false'' END is_rights
from 
[Assignments]
INNER JOIN [Questions] on [Assignments].question_id=[Questions].Id
INNER JOIN [Appeals] on [Questions].appeal_id=[Appeals].Id
INNER JOIN [ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
left JOIN [QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
INNER JOIN nav ON
case when [ReceiptSources].code=N''UGL'' then N''УГЛ'' 
when [ReceiptSources].code=N''Website_mob.addition'' then N''Електронні джерела''
when [QuestionTypes].emergency=N''true'' then N''Пріоритетне''
when [QuestionTypes].parent_organization_is=N''true'' then N''Зауваження''
else N''Інші доручення''
end	= nav.Id

INNER JOIN [AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
INNER JOIN [AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id

INNER JOIN tpu_organization tpuo 
	ON [Assignments].executor_organization_id=tpuo.organizations_id

left JOIN [AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id 
left JOIN [AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left JOIN [Organizations] on [Assignments].executor_organization_id=[Organizations].Id
left JOIN [Objects] on [Questions].[object_id]=[Objects].Id
left JOIN [Buildings] on [Objects].builbing_id=[Buildings].Id
left JOIN [Streets] on [Buildings].street_id=[Streets].Id
left JOIN [Applicants] on [Appeals].applicant_id=[Applicants].Id
left JOIN [StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
left JOIN [Districts] on [Buildings].district_id=[Districts].Id

left join (select [building_id], [executor_id]
  from [ExecutorInRoleForObject]
  where [executor_role_id]=1) balans on [Buildings].Id=balans.building_id

left JOIN [Organizations] [Organizations3] on balans.executor_id=[Organizations3].Id
left join o_rights on [Assignments].executor_organization_id=o_rights.organization_id


where [Assignments].executor_person_id='+LTRIM(@organization_id)+N' AND
' + @comment_uvaga + N' (DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.25*-1, [Questions].control_date)<getutcdate() and [Questions].control_date>=getutcdate() and [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''InWork'')
 ' + @comment_prost + N' ([Questions].control_date<=getutcdate() and [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''InWork'' )
 ' + @comment_vroboti + N' (DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.75, [Questions].registration_date)>=getutcdate() and [Questions].control_date>=getutcdate() and [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''InWork'')
'


DECLARE @exec_ruzult NVARCHAR(MAX) =
N'with
temp_positions_user as
 (
select p.id, p.organizations_id
from [dbo].[Positions] p
where organizations_id IN
(
select p.organizations_id
from [dbo].[Positions] p
where p.programuser_id=N'''+@user_id+'''
union
select pm.organizations_id
from [dbo].[PositionsHelpers] ph
inner join [dbo].[Positions] pm on ph.main_position_id=pm.id
where ph.helper_position_id in
(select p.Id
from [dbo].[Positions] p
where p.programuser_id=N'''+@user_id+'''))
 )

 ,tpu_organization as
 (SELECT DISTINCT organizations_id
  FROM temp_positions_user
  )

   ,nav as 
(
'+@Nav_Ids+N' 
)
,o_rights as
(
SELECT DISTINCT r.organization_id
  FROM [Positions] p
  INNER JOIN [OrganizationInResponsibilityRights] r ON p.organizations_id=r.organization_id AND p.Id=r.position_id
  WHERE p.programuser_id='''+@user_id+N'''
)

,main as
(' +
@exec_code1
+
N')

select Id, navigation, registration_number, QuestionType, zayavnyk, adress, vykonavets, control_date, zayavnykId, QuestionId
, zayavnyk_adress, zayavnyk_zmist, balans_name, receipt_date, is_rights
 from main order by registration_date'

EXEC (@exec_ruzult);
--SELECT @exec_ruzult, LEN(@exec_ruzult), @exec_code1, LEN(@exec_code1), @Nav_Ids, LEN(@Nav_Ids)
--SELECT @exec_ruzult, LEN(@exec_ruzult)
	END

ELSE
	
	BEGIN
	SELECT 1 Id, NULL  navigation, NULL  registration_number, NULL  QuestionType, NULL  zayavnyk, NULL  adress, 
	NULL  vykonavets, NULL  control_date, NULL  zayavnykId, NULL  QuestionId, NULL  zayavnyk_adress, NULL  zayavnyk_zmist, 
	NULL  balans_name, NULL  receipt_date, NULL is_rights
   WHERE 1=3;
	END


	--select @Nav_Ids