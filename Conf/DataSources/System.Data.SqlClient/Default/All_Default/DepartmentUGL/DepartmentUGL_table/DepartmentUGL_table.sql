  --declare @user_id nvarchar(128)=N'29796543-b903-48a6-9399-4840f6eac396';
  
  declare @role nvarchar(500)=
  (select [Roles].name
  from [Positions]
  left join [Roles] on [Positions].role_id=[Roles].Id
  where [Positions].programuser_id=@user_id);


  --select @role

--declare @user_id nvarchar(300)=N'Вася';
declare @Id_all table (Id int, question_type_Id int, question_type_ids nvarchar(max));
declare @n int =1;
declare @Id int;

declare @question_type_ids nvarchar(max);
declare @QuestionTypes table(Id int);
declare @IdT table (Id int);

declare @question_type_id int;


while @n<=(select count(Id)
  from [FiltersForControler]
  where [user_id]=@user_id and [questiondirection_id] is not null)

begin

set @Id=(select Id from (select Id, [questiondirection_id], ROW_NUMBER() over(order by id) n
  from [FiltersForControler]
  where [user_id]=@user_id and [questiondirection_id] is not null and [questiondirection_id]<>0)t where n=@n);

set @question_type_id=(select [questiondirection_id] from (select Id, [questiondirection_id], ROW_NUMBER() over(order by id) n
  from [FiltersForControler]
  where [user_id]=@user_id and [questiondirection_id] is not null and [questiondirection_id]<>0)t where n=@n)


-- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
insert into @IdT(Id)
select Id from [QuestionTypes] 
where (Id=@question_type_id or question_type_id=@question_type_id) and Id not in (select Id from @IdT)

