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
[CRM_1551_Analitics].[dbo].[Assignments] left join 
[CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
left join [CRM_1551_Analitics].[dbo].[Appeals] on [Questions].appeal_id=[Appeals].Id
left join [CRM_1551_Analitics].[dbo].[ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id 
left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left join [CRM_1551_Analitics].[dbo].[Organizations] on [Assignments].executor_organization_id=[Organizations].Id
left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].[object_id]=[Objects].Id
left join [CRM_1551_Analitics].[dbo].[Buildings] on [Objects].builbing_id=[Buildings].Id
left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=[Streets].Id
left join [CRM_1551_Analitics].[dbo].[Applicants] on [Appeals].applicant_id=[Applicants].Id
left join [CRM_1551_Analitics].[dbo].[StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
left join [CRM_1551_Analitics].[dbo].[Districts] on [Buildings].district_id=[Districts].Id

left join (select [building_id], [executor_id]
  from [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
  where [executor_role_id]=1 /*Балансоутримувач*/) balans on [Buildings].Id=balans.building_id

left join [CRM_1551_Analitics].[dbo].[Organizations] [Organizations3] on balans.executor_id=[Organizations3].Id

where [Assignments].executor_organization_id=' + LTRIM(@organization_id) + N'
 and 

' + @comment_uvaga + N' (DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.25*-1, [Questions].control_date)<getutcdate() and [Questions].control_date>=getutcdate() and [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''InWork'')
 ' + @comment_prost + N' ([Questions].control_date<=getutcdate() and [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''InWork'' )
 ' + @comment_vroboti + N' (DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.75, [Questions].registration_date)>=getutcdate() and [Questions].control_date>=getutcdate() and [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''InWork'')
'


DECLARE @exec_ruzult NVARCHAR(MAX) =
N'with

main as
(' +
@exec_code1
+
N'),

nav as 
(
select 1 Id, N''УГЛ'' name union all select 2 Id, N''Електронні джерела'' name union all select 3	Id, N''Пріоритетне'' name union all select 4 Id, N''Інші доручення'' name union all select 5 Id, N''Зауваження'' name 
)

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