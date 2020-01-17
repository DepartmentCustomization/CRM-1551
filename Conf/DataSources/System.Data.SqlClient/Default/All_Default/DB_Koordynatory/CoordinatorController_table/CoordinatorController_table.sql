/*


declare @user_id nvarchar(300)=N'29796543-b903-48a6-9399-4840f6eac396';--N'Вася';
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

  --select @question_type_ids
  --select @department_ids
  --select @filters

  if object_id('tempdb..#temp_navig') is not null drop table #temp_navig
  select Id, name
  into #temp_navig
  from (
  select 1 Id, N'УГЛ' name union all select 2 Id, N'Електронні джерела' union all select 3 Id, N'Пріоритетне' union all 
select 4 Id, N'Інші доручення' union all select 5 Id, N'Зауваження') e

if object_id('tempdb..#temp_nevkomp') is not null drop table #temp_nevkomp
create table #temp_nevkomp (Id int, navigation nvarchar(70))
insert into #temp_nevkomp
(Id, navigation)
exec(N'select [Assignments].Id, --[Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName,
case when [ReceiptSources].code=N''UGL'' then 1--N''УГЛ''
when [ReceiptSources].code in (N''Website_mob.addition'', N''Mail'') then 2--N''Електронні джерела надходження''
when [QuestionTypes].emergency=N''true'' then 3-- N''Пріоритетне''
when [QuestionTypes].parent_organization_is=N''true'' then 5--N''Зауваження''
else 4-- N''Інші доручення''
end navigation
from 
[Assignments] with (nolock) inner join 
[Questions] with (nolock) on [Assignments].question_id=[Questions].Id
inner join [Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
inner join [ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
left join [AssignmentTypes] with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id
inner join [AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [AssignmentConsiderations] with (nolock) on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
left join [AssignmentResults] with (nolock) on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
inner join [AssignmentResolutions] with (nolock) on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left join [AssignmentRevisions] with (nolock) on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
inner join [Organizations] with (nolock) on [Assignments].executor_organization_id=[Organizations].Id

left join [Objects] with (nolock) on [Questions].object_id=[Objects].Id
left join [Buildings]  [Buildings5] with (nolock) on [Objects].builbing_id=[Buildings5].Id
left join [Districts] [Districts5] with (nolock) on [Buildings5].district_id=[Districts5].Id
where [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code<>N''Closed'' and [AssignmentResults].code=N''NotInTheCompetence''
  and [AssignmentResolutions].name in (N''Повернуто в 1551'', N''Повернуто в батьківську організацію'') 
  and [AssignmentConsiderations].[turn_organization_id] is not null

  and (case when '''+@role+N'''=N''Конролер'' and [AssignmentResolutions].name=N''Повернуто в 1551'' then 1
  when '''+@role+N'''<>N''Конролер'' and [AssignmentResolutions].name=N''Повернуто в батьківську організацію''
  then 1 end)=1

  and '+@filters)
--  CREATE CLUSTERED INDEX ix_temp_main ON #temp_nevkomp ([Id]);  
--CREATE NONCLUSTERED INDEX ix_temp_main2 ON #temp_nevkomp ([Id], [navigation]);



  if object_id('tempdb..#temp_doopr') is not null drop table #temp_doopr
create table #temp_doopr (Id int, navigation nvarchar(70))
insert into #temp_doopr
(Id, navigation)
exec(N'select [Assignments].Id, --[Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName,
case when [ReceiptSources].code=N''UGL'' then 1--N''УГЛ''
when [ReceiptSources].code in (N''Website_mob.addition'', N''Mail'') then 2--N''Електронні джерела надходження''
when [QuestionTypes].emergency=N''true'' then 3-- N''Пріоритетне''
when [QuestionTypes].parent_organization_is=N''true'' then 5--N''Зауваження''
else 4-- N''Інші доручення''
end navigation
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
left join [AssignmentRevisions] with (nolock) on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
inner join [Organizations] with (nolock) on [Assignments].executor_organization_id=[Organizations].Id

left join [Objects] with (nolock) on [Questions].object_id=[Objects].Id
left join [Buildings] [Buildings5] with (nolock) on [Objects].builbing_id=[Buildings5].Id
left join [Districts] [Districts5] with (nolock) on [Buildings5].district_id=[Districts5].Id
where [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''WasExplained '' and [AssignmentResolutions].code=N''Requires1551ChecksByTheController'' and [AssignmentRevisions].rework_counter in (1,2)
and '+@filters)
--  CREATE CLUSTERED INDEX ix_temp_main ON #temp_doopr ([Id]);  
--CREATE NONCLUSTERED INDEX ix_temp_main2 ON #temp_doopr ([Id], [navigation]);


  if object_id('tempdb..#temp_rozyasn') is not null drop table #temp_rozyasn
create table #temp_rozyasn (Id int, navigation nvarchar(70))
insert into #temp_rozyasn
(Id, navigation)
exec(N'select [Assignments].Id, --[Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName,
case when [ReceiptSources].code=N''UGL'' then 1--N''УГЛ''
when [ReceiptSources].code in (N''Website_mob.addition'', N''Mail'') then 2--N''Електронні джерела надходження''
when [QuestionTypes].emergency=N''true'' then 3-- N''Пріоритетне''
when [QuestionTypes].parent_organization_is=N''true'' then 5--N''Зауваження''
else 4-- N''Інші доручення''
end navigation
from 
[Assignments] with (nolock) inner join 
[Questions] with (nolock) on [Assignments].question_id=[Questions].Id
inner join [Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
inner join [ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
inner join [AssignmentTypes] with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id
inner join [AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [AssignmentConsiderations] with (nolock) on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
inner join [AssignmentResults] with (nolock) on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
inner join [AssignmentResolutions] with (nolock) on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left join [AssignmentRevisions] with (nolock) on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
inner join [Organizations] with (nolock) on [Assignments].executor_organization_id=[Organizations].Id

left join [Objects] with (nolock) on [Questions].object_id=[Objects].Id
left join [Buildings] [Buildings5] with (nolock) on [Objects].builbing_id=[Buildings5].Id
left join [Districts] [Districts5] with (nolock) on [Buildings5].district_id=[Districts5].Id
where [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''WasExplained '' and [AssignmentResolutions].code=N''Requires1551ChecksByTheController''
and '+@filters)
--  CREATE CLUSTERED INDEX ix_temp_main ON #temp_rozyasn ([Id]);  
--CREATE NONCLUSTERED INDEX ix_temp_main2 ON #temp_rozyasn ([Id], [navigation]);


if object_id('tempdb..#temp_prostr') is not null drop table #temp_prostr
create table #temp_prostr (Id int, navigation nvarchar(70))
insert into #temp_prostr
(Id, navigation)
exec(N'select [Assignments].Id, --[Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName,
case when [ReceiptSources].code=N''UGL'' then 1--N''УГЛ''
when [ReceiptSources].code in (N''Website_mob.addition'', N''Mail'') then 2--N''Електронні джерела надходження''
when [QuestionTypes].emergency=N''true'' then 3-- N''Пріоритетне''
when [QuestionTypes].parent_organization_is=N''true'' then 5--N''Зауваження''
else 4-- N''Інші доручення''
end navigation
from 
[Assignments] with (nolock) inner join 
[Questions] with (nolock) on [Assignments].question_id=[Questions].Id
inner join [Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
inner join [ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
inner join [AssignmentTypes] with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id
inner join [AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [AssignmentConsiderations] with (nolock) on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
inner join [AssignmentResults] with (nolock) on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
inner join [AssignmentResolutions] with (nolock) on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left join [AssignmentRevisions] with (nolock) on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
inner join [Organizations] with (nolock) on [Assignments].executor_organization_id=[Organizations].Id

left join [Objects] with (nolock) on [Questions].object_id=[Objects].Id
left join [Buildings] [Buildings5] with (nolock) on [Objects].builbing_id=[Buildings5].Id
left join [Districts] [Districts5] with (nolock) on [Buildings5].district_id=[Districts5].Id
where [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''OnCheck'' and 
[AssignmentResults].code=N''WasExplained '' and [AssignmentResolutions].code=N''Requires1551ChecksByTheController'' and
[Questions].control_date<=getutcdate() 
and '+@filters)
--CREATE CLUSTERED INDEX ix_temp_main ON #temp_prostr ([Id]);  
--CREATE NONCLUSTERED INDEX ix_temp_main2 ON #temp_prostr ([Id], [navigation]);


if object_id('tempdb..#temp_plan_prog') is not null drop table #temp_plan_prog
create table #temp_plan_prog (Id int, navigation nvarchar(70))
insert into #temp_plan_prog
(Id, navigation)
exec(N'select [Assignments].Id, --[Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName,
case when [ReceiptSources].code=N''UGL'' then 1--N''УГЛ''
when [ReceiptSources].code in (N''Website_mob.addition'', N''Mail'') then 2--N''Електронні джерела надходження''
when [QuestionTypes].emergency=N''true'' then 3-- N''Пріоритетне''
when [QuestionTypes].parent_organization_is=N''true'' then 5--N''Зауваження''
else 4-- N''Інші доручення''
end navigation
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
left join [AssignmentRevisions] with (nolock) on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
inner join [Organizations] with (nolock) on [Assignments].executor_organization_id=[Organizations].Id

left join [Objects] with (nolock) on [Questions].object_id=[Objects].Id
left join [Buildings] [Buildings5] with (nolock) on [Objects].builbing_id=[Buildings5].Id
left join [Districts] [Districts5] with (nolock) on [Buildings5].district_id=[Districts5].Id
where [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''ItIsNotPossibleToPerformThisPeriod'' and [AssignmentResolutions].code=N''RequiresFunding_IncludedInThePlan''
and '+@filters)
--CREATE CLUSTERED INDEX ix_temp_main ON #temp_plan_prog ([Id]);  
--CREATE NONCLUSTERED INDEX ix_temp_main2 ON #temp_plan_prog ([Id], [navigation]);


if object_id('tempdb..#temp_main') is not null drop table #temp_main
select Id, navigation, name
into #temp_main
from
(select Id, navigation, N'neVKompetentsii' name
from #temp_nevkomp
union all
select Id, navigation, N'doopratsiovani' name
from #temp_doopr
union all
select Id, navigation, N'rozyasneno' name
from #temp_rozyasn
union all
select Id, navigation, N'prostrocheni' name
from #temp_prostr
union all
select Id, navigation, N'neVykonNeMozhl' name
from #temp_plan_prog) f
CREATE CLUSTERED INDEX ix_temp_main ON #temp_main ([Id]);  
CREATE NONCLUSTERED INDEX ix_temp_main2 ON #temp_main ([Id], [navigation]);


if object_id('tempdb..#temp_main_main') is not null drop table #temp_main_main

select Id, name, isnull([neVKompetentsii], 0) [neVKompetentsii], isnull([doopratsiovani], 0) [doopratsiovani], 
isnull([rozyasneno], 0) [rozyasneno], isnull([prostrocheni], 0) [prostrocheni], isnull([neVykonNeMozhl], 0) [neVykonNeMozhl]
into #temp_main_main
from
(select #temp_navig.Id, #temp_navig.name, main.name main_name, cc
from #temp_navig left join 
(select navigation, name, count(Id) cc from #temp_main group by navigation, name) main on #temp_navig.Id=main.navigation ) t
pivot
( sum(cc) for main_name in ([neVKompetentsii], [doopratsiovani], [rozyasneno], [prostrocheni], [neVykonNeMozhl])
) pvt

select Id, navigation, [neVKompetentsii], [doopratsiovani], [rozyasneno], [prostrocheni], [neVykonNeMozhl]
from
(select Id, name navigation, [neVKompetentsii], [doopratsiovani], [rozyasneno], [prostrocheni], [neVykonNeMozhl]
from #temp_main_main
union all
select 7, N'Сума', sum([neVKompetentsii]), sum([doopratsiovani]), sum([rozyasneno]), sum([prostrocheni]), sum([neVykonNeMozhl])
from #temp_main_main) r
order by id 


--select @filters
-- Write Your Query

--select @filters, @question_type_ids, @department_ids
