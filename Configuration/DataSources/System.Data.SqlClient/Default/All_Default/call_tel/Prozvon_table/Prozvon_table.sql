  
  --declare @filter nvarchar(3000)=N'district in (1, 2, 3)'; --question_type in (50) district in (1, 2, 3) question_list_state in (1)
  --declare @sort nvarchar(3000)=N'1=1';

  ---перелік параметры начало
  declare @comment_qls nvarchar(5);
  declare @de_comment nvarchar(5);

  set @comment_qls =(
  select case when CHARINDEX(N'question_list_state in (', @filter, 0)>0
  then N'' else N'--' end);

  set @de_comment = case when @comment_qls=N'--' then N'' else N'--' end;

  ---перелік параметры конец
  --select @comment_qls, @de_comment

 declare @sort1 nvarchar(3000)=case when @sort=N'1=1' then N'QuestionType_sort' 
 else replace(replace(@sort, N' asc', N'_sort asc'), N' desc', N'_sort desc') end;

 --select @sort1

 --select CHARINDEX(N'question_type in (', @filter, 0), -- с какого по номеру символа начинается
 --len(N'question_type in ('), --длинна того что начинается
 --CHARINDEX(N')', @filter, CHARINDEX(N'question_type in (', @filter, 0)),--найти на чем заканчиваетя
 --CHARINDEX(N'(', @filter, CHARINDEX(N'question_type in (', @filter, 0)),-- найти с чего начинается
 --SUBSTRING(@filter, CHARINDEX(N'(', @filter, CHARINDEX(N'question_type in (', @filter, 0))+1, CHARINDEX(N')', @filter, CHARINDEX(N'question_type in (', @filter, 0))-CHARINDEX(N'(', @filter, CHARINDEX(N'question_type in (', @filter, 0))-1)  --то что в середине

 declare @question_type_id_list nvarchar(max);
	if CHARINDEX(N'question_type in (', @filter, 0)>=1
	begin
		 set @question_type_id_list =
		 (select  SUBSTRING(@filter, CHARINDEX(N'(', @filter, CHARINDEX(N'question_type in (', @filter, 0))+1, CHARINDEX(N')', @filter, CHARINDEX(N'question_type in (', @filter, 0))-CHARINDEX(N'(', @filter, CHARINDEX(N'question_type in (', @filter, 0))-1)  --то что в середине
		)
    end
--select @question_type_id_list


declare @input_str_qt nvarchar(100) =@question_type_id_list+N',' --N'13,12,34,56,'
 
-- создаем таблицу в которую будем
-- записывать наши айдишники
declare @table_qt table (id int)
 
-- создаем переменную, хранящую разделитель
declare @delimeter_qt nvarchar(1) = ','
 
-- определяем позицию первого разделителя
declare @pos_qt int = charindex(@delimeter_qt,@input_str_qt)
 
-- создаем переменную для хранения
-- одного айдишника
declare @id_qt nvarchar(10)
    
while (@pos_qt != 0)
begin
    -- получаем айдишник
    set @id_qt = SUBSTRING(@input_str_qt, 1, @pos_qt-1)
    -- записываем в таблицу
    insert into @table_qt (id) values(cast(@id_qt as int))
    -- сокращаем исходную строку на
    -- размер полученного айдишника
    -- и разделителя
    set @input_str_qt = SUBSTRING(@input_str_qt, @pos_qt+1, LEN(@input_str_qt))
    -- определяем позицию след. разделителя
    set @pos_qt = CHARINDEX(@delimeter_qt,@input_str_qt)
end

declare @questions_children nvarchar(max)=(

select STUFF((
select N', '+[QuestionTypesAndParent].QuestionTypes
from @table_qt tqt
inner join [QuestionTypesAndParent] with (nolock) on tqt.id=[QuestionTypesAndParent].ParentId
for xml path('')),1,2,N'')
)

--select @questions_children questions_children


 declare @filter1 nvarchar(max)=
 case when CHARINDEX(N'question_type in (', @filter, 0)>0
 then
 REPLACE(@filter, N'question_type in ('+@question_type_id_list+N')', 
 N'question_type in ('+@questions_children+N')')
else @filter
end