--  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
while (select count(id) from (select Id from [QuestionTypes]
where [question_type_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
and Id not in (select Id from @IdT)) q)!=0
begin

insert into @IdT
select Id from [QuestionTypes]
where [question_type_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
and Id not in (select Id from @IdT)
end 

insert into @QuestionTypes (Id)
select Id from @IdT;

set @question_type_ids=
(select stuff((select N', '+ltrim(Id)
from @QuestionTypes
for xml path('')), 1, 2, N''))


if right(ltrim(rtrim(@question_type_ids)),1) = N','
begin
	set @question_type_ids = left(ltrim(rtrim(@question_type_ids)),(len(ltrim(rtrim(@question_type_ids)))-1))
end


insert into @Id_all
(Id, question_type_Id, question_type_ids)
select @Id, @question_type_id, @question_type_ids


delete from @IdT;
delete from @QuestionTypes;

set @n=@n+1;
end;

------

 -- declare @user_id nvarchar(128)=N'Вася';
  --29796543-b903-48a6-9399-4840f6eac396
declare @Id_all2 table (Id int, department_id int, department_ids nvarchar(max));
declare @n2 int =1;
declare @Id2 int;

declare @department_ids nvarchar(max);
declare @Departmens table(Id int);
declare @IdT2 table (Id int);

declare @department_id int;


while @n2<=(select count(Id)
  from [FiltersForControler]
  where [user_id]=@user_id and [organization_id] is not null)

begin

set @Id2=(select Id from (select Id, [organization_id], ROW_NUMBER() over(order by id) n
  from [FiltersForControler]
  where [user_id]=@user_id and [organization_id] is not null) t where n=@n2);

set @department_id=(select [organization_id] from (select Id, [organization_id], ROW_NUMBER() over(order by id) n
  from [FiltersForControler]
  where [user_id]=@user_id and [organization_id] is not null) t where n=@n2)


-- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
insert into @IdT2(Id)
select Id from [Organizations] 
where (Id=@department_id or parent_organization_id=@department_id) and Id not in (select Id from @IdT2)

--  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
while (select count(id) from (select Id from [Organizations]
where [parent_organization_id] in (select Id from @IdT2) --or Id in (select Id from @IdT)
and Id not in (select Id from @IdT2)) q)!=0
begin

insert into @IdT2
select Id from [Organizations]
where [parent_organization_id] in (select Id from @IdT2) --or Id in (select Id from @IdT)
and Id not in (select Id from @IdT2)
end 
/*
insert into @Departmens (Id)
select Id from @IdT2;

set @department_ids=
(select stuff((select N', '+ltrim(Id)
from @Departmens
for xml path('')), 1, 2, N''))

insert into @Id_all2
(Id, department_id, department_ids)
select @Id2, @department_id, @department_ids


delete from @IdT2;
delete from @Departmens;
*/
set @n2=@n2+1;
end;

--  select *
--from @Departmens

set @department_ids=
(select stuff((select N', '+ltrim(Id)
from @IdT2
for xml path('')), 1, 2, N''))


declare @filters nvarchar(max)=
  (
  select N'('+case when stuff(
  (select --[district_id], [questiondirection_id],
  N' or ('+case when [district_id]=0 then N'1=1' else N'[Districts5].id='+ltrim([district_id]) end+N' and '+
  case when [questiondirection_id]=0 then N'1=1' else N'[QuestionTypes].id in ('+a.question_type_ids+N')' end+N')' 
  from [FiltersForControler] left join @Id_all a on [FiltersForControler].Id=a.Id
  where [user_id]=@user_id
  for xml path('')),1,3,N'') is null then N'1=1'
  else 
  stuff(
  (select --[district_id], [questiondirection_id],
  N' or ('+case when [district_id]=0 then N'1=1' else N'[Districts5].id='+ltrim([district_id]) end+N' and '+
  case when [questiondirection_id]=0 then N'1=1' else N'[QuestionTypes].id in ('+a.question_type_ids+N')'	 end+N')' 
  from [FiltersForControler] left join @Id_all a on [FiltersForControler].Id=a.Id
  where [user_id]=@user_id
  for xml path('')),1,3,N'')
  end+N')'
  )+case when @department_ids is null then N'' else N' and [Organizations].id in ('+@department_ids+N')' end;

declare @query_code nvarchar(max)=N'

with
navig as
(
select 1 Id, N''УГЛ'' name union all select 2 Id, N''Електронні джерела'' union all select 3 Id, N''Пріоритетне'' union all 
select 4 Id, N''Інші доручення'' union all select 5 Id, N''Зауваження''
),

nevkomp as
(
select [Assignments].Id, --[Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName,
N''УГЛ'' navigation
from 
[Assignments] left join 
[Questions] on [Assignments].question_id=[Questions].Id
left join [Appeals] on [Questions].appeal_id=[Appeals].Id
left join [ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
left join [AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
left join [AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [AssignmentConsiderations] on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
left join [AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
left join [AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left join [AssignmentRevisions] on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
left join [Organizations] on [Assignments].executor_organization_id=[Organizations].Id

left join [Objects] on [Questions].object_id=[Objects].Id
left join [Buildings] [Buildings5] on [Objects].builbing_id=[Buildings5].Id
left join [Districts] [Districts5] on [Buildings5].district_id=[Districts5].Id
where [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code<>N''Closed'' and [AssignmentResults].code=N''NotInTheCompetence''
  and [AssignmentResolutions].name in (N''Повернуто в 1551'', N''Повернуто в батьківську організацію'') 
  and [AssignmentConsiderations].[turn_organization_id] is not null

  and (case when '''+@role+N'''=N''Конролер'' and [AssignmentResolutions].name=N''Повернуто в 1551'' then 1
  when '''+@role+N'''<>N''Конролер'' and [AssignmentResolutions].name=N''Повернуто в батьківську організацію''
  then 1 end)=1 and [ReceiptSources].code=N''UGL''

  
),

doopr as
(select [Assignments].Id, --[Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName,
N''УГЛ'' navigation
from 
[Assignments] left join 
[Questions] on [Assignments].question_id=[Questions].Id
left join [Appeals] on [Questions].appeal_id=[Appeals].Id
left join [ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
left join [AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
left join [AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [AssignmentConsiderations] on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
left join [AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
left join [AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left join [AssignmentRevisions] on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
left join [Organizations] on [Assignments].executor_organization_id=[Organizations].Id

left join [Objects] on [Questions].object_id=[Objects].Id
left join [Buildings] [Buildings5] on [Objects].builbing_id=[Buildings5].Id
left join [Districts] [Districts5] on [Buildings5].district_id=[Districts5].Id
where [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''WasExplained '' and [AssignmentResolutions].code=N''Requires1551ChecksByTheController'' and [AssignmentRevisions].rework_counter in (1,2)
and  [ReceiptSources].code=N''UGL''
),

rozyasn as
(select [Assignments].Id, --[Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName,
N''УГЛ'' navigation
from 
[Assignments] left join 
[Questions] on [Assignments].question_id=[Questions].Id
left join [Appeals] on [Questions].appeal_id=[Appeals].Id
left join [ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
left join [AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
left join [AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [AssignmentConsiderations] on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
left join [AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
left join [AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left join [AssignmentRevisions] on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
left join [Organizations] on [Assignments].executor_organization_id=[Organizations].Id

left join [Objects] on [Questions].object_id=[Objects].Id
left join [Buildings] [Buildings5] on [Objects].builbing_id=[Buildings5].Id
left join [Districts] [Districts5] on [Buildings5].district_id=[Districts5].Id
where [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''WasExplained '' and [AssignmentResolutions].code=N''Requires1551ChecksByTheController''
and  [ReceiptSources].code=N''UGL''
),


prostr as
(select [Assignments].Id, --[Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName,
N''УГЛ'' navigation
from 
[Assignments] left join 
[Questions] on [Assignments].question_id=[Questions].Id
left join [Appeals] on [Questions].appeal_id=[Appeals].Id
left join [ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
left join [AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
left join [AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [AssignmentConsiderations] on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
left join [AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
left join [AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left join [AssignmentRevisions] on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
left join [Organizations] on [Assignments].executor_organization_id=[Organizations].Id

left join [Objects] on [Questions].object_id=[Objects].Id
left join [Buildings] [Buildings5] on [Objects].builbing_id=[Buildings5].Id
left join [Districts] [Districts5] on [Buildings5].district_id=[Districts5].Id
where [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''OnCheck'' and 
[AssignmentResults].code=N''WasExplained '' and [AssignmentResolutions].code=N''Requires1551ChecksByTheController'' and
[Questions].control_date<=getutcdate() 
and  [ReceiptSources].code=N''UGL''
),

plan_prog as
(select [Assignments].Id, --[Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName,
N''УГЛ'' navigation
from 
[Assignments] left join 
[Questions] on [Assignments].question_id=[Questions].Id
left join [Appeals] on [Questions].appeal_id=[Appeals].Id
left join [ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
left join [AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
left join [AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [AssignmentConsiderations] on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
left join [AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
left join [AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left join [AssignmentRevisions] on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
left join [Organizations] on [Assignments].executor_organization_id=[Organizations].Id

left join [Objects] on [Questions].object_id=[Objects].Id
left join [Buildings] [Buildings5] on [Objects].builbing_id=[Buildings5].Id
left join [Districts] [Districts5] on [Buildings5].district_id=[Districts5].Id
where [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''ItIsNotPossibleToPerformThisPeriod'' and [AssignmentResolutions].code=N''RequiresFunding_IncludedInThePlan''
and  [ReceiptSources].code=N''UGL''
),

vykon as
(select [Assignments].Id, --[Organizations].Id OrganizationsId, [Organizations].short_name OrganizationsName,
N''УГЛ'' navigation
from 
[Assignments] left join 
[Questions] on [Assignments].question_id=[Questions].Id
left join [Appeals] on [Questions].appeal_id=[Appeals].Id
left join [ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
left join [AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
left join [AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [AssignmentConsiderations] on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
left join [AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
left join [AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left join [AssignmentRevisions] on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
left join [Organizations] on [Assignments].executor_organization_id=[Organizations].Id

left join [Objects] on [Questions].object_id=[Objects].Id
left join [Buildings] [Buildings5] on [Objects].builbing_id=[Buildings5].Id
left join [Districts] [Districts5] on [Buildings5].district_id=[Districts5].Id
where [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''Done''
and  [ReceiptSources].code=N''UGL''
)

, main as
(select Id, navigation, N''neVKompetentsii'' name
from nevkomp
union all
select Id, navigation, N''doopratsiovani'' name
from doopr
union all
select Id, navigation, N''rozyasneno'' name
from rozyasn
union all
select Id, navigation, N''prostrocheni'' name
from prostr
union all
select Id, navigation, N''neVykonNeMozhl'' name
from plan_prog
union all
select Id, navigation, N''vykon'' name
from vykon
)

, main_main as
(
select 1 Id, navigation, isnull([neVKompetentsii], 0) [neVKompetentsii], isnull([doopratsiovani], 0) [doopratsiovani], 
isnull([rozyasneno], 0) [rozyasneno], isnull([prostrocheni], 0) [prostrocheni], isnull([neVykonNeMozhl], 0) [neVykonNeMozhl]
,isnull([vykon], 0) [vykon]
from main
pivot
( count(Id) for name in ([neVKompetentsii], [doopratsiovani], [rozyasneno], [vykon], [prostrocheni], [neVykonNeMozhl])
) pvt

)
 
select Id, navigation, [neVKompetentsii], [doopratsiovani], [rozyasneno], [vykon], [prostrocheni], [neVykonNeMozhl]
from main_main
union all
select 7, N''Сума'', sum([neVKompetentsii]), sum([doopratsiovani]), sum([rozyasneno]), sum([vykon]), sum([prostrocheni]), sum([neVykonNeMozhl])
from main_main 

'
--select @query_code
exec(@query_code)