/* 
 declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
 declare @organization_id int =2298;
 declare @navigation nvarchar(400)=N'Усі';
 declare @column nvarchar(400)=N'На доопрацюванні';
*/
 declare @comment_naDoopr nvarchar(6)=(select case when @column=N'На доопрацюванні' then N' ' else N'--' end);
 declare @comment_planProg nvarchar(6)=(select case when @column=N'План/Програма' then N' ' else N'--' end);
 

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


declare @qcode nvarchar(max)=N'

  
 with

    ------------для плана/програми---
 main_end as 
  (
  select Id
  from [Assignments] with (nolock)
  where assignment_state_id=5 and AssignmentResultsId=7 and [executor_organization_id]='+ltrim(@organization_id)+N'
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


main as
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

left join end_result on [Assignments].Id=end_result.assignment_id
 left join end_state on [Assignments].Id=end_state.assignment_id
 
left join [Questions] with (nolock) on [Assignments].question_id=[Questions].Id
left join [Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
left join [ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
left join [AssignmentTypes] with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id
left join [AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [AssignmentConsiderations] with (nolock) on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
left join [AssignmentResults] with (nolock) on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
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

 '+@comment_naDoopr+N'[Assignments].[executor_organization_id]='+ltrim(@organization_id)+N' and ([AssignmentStates].code=N''NotFulfilled'' and ([AssignmentResults].code=N''ForWork'' or [AssignmentResults].code=N''Actually''))
 '+@comment_planProg+N' end_result.assignment_id is not null and end_result.assignment_id is not null
 
),

nav as 
(
select 1 Id, N''УГЛ'' name union all select 2 Id, N''Електронні джерела'' name union all select 3	Id, N''Пріоритетне'' name union all select 4 Id, N''Інші доручення'' name union all select 5 Id, N''Зауваження'' name 
)


select /*ROW_NUMBER() over(order by registration_number)*/ main.Id, registration_number, QuestionType, zayavnyk, adress, control_date, zayavnykId,
zayavnyk_adress, zayavnyk_zmist, short_answer, rework_counter, balans_name
 from main where --navigation, registration_number, from main
  navigation in ('+@Ids+N')
 order by case when rework_counter=2 then 1 else 2 end, Id'

 exec(@qcode)

 /*
select ar.*
  FROM [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] ac
  inner join AssignmentRevisions ar on ac.Id=ar.assignment_consideration_іd
  where ac.assignment_id=2811173
 */