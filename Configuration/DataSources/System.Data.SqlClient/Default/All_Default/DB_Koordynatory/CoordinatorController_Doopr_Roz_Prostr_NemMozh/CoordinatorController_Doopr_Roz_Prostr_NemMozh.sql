/*
declare @navigation nvarchar(400)=N'Усі';
declare @column nvarchar(400)=N'Прострочені';--N'План / Програма';
declare @user_id nvarchar(128)=N'29796543-b903-48a6-9399-4840f6eac396';
*/

declare @comment_ros nvarchar(6)=(select case when @column=N'Роз`яcнено' then N' ' else N'--' end);
declare @comment_doopr nvarchar(6)=(select case when @column=N'Доопрацьовані' then N' ' else N'--' end);
declare @comment_prostr nvarchar(6)=(select case when @column=N'Прострочені' then N' ' else N'--' end);
declare @comment_nemozh nvarchar(6)=(select case when @column=N'План / Програма' then N' ' else N'--' end);


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
  case when @department_ids is null then N' or (1=2)' else N' or ('+@department_ids+N')' end)+N')';

declare @navigation1 nvarchar(400)=(select case when @navigation=N'Усі' then N'(N''Інші доручення'', N''УГЛ'', N''Зауваження'', N''Електронні джерела'', N''Пріоритетне'')' else N'(N'''+@navigation+N''')' end)


declare @exec1 nvarchar(max)=N'
select [Assignments].Id, [Organizations].Id OrganizationsId, 

case when len([Organizations].[head_name]) > 5 then [Organizations].[head_name] + '' ( '' + [Organizations].[short_name] + '')''
					else [Organizations].[short_name] end

 OrganizationsName,
[Applicants].full_name zayavnykName, [StreetTypes].shortname+N'' ''+Streets.name+N'', ''+[Buildings].name adress, [Questions].registration_number,
[QuestionTypes].name QuestionType,

case when [ReceiptSources].code=N''UGL'' then N''УГЛ'' 
when [ReceiptSources].code=N''Website_mob.addition'' or [ReceiptSources].code=N''Mail'' then N''Електронні джерела''
when [QuestionTypes].emergency=N''true'' then N''Пріоритетне''
when [QuestionTypes].parent_organization_is=N''true'' then N''Зауваження''
else N''Інші доручення''
end navigation,

 
 [Applicants].Id zayavnykId, [Questions].Id QuestionId, [Organizations].short_name vykonavets,
 convert(datetime, dateadd(HH, [execution_term], [Assignments].registration_date)) control_date
,[rework_counter].rework_counter, [AssignmentConsiderations].short_answer, [Questions].question_content

,[Applicants].[ApplicantAdress] adressZ

 ,[Organizations2].Id [transfer_to_organization_id]
 ,[Organizations2].[short_name] [transfer_to_organization_name]

from 
[Assignments] with (nolock) inner join 
[Questions] with (nolock) on [Assignments].question_id=[Questions].Id
inner join [Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
inner join [ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
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
left join [AssignmentRevisions] with (nolock) on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
left join [StreetTypes] with (nolock) on [Streets].street_type_id=[StreetTypes].Id

left join (select count(AssignmentRevisions.id) rework_counter, AssignmentConsiderations.assignment_id
from AssignmentRevisions with (nolock)
inner join AssignmentConsiderations on AssignmentRevisions.assignment_consideration_іd=AssignmentConsiderations.Id
where AssignmentRevisions.control_result_id = 5
group by AssignmentConsiderations.assignment_id) rework_counter on Assignments.Id=rework_counter.assignment_id



  left join [Organizations] [Organizations2] with (nolock) on [AssignmentConsiderations].[transfer_to_organization_id]=[Organizations2].Id


left join [Buildings] [Buildings5] with (nolock) on [Objects].builbing_id=[Buildings5].Id
left join [Districts] [Districts5] with (nolock) on [Buildings5].district_id=[Districts5].Id
where '+@filters+N'
and 
'+@comment_doopr+N'( [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''WasExplained '' and [AssignmentResolutions].code=N''Requires1551ChecksByTheController'' and [AssignmentRevisions].rework_counter in (1,2))
 '+@comment_ros+N'( [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''WasExplained '' and [AssignmentResolutions].code=N''Requires1551ChecksByTheController'')
 '+@comment_prostr+N'( [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''WasExplained '' and [AssignmentResolutions].code=N''Requires1551ChecksByTheController'' and [Questions].control_date<=getutcdate())
 '+@comment_nemozh+N' ([AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''ItIsNotPossibleToPerformThisPeriod'' and [AssignmentResolutions].code=N''RequiresFunding_IncludedInThePlan'')
'

 declare @exec_resulr nvarchar(max)=N'
  with

main as
('+@exec1
+N') select  Id, registration_number, zayavnykName, control_date, zayavnykId, QuestionType, adress,  QuestionId, 
OrganizationsName,
 rework_counter, short_answer, question_content, adressZ, [transfer_to_organization_id], [transfer_to_organization_name]
 from main where 

 navigation in'+ @navigation1+N'
 --and #filter_columns#
order by Id desc'


exec(@exec_resulr)



-- /*
-- declare @navigation nvarchar(400)=N'Усі';
-- declare @column nvarchar(400)=N'Прострочені';--N'План / Програма';
-- declare @user_id nvarchar(128)=N'29796543-b903-48a6-9399-4840f6eac396';
-- */

-- declare @comment_ros nvarchar(6)=(select case when @column=N'Роз`яcнено' then N' ' else N'--' end);
-- declare @comment_doopr nvarchar(6)=(select case when @column=N'Доопрацьовані' then N' ' else N'--' end);
-- declare @comment_prostr nvarchar(6)=(select case when @column=N'Прострочені' then N' ' else N'--' end);
-- declare @comment_nemozh nvarchar(6)=(select case when @column=N'План / Програма' then N' ' else N'--' end);

-- /*
-- declare @user_id nvarchar(300)=N'Вася';
-- declare @organization_id int =6704;
-- declare @navigation nvarchar(400)=N'Усі';
-- */
--   declare @role0 nvarchar(500)=
--   (select [Roles].name
--   from [Positions]
--   left join [Roles] on [Positions].role_id=[Roles].Id
--   where [Positions].programuser_id=@user_id);

--   declare @role nvarchar(500)=case when @role0 is null then N'qqqq' else @role0 end 
-- -- declare @navigation1 nvarchar(500);
-- -- --declare @NavigationTable table(Id nvarchar(400));

-- -- if @navigation=N'Усі'
-- -- begin
-- --  set @navigation1=N'N''Інші доручення'', N''УГЛ'', N''Зауваження'', N''Електронні джерела'', N''Пріоритетне'''
-- -- end
-- -- else
-- -- begin
-- --  set @navigation1=N'N'''+@navigation+N''''
-- -- end;

-- --select @navigation1

-- --declare @user_id nvarchar(300)=N'Вася';
-- declare @Id_all table (Id int, question_type_Id int, question_type_ids nvarchar(max));
-- declare @n int =1;
-- declare @Id int;

-- declare @question_type_ids nvarchar(max);
-- declare @QuestionTypes table(Id int);
-- declare @IdT table (Id int);

-- declare @question_type_id int;


-- while @n<=(select count(Id)
--   from [FiltersForControler]
--   where [user_id]=@user_id and [questiondirection_id] is not null)

-- begin

-- set @Id=(select Id from (select Id, [questiondirection_id], ROW_NUMBER() over(order by id) n
--   from [FiltersForControler]
--   where [user_id]=@user_id and [questiondirection_id] is not null and [questiondirection_id]<>0)t where n=@n);

-- set @question_type_id=(select [questiondirection_id] from (select Id, [questiondirection_id], ROW_NUMBER() over(order by id) n
--   from [FiltersForControler]
--   where [user_id]=@user_id and [questiondirection_id] is not null and [questiondirection_id]<>0)t where n=@n)


-- -- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
-- insert into @IdT(Id)
-- select Id from [QuestionTypes] 
-- where (Id=@question_type_id or question_type_id=@question_type_id) and Id not in (select Id from @IdT)

-- --  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
-- while (select count(id) from (select Id from [QuestionTypes]
-- where [question_type_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
-- and Id not in (select Id from @IdT)) q)!=0
-- begin

-- insert into @IdT
-- select Id from [QuestionTypes]
-- where [question_type_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
-- and Id not in (select Id from @IdT)
-- end 

-- insert into @QuestionTypes (Id)
-- select Id from @IdT;

-- set @question_type_ids=
-- (select stuff((select N', '+ltrim(Id)
-- from @QuestionTypes
-- for xml path('')), 1, 2, N''))

-- insert into @Id_all
-- (Id, question_type_Id, question_type_ids)
-- select @Id, @question_type_id, @question_type_ids

-- /*
-- delete from @IdT;
-- delete from @QuestionTypes;
-- */
-- set @n=@n+1;
-- end;

-- ------на РДА
-- declare @Id_all3 table (Id int, rda_Id int, rda_ids nvarchar(max));
-- declare @n3 int =1;
-- declare @Id3 int;

-- declare @rda_ids nvarchar(max);
-- declare @RDA table(Id int);
-- declare @IdT3 table (Id int);

-- declare @rda_id int;


-- while @n3<=(select count(Id)
--   from [FiltersForControler]
--   where [user_id]=@user_id and [district_id] is not null)

-- begin

-- set @Id3=(select Id from (select Id, [district_id], ROW_NUMBER() over(order by id) n
--   from [FiltersForControler]
--   where [user_id]=@user_id and [district_id] is not null and [district_id]<>0)t where n=@n3);

-- set @rda_id=(select [district_id] from (select Id, [district_id], ROW_NUMBER() over(order by id) n
--   from [FiltersForControler]
--   where [user_id]=@user_id and [district_id] is not null and [district_id]<>0)t where n=@n3)


-- -- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
-- insert into @IdT3(Id)
-- select Id from [Organizations] 
-- where (Id=@rda_id or parent_organization_id=@rda_id) and Id not in (select Id from @IdT3)

-- --  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
-- while (select count(id) from (select Id from [Organizations]
-- where [parent_organization_id] in (select Id from @IdT3) --or Id in (select Id from @IdT)
-- and Id not in (select Id from @IdT3)) q)!=0
-- begin

-- insert into @IdT3
-- select Id from [Organizations]
-- where [parent_organization_id] in (select Id from @IdT3) --or Id in (select Id from @IdT)
-- and Id not in (select Id from @IdT3)
-- end 

-- insert into @RDA (Id)
-- select Id from @IdT3;

-- set @rda_ids=
-- (select stuff((select N', '+ltrim(Id)
-- from @RDA
-- for xml path('')), 1, 2, N''))

-- insert into @Id_all3
-- (Id, rda_Id, rda_ids)
-- select @Id3, @rda_id, @rda_ids

-- /*
-- delete from @IdT3;
-- delete from @RDA;
-- */
-- set @n3=@n3+1;
-- end;

-- ------

--  -- declare @user_id nvarchar(128)=N'Вася';
--   --29796543-b903-48a6-9399-4840f6eac396
-- declare @Id_all2 table (Id int, department_id int, department_ids nvarchar(max));
-- declare @n2 int =1;
-- declare @Id2 int;

-- declare @department_ids nvarchar(max);
-- declare @Departmens table(Id int);
-- declare @IdT2 table (Id int);

-- declare @department_id int;


-- while @n2<=(select count(Id)
--   from [FiltersForControler]
--   where [user_id]=@user_id and [organization_id] is not null)

-- begin

-- set @Id2=(select Id from (select Id, [organization_id], ROW_NUMBER() over(order by id) n
--   from [FiltersForControler]
--   where [user_id]=@user_id and [organization_id] is not null) t where n=@n2);

-- set @department_id=(select [organization_id] from (select Id, [organization_id], ROW_NUMBER() over(order by id) n
--   from [FiltersForControler]
--   where [user_id]=@user_id and [organization_id] is not null) t where n=@n2)


-- -- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
-- insert into @IdT2(Id)
-- select Id from [Organizations] 
-- where (Id=@department_id or parent_organization_id=@department_id) and Id not in (select Id from @IdT2)

-- --  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
-- while (select count(id) from (select Id from [Organizations]
-- where [parent_organization_id] in (select Id from @IdT2) --or Id in (select Id from @IdT)
-- and Id not in (select Id from @IdT2)) q)!=0
-- begin

-- insert into @IdT2
-- select Id from [Organizations]
-- where [parent_organization_id] in (select Id from @IdT2) --or Id in (select Id from @IdT)
-- and Id not in (select Id from @IdT2)
-- end 


-- set @n2=@n2+1;
-- end;

-- set @department_ids=
-- (select stuff((select N', '+ltrim(Id)
-- from @IdT2
-- for xml path('')), 1, 2, N''))


-- declare @filters nvarchar(max)=
--   (
--   select N'(('+case when stuff(
--   (select --[district_id], [questiondirection_id],
--   N' or ('+case when [district_id]=0 then N'1=1' else N'[Organizations].id in ('+a3.rda_ids+N')' end+N' and '+
--   case when [questiondirection_id]=0 then N'1=1' else N'[QuestionTypes].id in ('+a.question_type_ids+N')' end+N')' 
--   from [FiltersForControler] left join @Id_all a on [FiltersForControler].Id=a.Id
--   left join @Id_all3 a3 on [FiltersForControler].Id=a3.Id
--   where [user_id]=@user_id
--   for xml path('')),1,3,N'') is null then N'1=2'
--   else 
--   stuff(
--   (select --[district_id], [questiondirection_id],
--   N' or ('+case when [district_id]=0 then N'1=1' else N'[Organizations].id in ('+a3.rda_ids+N')' end+N' and '+
--   case when [questiondirection_id]=0 then N'1=1' else N'[QuestionTypes].id in ('+a.question_type_ids+N')'	 end+N')' 
--   from [FiltersForControler] left join @Id_all a on [FiltersForControler].Id=a.Id
--   left join @Id_all3 a3 on [FiltersForControler].Id=a3.Id
--   where [user_id]=@user_id
--   for xml path('')),1,3,N'')
--   end+N')'
--   )+case when @department_ids is null then N'' else N' or [Organizations].id in ('+@department_ids+N')' end+N')';


-- declare @navigation1 nvarchar(400)=(select case when @navigation=N'Усі' then N'(N''Інші доручення'', N''УГЛ'', N''Зауваження'', N''Електронні джерела'', N''Пріоритетне'')' else N'(N'''+@navigation+N''')' end)


-- declare @exec1 nvarchar(max)=N'
-- select [Assignments].Id, [Organizations].Id OrganizationsId, 

-- case when len([Organizations].[head_name]) > 5 then [Organizations].[head_name] + '' ( '' + [Organizations].[short_name] + '')''
-- 					else [Organizations].[short_name] end

--  OrganizationsName,
-- [Applicants].full_name zayavnykName, [StreetTypes].shortname+N'' ''+Streets.name+N'', ''+[Buildings].name adress, [Questions].registration_number,
-- [QuestionTypes].name QuestionType,

-- case when [ReceiptSources].code=N''UGL'' then N''УГЛ'' 
-- when [ReceiptSources].code=N''Website_mob.addition'' or [ReceiptSources].code=N''Mail'' then N''Електронні джерела''
-- when [QuestionTypes].emergency=N''true'' then N''Пріоритетне''
-- when [QuestionTypes].parent_organization_is=N''true'' then N''Зауваження''
-- else N''Інші доручення''
-- end navigation,

 
--  [Applicants].Id zayavnykId, [Questions].Id QuestionId, [Organizations].short_name vykonavets,
--  convert(datetime, dateadd(HH, [execution_term], [Assignments].registration_date)) control_date
-- ,[rework_counter].rework_counter, [AssignmentConsiderations].short_answer, [Questions].question_content

-- ,[Applicants].[ApplicantAdress] adressZ

--  ,[Organizations2].Id [transfer_to_organization_id]
--  ,[Organizations2].[short_name] [transfer_to_organization_name]

-- from 
-- [Assignments] left join 
-- [Questions] on [Assignments].question_id=[Questions].Id
-- left join [Appeals] on [Questions].appeal_id=[Appeals].Id
-- left join [ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
-- left join [QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
-- left join [AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
-- left join [AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
-- -- left join [AssignmentConsiderations] on [Assignments].Id=[AssignmentConsiderations].assignment_id
-- left join [AssignmentConsiderations] on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
-- left join [AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
-- left join [AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
-- left join [Organizations] on [Assignments].executor_organization_id=[Organizations].Id
-- left join [Objects] on [Questions].[object_id]=[Objects].Id
-- left join [Buildings] on [Objects].builbing_id=[Buildings].Id
-- left join [Streets] on [Buildings].street_id=[Streets].Id
-- left join [Applicants] on [Appeals].applicant_id=[Applicants].Id
-- left join [AssignmentRevisions] on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
-- left join [StreetTypes] on [Streets].street_type_id=[StreetTypes].Id

-- left join (select count(AssignmentRevisions.id) rework_counter, AssignmentConsiderations.assignment_id
-- from AssignmentRevisions 
-- inner join AssignmentConsiderations on AssignmentRevisions.assignment_consideration_іd=AssignmentConsiderations.Id
-- where AssignmentRevisions.control_result_id = 5
-- group by AssignmentConsiderations.assignment_id) rework_counter on Assignments.Id=rework_counter.assignment_id



--   left join [Organizations] [Organizations2] on [AssignmentConsiderations].[transfer_to_organization_id]=[Organizations2].Id


-- left join [Buildings] [Buildings5] on [Objects].builbing_id=[Buildings5].Id
-- left join [Districts] [Districts5] on [Buildings5].district_id=[Districts5].Id
-- where '+@filters+N'
-- and 
-- '+@comment_doopr+N'( [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''WasExplained '' and [AssignmentResolutions].code=N''Requires1551ChecksByTheController'' and [AssignmentRevisions].rework_counter in (1,2))
--  '+@comment_ros+N'( [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''WasExplained '' and [AssignmentResolutions].code=N''Requires1551ChecksByTheController'')
--  '+@comment_prostr+N'( [AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''WasExplained '' and [AssignmentResolutions].code=N''Requires1551ChecksByTheController'' and [Questions].control_date<=getutcdate())
--  '+@comment_nemozh+N' ([AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''ItIsNotPossibleToPerformThisPeriod'' and [AssignmentResolutions].code=N''RequiresFunding_IncludedInThePlan'')
-- '

--  declare @exec_resulr nvarchar(max)=N'
--   with

-- main as
-- ('+@exec1
-- +N') select  Id, registration_number, zayavnykName, control_date, zayavnykId, QuestionType, adress,  QuestionId, 
-- OrganizationsName,
--  rework_counter, short_answer, question_content, adressZ, [transfer_to_organization_id], [transfer_to_organization_name]
--  from main where 

--  navigation in'+ @navigation1+N'
--  --and #filter_columns#
-- order by Id desc'


-- exec(@exec_resulr)