--select @filter1

 -----------------------------
 declare @qcode nvarchar(max)=N'

 select ROW_NUMBER() OVER (Order by (select 1)) as rn,
 Id, registration_number, QuestionType, full_name, phone_number, DistrictName District,
 house, place_problem, vykon, zmist, comment, [history], ApplicantsId, BuildingId, [Organizations_Id],
 cc_nedozvon, entrance, [edit_date], [control_comment], [registration_date]
 
 from
 (
 select [Assignments].Id, [Questions].registration_number, ltrim([QuestionTypes].name) QuestionType,
  [Applicants].full_name, [ApplicantPhones].phone_number, [Districts].Id District,
  [Districts].Name DistrictName,
  isnull([StreetTypes].shortname+N'' '',N'''')+
  isnull([Streets].name+N'', '',N'''')+
  isnull([Buildings].name, N'''')+
  isnull(N'' кв. ''+[LiveAddress].flat,N'''') house,

  isnull([StreetTypes2].shortname+N'' '',N'''')+
  isnull([Streets2].name+N'', '',N'''')+
  isnull([Buildings2].name, N'''') place_problem
  ,[Organizations].short_name vykon
  ,[Questions].question_content zmist
  ,[AssignmentConsiderations].short_answer comment
  , null [history]
  --,[Assignments].executor_organization_id
  ,[Applicants].Id ApplicantsId, [Buildings].Id BuildingId
  ,[Organizations].Id [Organizations_Id]
  ,isnull([AssignmentRevisions].[missed_call_counter], 0) cc_nedozvon
  ,case when [Assignments].assignment_state_id=3
  then [Assignments].state_change_date end [state_changed_date] -- good
  ,case when [Assignments].assignment_state_id=3 and [AssignmentConsiderations].assignment_result_id=4
  then [Assignments].state_change_date end [state_changed_date_done]
  --,[Questions].entrance
  ,[LiveAddress].entrance
  ,[Questions].flat
  ,[Objects].Id [object]
  ,[Organizations].Id organization
  ,[QuestionTypes].Id question_type
  '+@comment_qls+N',[Rating].Id [question_list_state] --@comment_qls
  '+@de_comment+N' , null [question_list_state]
  ,[Assignments].registration_date
  ,[AssignmentRevisions].[edit_date]
  ,[AssignmentRevisions].[control_comment]

  ,[Streets].Id building_street
  ,[Buildings].[Id] building_number
  ,[Appeals].receipt_source_id receipt_source

  --- добавление сортировки
  --,ltrim([QuestionTypes].name) QuestionType_sort
  ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ltrim([QuestionTypes].name),N''щ'', N''ща''), N''ь'', ''щб''),N''я'',N''яа''),N''є'',N''яб''),N''і'',N''яв''),N''ї'',N''яг''),N''ґ'',N''яд'') QuestionType_sort
  --,[Applicants].full_name full_name_sort
  ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Applicants].full_name,N''щ'', N''ща''), N''ь'', ''щб''),N''я'',N''яа''),N''є'',N''яб''),N''і'',N''яв''),N''ї'',N''яг''),N''ґ'',N''яд'') full_name_sort
  --,[Districts].Name District_sort
  ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Districts].Name,N''щ'', N''ща''), N''ь'', ''щб''),N''я'',N''яа''),N''є'',N''яб''),N''і'',N''яв''),N''ї'',N''яг''),N''ґ'',N''яд'') District_sort
  --,isnull([StreetTypes].shortname+N'' '',N'''')+
  --isnull([Streets].name+N'', '',N'''')+
  --isnull([Buildings].name, N'''')+
  --isnull(N'' кв. ''+[LiveAddress].flat,N'''') house_sort
  ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(isnull([StreetTypes].shortname+N'' '',N'''')+
  isnull([Streets].name+N'', '',N'''')+
  isnull([Buildings].name, N'''')+
  isnull(N'' кв. ''+[LiveAddress].flat,N''''),N''щ'', N''ща''), N''ь'', ''щб''),N''я'',N''яа''),N''є'',N''яб''),N''і'',N''яв''),N''ї'',N''яг''),N''ґ'',N''яд'') house_sort
  --,isnull([StreetTypes2].shortname+N'' '',N'''')+
  --isnull([Streets2].name+N'', '',N'''')+
  --isnull([Buildings2].name, N'''') place_problem_sort
  ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(isnull([StreetTypes2].shortname+N'' '',N'''')+
  isnull([Streets2].name+N'', '',N'''')+
  isnull([Buildings2].name, N''''),N''щ'', N''ща''), N''ь'', ''щб''),N''я'',N''яа''),N''є'',N''яб''),N''і'',N''яв''),N''ї'',N''яг''),N''ґ'',N''яд'') place_problem_sort
  --,[Organizations].short_name vykon_sort
  ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Organizations].short_name,N''щ'', N''ща''), N''ь'', ''щб''),N''я'',N''яа''),N''є'',N''яб''),N''і'',N''яв''),N''ї'',N''яг''),N''ґ'',N''яд'') vykon_sort
  --,[Questions].question_content zmist_sort
  ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Questions].question_content,N''щ'', N''ща''), N''ь'', ''щб''),N''я'',N''яа''),N''є'',N''яб''),N''і'',N''яв''),N''ї'',N''яг''),N''ґ'',N''яд'') zmist_sort
  --,[AssignmentConsiderations].short_answer comment_sort
  ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([AssignmentConsiderations].short_answer,N''щ'', N''ща''), N''ь'', ''щб''),N''я'',N''яа''),N''є'',N''яб''),N''і'',N''яв''),N''ї'',N''яг''),N''ґ'',N''яд'') comment_sort
  --,[AssignmentRevisions].[control_comment] control_comment_sort
  ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([AssignmentRevisions].[control_comment],N''щ'', N''ща''), N''ь'', ''щб''),N''я'',N''яа''),N''є'',N''яб''),N''і'',N''яв''),N''ї'',N''яг''),N''ґ'',N''яд'') control_comment_sort


  ,isnull([AssignmentRevisions].[missed_call_counter], 0) cc_nedozvon_sort
  ,[ApplicantPhones].phone_number phone_number_sort
  ,[Questions].registration_number registration_number_sort
  ,[LiveAddress].entrance entrance_sort

  from [Assignments]  with (nolock)
  left join [AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
  left join [AssignmentResults] with (nolock) on [Assignments].AssignmentResultsId=[AssignmentResults].Id
  left join [AssignmentConsiderations] with (nolock) on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
  inner join [Questions] with (nolock) on [Assignments].question_id=[Questions].Id
  left join [QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
  inner join [Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
  left join [Applicants] with (nolock) on [Appeals].applicant_id=[Applicants].Id
  left join (select [applicant_id], [phone_number]
  from [ApplicantPhones] with (nolock)
  where IsMain=1) ApplicantPhones on [ApplicantPhones].applicant_id=[Applicants].Id

  left join [LiveAddress] with (nolock) on [LiveAddress].applicant_id=[Applicants].Id
  left join [Buildings] with (nolock) on [LiveAddress].building_id=[Buildings].Id
  left join [Districts] with (nolock) on [Buildings].district_id=[Districts].Id
  left join [Streets] with (nolock) on [Buildings].street_id=[Streets].Id
  left join [StreetTypes] with (nolock) on [Streets].street_type_id=[StreetTypes].Id
  left join [Objects] with (nolock) on [Questions].object_id=[Objects].Id
  left join [Buildings] [Buildings2] with (nolock) on [Objects].[builbing_id]=[Buildings2].Id
  left join [Districts] [Districts2] with (nolock) on [Buildings2].district_id=[Districts2].Id
  left join [Streets] [Streets2] with (nolock) on [Buildings2].street_id=[Streets2].Id
  left join [StreetTypes] [StreetTypes2] with (nolock) on [Streets2].street_type_id=[StreetTypes2].Id
  left join [Organizations] with (nolock) on [Assignments].executor_organization_id=[Organizations].Id
  left join [ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
  '+@comment_qls+N'left join [QuestionTypeInRating] with (nolock) on [QuestionTypes].question_type_id=[QuestionTypeInRating].QuestionType_id
  '+@comment_qls+N'left join [Rating] with (nolock) on [QuestionTypeInRating].Rating_id=[Rating].Id
  left join [AssignmentRevisions] with (nolock) on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd 
  where [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''Done'' and
     [Assignments].[main_executor]=''true''
     and  not (([ReceiptSources].code=N''UGL'' or [ReceiptSources].code=N''Website_mob.addition'') and [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''Done'')
       --and ([ReceiptSources].code<>N''UGL'' and [AssignmentStates].code<>N''OnCheck'' and [AssignmentResults].code<>N''Done'')
--тут
-- 	   and 
-- 	   left([Questions].registration_number, CHARINDEX(N''/'', [Questions].registration_number, 1)-1) in 
--   (
--  select distinct left([Questions].registration_number, CHARINDEX(N''/'', [Questions].registration_number, 1)-1)
--  from [Questions]
--  where RIGHT([Questions].registration_number,1)*1>1 and CHARINDEX(N''/'', [Questions].registration_number, 1)>0)

	   --тут
  
  ) t

  where '+@filter1+N'
  order by '+@sort1--+@sort1 тут registration_number

  exec(@qcode)

  --select @filter1