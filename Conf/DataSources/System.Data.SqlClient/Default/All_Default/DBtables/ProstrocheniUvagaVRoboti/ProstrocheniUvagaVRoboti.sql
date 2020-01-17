/*
declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
declare @organization_id int =2350;
declare @navigation nvarchar(400)=N'Усі';
declare @column nvarchar(400)=N'Прострочені';
*/

declare @comment_prost nvarchar(6)=(select case when @column=N'Прострочені' then N' ' else N'--' end);
declare @comment_uvaga nvarchar(6)=(select case when @column=N'Увага' then N' ' else N'--' end);
declare @comment_vroboti nvarchar(6)=(select case when @column=N'В роботі' then N' ' else N'--' end);


declare @NavigationTable table(Id nvarchar(400));

if @navigation=N'Усі'
	begin
		insert into @NavigationTable (Id)
		select N'Інші доручення' n union all select N'УГЛ' n union all
		select N'Зауваження' n union all select N'Електронні джерела' n union all select N'Пріоритетне'
	end 
else 
	begin
		insert into @NavigationTable (Id)
		select @navigation
	end;


declare @IdS nvarchar(max)=

 (select stuff(
 (select N','+N''''+Id+'''' from @NavigationTable
 for xml path('')),1,1,''));

 --select @IdS
-- with

--main as
--(

declare @exec_code1 nvarchar(max)=N'

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

where [Assignments].executor_organization_id='+ltrim(@organization_id)+N'
 and 

'+@comment_uvaga+N' (DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.25*-1, [Questions].control_date)<getutcdate() and [Questions].control_date>=getutcdate() and [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''InWork'')
 '+@comment_prost+N' ([Questions].control_date<=getutcdate() and [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''InWork'' )
 '+@comment_vroboti+N' (DATEADD(MI, DATEDIFF(MI, [Questions].registration_date, [Questions].control_date)*0.75, [Questions].registration_date)>=getutcdate() and [Questions].control_date>=getutcdate() and [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''InWork'')
'


declare @exec_ruzult nvarchar(max)=
N'with

main as
('+
@exec_code1
+
N'),

nav as 
(
select 1 Id, N''УГЛ'' name union all select 2 Id, N''Електронні джерела'' name union all select 3	Id, N''Пріоритетне'' name union all select 4 Id, N''Інші доручення'' name union all select 5 Id, N''Зауваження'' name 
)

select Id, navigation, registration_number, QuestionType, zayavnyk, adress, vykonavets, control_date, zayavnykId, QuestionId
, zayavnyk_adress, zayavnyk_zmist, balans_name, receipt_date
 from main where navigation in ('+@IdS+N')
order by registration_date'

exec(@exec_ruzult)
