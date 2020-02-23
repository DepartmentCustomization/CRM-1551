/*
declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
declare @organization_id int =2005;
declare @navigation nvarchar(400)=N'Усі';
declare @column nvarchar(400)=N'Прострочені';
*/

IF EXISTS (SELECT orr.*
  FROM [dbo].[OrganizationInResponsibilityRights] orr
  INNER JOIN dbo.Positions p ON orr.position_id=P.Id
  WHERE orr.organization_id=@organization_Id 
  AND P.programuser_id=@user_id)

	BEGIN
		
DECLARE @comment_prost NVARCHAR(6) = (SELECT
		CASE
			WHEN @column = N'Прострочені' THEN N' '
			ELSE N'--'
		END);
DECLARE @comment_uvaga NVARCHAR(6) = (SELECT
		CASE
			WHEN @column = N'Увага' THEN N' '
			ELSE N'--'
		END);
DECLARE @comment_vroboti NVARCHAR(6) = (SELECT
		CASE
			WHEN @column = N'В роботі' THEN N' '
			ELSE N'--'
		END);


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
			@navigation
END;


DECLARE @IdS NVARCHAR(MAX) = (SELECT
		STUFF((SELECT
				N',' + N'''' + Id + ''''
			FROM @NavigationTable
			FOR XML PATH (''))
		, 1, 1, ''));

--select @IdS
-- with

--main as
--(

DECLARE @exec_code1 NVARCHAR(MAX) = N'

select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].name OrganizationsName,
[Applicants].full_name zayavnyk, 

--[StreetTypes].shortname+N'' ''+Streets.name+N'', ''+[Buildings].name adress, 
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
[dbo].[Assignments] left join 
[dbo].[Questions] on [Assignments].question_id=[Questions].Id
left join [dbo].[Appeals] on [Questions].appeal_id=[Appeals].Id
left join [dbo].[ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
left join [dbo].[AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
left join [dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [dbo].[AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id 
left join [dbo].[AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left join [dbo].[Organizations] on [Assignments].executor_organization_id=[Organizations].Id
left join [dbo].[Objects] on [Questions].[object_id]=[Objects].Id
left join [dbo].[Buildings] on [Objects].builbing_id=[Buildings].Id
left join [dbo].[Streets] on [Buildings].street_id=[Streets].Id
left join [dbo].[Applicants] on [Appeals].applicant_id=[Applicants].Id
left join [dbo].[StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
left join [dbo].[Districts] on [Buildings].district_id=[Districts].Id

left join (select [building_id], [executor_id]
  from [dbo].[ExecutorInRoleForObject]
  where [executor_role_id]=1 /*Балансоутримувач*/) balans on [Buildings].Id=balans.building_id

left join [dbo].[Organizations] [Organizations3] on balans.executor_id=[Organizations3].Id

--
LEFT JOIN tpu_organization tpuo 
	ON [Assignments].executor_organization_id=tpuo.organizations_id
LEFT JOIN tpu_position tpuop 
	ON [Assignments].executor_person_id=tpuop.position_id
	--

where
((tpuo.organizations_id IS NOT NULL AND [Assignments].executor_person_id IS NULL) OR (tpuop.position_id IS NOT NULL))
 and 

' + @comment_uvaga + N' (DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.25*-1, [Questions].control_date)<getutcdate() and [Questions].control_date>=getutcdate() and [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''InWork'')
 ' + @comment_prost + N' ([Questions].control_date<=getutcdate() and [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''InWork'' )
 ' + @comment_vroboti + N' (DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.75, [Questions].registration_date)>=getutcdate() and [Questions].control_date>=getutcdate() and [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''InWork'')
'


DECLARE @exec_ruzult NVARCHAR(MAX) =
N'with
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

,main as
(' +
@exec_code1
+
N')

select Id, navigation, registration_number, QuestionType, zayavnyk, adress, vykonavets, control_date, zayavnykId, QuestionId
, zayavnyk_adress, zayavnyk_zmist, balans_name, receipt_date
 from main where navigation in (' + @IdS + N')
order by registration_date'

EXEC (@exec_ruzult);
	END

ELSE
	
	BEGIN
	SELECT 1 Id, NULL  navigation, NULL  registration_number, NULL  QuestionType, NULL  zayavnyk, NULL  adress, 
	NULL  vykonavets, NULL  control_date, NULL  zayavnykId, NULL  QuestionId, NULL  zayavnyk_adress, NULL  zayavnyk_zmist, 
	NULL  balans_name, NULL  receipt_date
   WHERE 1=3;
	END