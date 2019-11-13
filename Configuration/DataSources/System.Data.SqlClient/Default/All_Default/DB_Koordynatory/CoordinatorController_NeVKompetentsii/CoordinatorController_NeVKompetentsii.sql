/*
declare @user_id nvarchar(300)=N'Вася';
declare @organization_id int =6704;
declare @navigation nvarchar(400)=N'Усі';
*/
declare @question_type_ids nvarchar(max);
declare @rda_ids nvarchar(max);
declare @department_ids nvarchar(max);
declare @rda_question_type_ids nvarchar(max);
declare @filters nvarchar(max);

  declare @role0 nvarchar(500)=
  (select [Roles].name
  from [Positions] with (nolock)
  left join [Roles] with (nolock) on [Positions].role_id=[Roles].Id
  where [Positions].programuser_id=@user_id);

  declare @role nvarchar(500)=case when @role0 is null then N'qqqq' else @role0 end 


set @question_type_ids=(

select stuff((
select 
N'or ( '+case 
when [FiltersForControler].questiondirection_id=0 then N'1=1'
--when [QuestionTypesAndParent].QuestionTypes is null then N'1=2'
else N'[QuestionTypes].Id in ('+[QuestionTypesAndParent].QuestionTypes+N') ' end+ 

case 
when [FiltersForControler].district_id=0 then N'1=1'
--when [OrganizationsAndParent].Organizations is null then N'1=2'
else N' and [Organizations].Id in ('+[OrganizationsAndParent].Organizations+N')' end+N' )'
  from [FiltersForControler] with (nolock)
  left join [QuestionTypesAndParent] with (nolock) on [FiltersForControler].questiondirection_id=[QuestionTypesAndParent].ParentId
  left join [OrganizationsAndParent] with (nolock) on [FiltersForControler].district_id=[OrganizationsAndParent].ParentId
  where [FiltersForControler].user_id=@user_id
  for xml path('')),1,3,N'')
  )
  
 -- select @question_type_ids

  set @department_ids =(
  select stuff(
  (
  select N' or [Organizations].Id in ('+[OrganizationsAndParent].Organizations+')'
    from [FiltersForControler] with (nolock)
  inner join [OrganizationsAndParent] with (nolock) on [FiltersForControler].organization_id=[OrganizationsAndParent].ParentId
  where [FiltersForControler].user_id=@user_id
  for xml path('')),1,4,N'')
  )
  

  set @filters=(
  select N'('+
  case when @question_type_ids is null then N'(1=2)' else N'('+@question_type_ids+N')' end+ 
  case when @department_ids is null then N' or (1=2)' else N' or ('+@department_ids+N')' end)+N')'




declare @navigation1 nvarchar(500);

--declare @NavigationTable table(Id nvarchar(400));

if @navigation=N'Усі'
begin
 set @navigation1=N'N''Інші доручення'', N''УГЛ'', N''Зауваження'', N''Електронні джерела'', N''Пріоритетне'''
end
else
begin
 set @navigation1=N'N'''+@navigation+N''''
end;

--select @navigation1

declare @quere_code nvarchar(max)=N'

 with

main as
(
select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].name OrganizationsName,
[Applicants].full_name zayavnyk, [StreetTypes].shortname+N'' ''+Streets.name+N'', ''+[Buildings].name adress, [Questions].registration_number,
[QuestionTypes].name QuestionType,
case when [ReceiptSources].code=N''UGL'' then N''УГЛ'' 
when [ReceiptSources].code=N''Website_mob.addition'' or [ReceiptSources].code=N''Mail'' then N''Електронні джерела''
when [QuestionTypes].emergency=N''true'' then N''Пріоритетне''
when [QuestionTypes].parent_organization_is=N''true'' then N''Зауваження''
else N''Інші доручення''
end navigation,

 [Applicants].Id zayavnikId, [Questions].Id QuestionId, [Applicants].full_name zayavnikName
--  , [Organizations].short_name vykonavets
 , case when len([Organizations].[head_name]) > 5 then [Organizations].[head_name] + '' ( '' + [Organizations].[short_name] + '')''
					else [Organizations].[short_name] end as vykonavets
 , [AssignmentConsiderations].short_answer, [Questions].question_content, 
[Applicants].[ApplicantAdress] adressZ

 ,[Organizations2].Id [transfer_to_organization_id]
 ,[Organizations2].[short_name] [transfer_to_organization_name]
 ,[Questions].[control_date]
 
from 
[Assignments] with (nolock) inner join 
[Questions] with (nolock) on [Assignments].question_id=[Questions].Id
inner join [Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
inner join [ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
left join [AssignmentTypes] with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id
inner join [AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [AssignmentConsiderations] with (nolock) on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
inner join [AssignmentResults] with (nolock) on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
inner join [AssignmentResolutions] with (nolock) on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
inner join [Organizations] with (nolock) on [Assignments].executor_organization_id=[Organizations].Id
left join [Objects] with (nolock) on [Questions].[object_id]=[Objects].Id
left join [Buildings] with (nolock) on [Objects].builbing_id=[Buildings].Id
left join [Streets] with (nolock) on [Buildings].street_id=[Streets].Id
left join [Applicants] with (nolock) on [Appeals].applicant_id=[Applicants].Id
left join [StreetTypes] with (nolock) on [Streets].street_type_id=[StreetTypes].Id
left join [Organizations] [Organizations2] with (nolock) on [AssignmentConsiderations].[transfer_to_organization_id]=[Organizations2].Id
left join [Buildings] [Buildings5] with (nolock) on [Objects].builbing_id=[Buildings5].Id
left join [Districts] [Districts5] with (nolock) on [Buildings5].district_id=[Districts5].Id
where 
([AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code<>N''Closed'' and [AssignmentResults].code=N''NotInTheCompetence''
  and [AssignmentResolutions].name in (N''Повернуто в 1551'', N''Повернуто в батьківську організацію'') and [AssignmentConsiderations].[turn_organization_id] is not null) 

  and (case when '''+@role+N'''=N''Конролер'' and [AssignmentResolutions].name=N''Повернуто в 1551'' then 1
  when '''+@role+N'''<>N''Конролер'' and [AssignmentResolutions].name=N''Повернуто в батьківську організацію''
  then 1 end)=1
  and

'+@filters+N'
)

select Id, /*navigation, */registration_number, QuestionType, zayavnikName, adress, vykonavets, QuestionId, zayavnikId--zayavnyk, adress, null vykonavets
, short_answer, question_content, adressZ, [transfer_to_organization_id], [transfer_to_organization_name], [control_date]

 from main where --navigation, registration_number, from main
 navigation in ('+@navigation1+N')
order by Id desc
'

exec(@quere_code)
