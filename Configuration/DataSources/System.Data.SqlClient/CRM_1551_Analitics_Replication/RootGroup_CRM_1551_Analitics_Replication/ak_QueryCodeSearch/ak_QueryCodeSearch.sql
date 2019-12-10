
----------после 2019 11 28 , согласно задачи 545 с файла


/*
 declare @user_id nvarchar(300)=N'd0da1bfc-438a-45ec-bc75-f1c8d05f0d9a';
 --d0da1bfc-438a-45ec-bc75-f1c8d05f0d9a
 --aa4c1f84-df33-452c-88e7-5a58dfd0b2d3


 declare @zayavnyk_phone_number nvarchar(max)=N'062'; --0442859062 0631388062

  declare @param1 nvarchar(max)=N'1=1 and timeliness in (1)'; --appeals_district in (1, 2, 3, 4, 5)
 declare @pageOffsetRows int =0;
 declare @pageLimitRows int =10;

  declare @registration_date_from datetime;--='2019-07-05 04:44:34';
 declare @registration_date_to datetime;--='2019-07-05 16:45:43';

   declare @transfer_date_from datetime;--='2019-07-05 11:26:37';
 declare @transfer_date_to datetime;--='2019-07-05 11:26:37';

  declare @state_changed_date_from datetime;--='2019-07-05 11:26:37';
 declare @state_changed_date_to datetime;--='2019-07-05 11:26:37';

 declare @state_changed_date_done_from datetime;--='2019-07-05 11:26:37';
 declare @state_changed_date_done_to datetime;--='2019-07-05 11:26:37';

  declare @execution_term_from datetime;--='2019-07-21 21:00:00.000';
 declare @execution_term_to datetime;--='2019-07-21 21:00:00.000';

 declare @control_date_from datetime;--='2019-07-21 21:00:00.000';
declare @control_date_to datetime;--='2019-07-21 21:00:00.000';

 */

---------
--set @DateStart1=getdate();




--set @DateEnd1=GETDATE();


--set @t1=DATEDIFF(MS, @DateStart1, @DateEnd1)

------
--set @DateStart2=getdate();
declare @registration_date_fromP nvarchar(200)=
 case when @registration_date_from is not null 
 then N' and registration_date>= '''+format(convert(datetime2, @registration_date_from), 'yyyy-MM-dd HH:mm:00')+N'.000'''
 else N'' end;

 declare @registration_date_toP nvarchar(200)=
 case when @registration_date_to is not null 
 then N' and registration_date<= '''+format(convert(datetime2, @registration_date_to), 'yyyy-MM-dd HH:mm:59')+N'.999'''
 else N'' end;



  declare @transfer_date_fromP nvarchar(200)=
 case when @transfer_date_from is not null 
 then N' and transfer_date>= '''+format(convert(datetime2, @transfer_date_from), 'yyyy-MM-dd HH:mm:00')+N'.000'''
 else N'' end;

 declare @transfer_date_toP nvarchar(200)=
 case when @transfer_date_to is not null 
 then N' and transfer_date<= '''+format(convert(datetime2, @transfer_date_to), 'yyyy-MM-dd HH:mm:59')+N'.999'''
 else N'' end;


 declare @state_changed_date_fromP nvarchar(200)=
 case when @state_changed_date_from is not null 
 then N' and state_changed_date>= '''+format(convert(datetime2, @state_changed_date_from), 'yyyy-MM-dd HH:mm:00')+N'.000'''
 else N'' end;

 declare @state_changed_date_toP nvarchar(200)=
 case when @state_changed_date_to is not null 
 then N' and state_changed_date<= '''+format(convert(datetime2, @state_changed_date_to), 'yyyy-MM-dd HH:mm:59')+N'.999'''
 else N'' end;



  declare @state_changed_date_done_fromP nvarchar(200)=
 case when @state_changed_date_done_from is not null 
 then N' and state_changed_date_done>= '''+format(convert(datetime2, @state_changed_date_done_from), 'yyyy-MM-dd HH:mm:00')+N'.000'''
 else N'' end;

 declare @state_changed_date_done_toP nvarchar(200)=
 case when @state_changed_date_done_to is not null 
 then N' and state_changed_date_done<= '''+format(convert(datetime2, @state_changed_date_done_to), 'yyyy-MM-dd HH:mm:59')+N'.999'''
 else N'' end;


  declare @execution_term_fromP nvarchar(200)=
 case when @execution_term_from is not null 
 then N' and convert(date, execution_term)>= '''+format(convert(date, dateadd(hh, 5, @execution_term_from)), 'yyyy-MM-dd')+N''''
 else N'' end;

 declare @execution_term_toP nvarchar(200)=
 case when @execution_term_to is not null 
 then N' and convert(date, execution_term)<= '''+format(convert(date, dateadd(hh, 5, @execution_term_to)), 'yyyy-MM-dd')+N''''
 else N'' end;

 declare @control_date_fromP nvarchar(200)=
 case when @control_date_from is not null 
 then N' and control_date>= '''+format(convert(datetime2, @control_date_from), 'yyyy-MM-dd HH:mm:00')+N'.000'''
 else N'' end;

 declare @control_date_toP nvarchar(200)=
 case when @control_date_to is not null 
 then N' and control_date<= '''+format(convert(datetime2, @control_date_to), 'yyyy-MM-dd HH:mm:59')+N'.999'''
 else N'' end;

    ---перелік параметры начало
  declare @comment_qls nvarchar(5);
  declare @de_comment nvarchar(5);

  set @comment_qls =(
  select case when CHARINDEX(N'question_list_state in (', @param1, 0)>0
  then N'' else N'--' end);

  set @de_comment = case when @comment_qls=N'--' then N'' else N'--' end;

  ---перелік параметры конец
  --select @comment_qls, @de_comment

 --select @execution_term_fromP, @execution_term_toP 


 declare @param4 nvarchar(max)=@registration_date_fromP+@registration_date_toP+@transfer_date_fromP+@transfer_date_toP
 +@state_changed_date_fromP+@state_changed_date_toP
 +@state_changed_date_done_fromP+@state_changed_date_done_toP
 +@execution_term_fromP+@execution_term_toP
 +@control_date_fromP+@control_date_toP


  declare @organizations nvarchar(max);

declare @param3 nvarchar(max);
if CHARINDEX(N'question_question_type',@param1, 1)>0

begin

declare @q_types nvarchar(max)=
(right(left(SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), 1)),
len(left(SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), 1)))-
CHARINDEX(N'(', left(SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), 1)), 1)+1))


declare @input_str nvarchar(max)=REPLACE(REPLACE(@q_types, N')', N''),N'(',N'')+N','

declare @table table (n int identity(1,1), id int)
 
-- создаем переменную, хранящую разделитель
declare @delimeter nvarchar(1) = ','
 
-- определяем позицию первого разделителя
declare @pos int = charindex(@delimeter,@input_str)
 
-- создаем переменную для хранения
-- одного айдишника
declare @id nvarchar(10)
    
while (@pos != 0)
begin
    -- получаем айдишник
    set @id = SUBSTRING(@input_str, 1, @pos-1)
    -- записываем в таблицу
    insert into @table (id) values(cast(@id as int))
    -- сокращаем исходную строку на
    -- размер полученного айдишника
    -- и разделителя
    set @input_str = SUBSTRING(@input_str, @pos+1, LEN(@input_str))
    -- определяем позицию след. разделителя
    set @pos = CHARINDEX(@delimeter,@input_str)
end

			 declare @question_typ nvarchar(max)=(
			 select stuff((select N', '+[QuestionTypesAndParent].QuestionTypes
  from [QuestionTypesAndParent] with (nolock)
  inner join @table t on [QuestionTypesAndParent].[ParentId]=t.id
  for xml path('')), 1,2,N''))

			 set @param3 =replace(@param1 
			 ,left(SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), 1))
			 ,N'question_question_type in ('+@question_typ+N')')

			end

			else
			begin
			set @param3=@param1;
			end;

-------------- next

 declare @assigm_executor_organizations nvarchar(max);
 -----найти подтипы вопросов начало
 /* найти под типы вопросов*/
--declare @param1 nvarchar(500)=N'id=123 and Id=54545';
declare @param_ex nvarchar(max);
if CHARINDEX(N'assigm_executor_organization',@param1, 1)>0

begin

declare @executors nvarchar(max)=
(right(left(SUBSTRING(@param1,CHARINDEX(N'assigm_executor_organization',@param1, 1) ,len(@param1)-CHARINDEX(N'assigm_executor_organization',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'assigm_executor_organization',@param1, 1) ,len(@param1)-CHARINDEX(N'assigm_executor_organization',@param1, 1)+1), 1)),
len(left(SUBSTRING(@param1,CHARINDEX(N'assigm_executor_organization',@param1, 1) ,len(@param1)-CHARINDEX(N'assigm_executor_organization',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'assigm_executor_organization',@param1, 1) ,len(@param1)-CHARINDEX(N'assigm_executor_organization',@param1, 1)+1), 1)))-
CHARINDEX(N'(', left(SUBSTRING(@param1,CHARINDEX(N'assigm_executor_organization',@param1, 1) ,len(@param1)-CHARINDEX(N'assigm_executor_organization',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'assigm_executor_organization',@param1, 1) ,len(@param1)-CHARINDEX(N'assigm_executor_organization',@param1, 1)+1), 1)), 1)+1))



declare @input_str_ex nvarchar(max)=REPLACE(REPLACE(@executors, N')', N''),N'(',N'')+N','

declare @table_ex table (n int identity(1,1), id int)
 
-- создаем переменную, хранящую разделитель
declare @delimeter_ex nvarchar(1) = ','
 
-- определяем позицию первого разделителя
declare @pos_ex int = charindex(@delimeter_ex,@input_str_ex)
 
-- создаем переменную для хранения
-- одного айдишника
declare @id_ex nvarchar(10)
    
while (@pos_ex != 0)
begin
    -- получаем айдишник
    set @id_ex = SUBSTRING(@input_str_ex, 1, @pos_ex-1)
    -- записываем в таблицу
    insert into @table_ex (id) values(cast(@id_ex as int))
    -- сокращаем исходную строку на
    -- размер полученного айдишника
    -- и разделителя
    set @input_str_ex = SUBSTRING(@input_str_ex, @pos_ex+1, LEN(@input_str_ex))
    -- определяем позицию след. разделителя
    set @pos_ex = CHARINDEX(@delimeter_ex,@input_str_ex)
end

				 set @param_ex =replace(@param3 
				 ,left(SUBSTRING(@param3,CHARINDEX(N'assigm_executor_organization',@param3, 1) ,len(@param3)-CHARINDEX(N'assigm_executor_organization',@param3, 1)+1), CHARINDEX(N')', SUBSTRING(@param3,CHARINDEX(N'assigm_executor_organization',@param3, 1) ,len(@param3)-CHARINDEX(N'assigm_executor_organization',@param3, 1)+1), 1))
				 ,N'assigm_executor_organization in ('+(select stuff((
  select N', '+[OrganizationsAndParent].Organizations
  from [OrganizationsAndParent]
  inner join @table_ex t on [OrganizationsAndParent].ParentId=t.Id
  for xml path('')), 1, 2,N''))+N')')
				-- select N'question_question_type in ('+@question_typ+N')' --question_question_type in (2, 3, 7, 8)

				end

				else
				begin
				set @param_ex=@param3;
				end;

   
declare @OrgTable table (Id int identity(1,1), OrgId int);
declare @Organization table(Id int);
declare @IdT table (Id int);
declare @OrganizationId int;
declare @n int=1;


  -- @execution_term_from

  declare @param2 nvarchar(max)=
   --case when CHARINDEX('cast(execution_term as datetime) >=', @param3, 0)=0 and CHARINDEX('cast(execution_term as datetime) <=', @param3, 0)>0

      case when @execution_term_from is null and @execution_term_to is not null
  then @param_ex+N' and [assigm_assignment_state_name]<>N''Закрито''' --Зареєстровано Закрито
  else @param_ex end+@param4;


  -------замена
  declare @param_new nvarchar(max)=
  (
  select case when CHARINDEX('question_registration_number like ''%', @param2, 1)>0
  then REPLACE(@param2, 
  'question_registration_number like ''%'+ right(left(@param2, CHARINDEX('%''', @param2, CHARINDEX('question_registration_number like ''%', @param2, 1))-1), 
  CHARINDEX('%''', @param2, CHARINDEX('question_registration_number like ''%', @param2, 1))
  -CHARINDEX('question_registration_number like ''%', @param2, 1)
  -len('question_registration_number like ''%'))+N'%''',
  
  N'appeals_registration_number in (N'''+
  REPLACE(
  right(left(@param2, CHARINDEX('%''', @param2, CHARINDEX('question_registration_number like ''%', @param2, 1))-1), 
  CHARINDEX('%''', @param2, CHARINDEX('question_registration_number like ''%', @param2, 1))
  -CHARINDEX('question_registration_number like ''%', @param2, 1)
  -len('question_registration_number like ''%')
  ), N', ', N''', N''')
  +N''')')
  else @param2 end
  )


 -- select @param_new
 /*
 declare @param_new2 nvarchar(max)=
 case when @zayavnyk_phone_number is not null
 then @param_new+N' and zayavnyk_phone_number_reverse like '+N''''+REVERSE(@zayavnyk_phone_number)+N'%'''
 else @param_new
 end 
 */
 --select @param_new2;
-- select @param_new;
  -------


  /* здесь нужно поставить условие, что если у данного человека есть организация 1761 то 1=1
  иначе нужн запустить пересчет*/

  --заполение таблицы организацией и ее под
  declare @organization_id1761 int =1761;
  declare @Organization1761 table(Id int);
  declare @OrganizationId1761 int = @organization_id1761;
  declare @IdT1761 table (Id int);
 -- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
 insert into @IdT1761(Id)
 select Id from [Organizations] with (nolock)
 where (Id=@OrganizationId1761 or [parent_organization_id]=@OrganizationId1761) and Id not in (select Id from @IdT1761)
 --  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
 while (select count(id) from (select Id from [Organizations] with (nolock)
 where [parent_organization_id] in (select Id from @IdT1761) --or Id in (select Id from @IdT)
 and Id not in (select Id from @IdT1761)) q)!=0
 begin
 insert into @IdT1761
 select Id from [Organizations] with (nolock)
 where [parent_organization_id] in (select Id from @IdT1761) --or Id in (select Id from @IdT)
 and Id not in (select Id from @IdT1761)
 end 
 insert into @Organization1761 (Id)
 select Id from @IdT1761;
 -- вторая часть, там, где данная организация является дочерней и залить в основную таблицу

 declare @organization_id1761L int =1761;
declare @Organization1761L table(Id int, Id_n int);
declare @OrganizationId1761L int =  @organization_id1761L;
declare @IdT1761L table (Id int, Id_n int identity(1,1));
insert into @IdT1761L(Id) select @OrganizationId1761L
while (select [parent_organization_id] from [Organizations] with (nolock) where Id=(select top 1 Id from @IdT1761L order by Id_n desc)) is not null
begin 
-- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
insert into @IdT1761L(Id)
select [parent_organization_id] from [Organizations] with (nolock)
where Id=(select top 1 Id from @IdT1761L order by Id_n desc) --and Id not in (select Id from @IdT)

end

insert into @Organization1761 (Id)
select Id from @IdT1761L where id<>1761

 -- начало оптимизации
			 if exists
			 (select [OrganizationInResponsibilityRights].organization_id
			  from [OrganizationInResponsibilityRights] with (nolock)
			  inner join [Positions] with (nolock) on [OrganizationInResponsibilityRights].position_id=[Positions].Id
			  inner join @Organization1761 o1761 on [OrganizationInResponsibilityRights].organization_id=o1761.Id
			  where [Positions].programuser_id=@user_id )

			  begin
			  set @organizations=N'1=1'
			  end

			  else
			  begin

						set @organizations=N'Organizations2_Id in ('+
					  (select stuff((select N', '+
[OrganizationsAndParent].Organizations
from [OrganizationInResponsibilityRights] with (nolock)
inner join [Positions] with (nolock) on [OrganizationInResponsibilityRights].position_id=[Positions].Id
inner join [OrganizationsAndParent] with (nolock) on [OrganizationInResponsibilityRights].organization_id=[OrganizationsAndParent].ParentId
where [Positions].programuser_id=@user_id
for xml path ('')),1,2,N''))+N')'

					  end
  -- конец оптимизации 
  --select @param2, @organizations
  --SELECT RTRIM(CAST(DATEDIFF(MS, @start_time, GETDATE()) AS CHAR(10))) AS 'TimeTaken'
  
  --select @param_new, @organizations, @zayavnyk_phone_number

  --------параметры для фильтрации начало
  --по номеру телефону
  -- declare @zayavnyk_phone_number nvarchar(max);--=N'062'; --0442859062

declare @filter_zayavnyk_phone_number nvarchar(700)=case when @zayavnyk_phone_number is not null
then N'
inner join
(
select distinct t1.applicant_id, stuff((select N'', ''+phone_number
  from [ApplicantPhones] with (nolock)
  where [phone_number_reverse] like '''+REVERSE(@zayavnyk_phone_number)+N'%''
  and [ApplicantPhones].applicant_id=t1.applicant_id
  for xml path ('''')), 1,2,N'''') phone_number
  from
  (select applicant_id, phone_number
  from [ApplicantPhones] with (nolock)
  where [phone_number_reverse] like '''+REVERSE(@zayavnyk_phone_number)+N'%'' ) t1
  ) 
  '
  else N'left join (select distinct t2.applicant_id, stuff((
  select N'', ''+[phone_number]
  from [ApplicantPhones] t1 with (nolock)
  where t1.applicant_id=t2.applicant_id
  for xml path('''')), 1, 2, N'''') [phone_number]
  from [ApplicantPhones] t2 with (nolock)) '
  end;

 -- select @filter_zayavnyk_phone_number

  ---район
  declare @filter_appeals_district nvarchar(20)=
case when charindex(N'appeals_district in (', @param1,  1)>0
then N'inner join'
else N'left join'
end;
--джерело надходження
declare @appeals_receipt_source nvarchar(20)=
case when charindex(N'appeals_receipt_source in (', @param1,  1)>0
then N'inner join'
else N'left join'
end;

--відповідальний
declare @filter_assigm_accountable nvarchar(20)=
case when charindex(N'assigm_accountable in (', @param1,  1)>0
then N'inner join'
else N'left join'
end;
--резолюція
declare @filter_assigm_assignment_resolution nvarchar(20)=
case when charindex(N'assigm_assignment_resolution in (', @param1,  1)>0
then N'inner join'
else N'left join'
end;
--результат
declare @filter_assigm_assignment_result nvarchar(20)=
case when charindex(N'assigm_assignment_result in (', @param1,  1)>0
then N'inner join'
else N'left join'
end;
--стан
declare @filter_assigm_assignment_state nvarchar(20)=
case when charindex(N'assigm_assignment_state in (', @param1,  1)>0
then N'inner join'
else N'left join'
end;
--перевірив
declare @filter_assigm_user_checked nvarchar(20)=
case when charindex(N'assigm_user_checked in (', @param1,  1)>0
then N'inner join'
else N'left join'
end;
--розглянув
declare @filter_assigm_user_reviewed nvarchar(20)=
case when charindex(N'assigm_user_reviewed in (', @param1,  1)>0
then N'inner join'
else N'left join'
end;
--перелік
declare @filter_question_list_state nvarchar(20)=
case when charindex(N'question_list_state in (', @param1,  1)>0
then N'inner join'
else N'left join'
end;
--об'єкт
declare @filter_question_object nvarchar(20)=
case when charindex(N'question_object in (', @param1,  1)>0
then N'inner join'
else N'left join'
end;
--тип об'єкту
declare @filter_question_ObjectTypes nvarchar(20)=
case when charindex(N'question_ObjectTypes in (', @param1,  1)>0
then N'inner join'
else N'left join'
end;
--організація
declare @filter_question_organization nvarchar(20)=
case when charindex(N'question_organization in (', @param1,  1)>0
then N'inner join'
else N'left join'
end;
--тип питання
declare @filter_question_question_type nvarchar(20)=
case when charindex(N'question_question_type in (', @param1,  1)>0
then N'inner join'
else N'left join'
end;
--передано
declare @filter_transfer_date nvarchar(20)=
case when @transfer_date_from is not null or @transfer_date_to is not null
then N'inner join'
else N'left join'
end;
--пільга
declare @filter_zayavnyk_applicant_privilage nvarchar(20)=
case when charindex(N'zayavnyk_applicant_privilage in (', @param1,  1)>0
then N'inner join'
else N'left join'
end;
--тип заявника
declare @filter_zayavnyk_applicant_type nvarchar(20)=
case when charindex(N'zayavnyk_applicant_type in (', @param1,  1)>0
then N'inner join'
else N'left join'
end;
--парадне, квартира
declare @filter_zayavnyk_entrance_zayavnyk_flat_district nvarchar(20)=
case when charindex(N'zayavnyk_entrance like', @param1,  1)>0 or charindex(N'zayavnyk_flat like', @param1,  1)>0
or charindex(N'appeals_district in (', @param1,  1)>0
then N'inner join'
else N'left join'
end;
--соціальний стан
declare @filter_zayavnyk_social_state nvarchar(20)=
case when charindex(N'zayavnyk_social_state in (', @param1,  1)>0
then N'inner join'
else N'left join'
end;
--вчасність
declare @filter_timeliness nvarchar(20)=
case when charindex(N'timeliness in (', @param1,  1)>0
then N'inner join'
else N'left join'
end;
  --------параметры для фильтрации конец

--select @param_new

declare @query nvarchar(max)=N'
select distinct --top 5000
   [Id]
  ,[appeals_receipt_source_name] [appeals_receipt_source]
  ,[appeals_user_name] [appeals_user]
  ,[appeals_district_name] [appeals_district] 
  ,[appeals_files_check]
  ,[zayavnyk_full_name]
  ,[zayavnyk_phone_number]
  ,[zayavnyk_building_street_name] [zayavnyk_building_street]

  ,isnull([shortname],N'''')+N'' ''+[zayavnyk_building_street_name]+N'', ''+[zayavnyk_building_number_name] [zayavnyk_building_number]


  ,[zayavnyk_entrance]
  ,[zayavnyk_flat]
  ,[zayavnyk_applicant_privilage_name] [zayavnyk_applicant_privilage]
  ,[zayavnyk_social_state_name] [zayavnyk_social_state]
  ,[zayavnyk_sex_name] [zayavnyk_sex]
  ,[zayavnyk_applicant_type_name] [zayavnyk_applicant_type]
  ,[zayavnyk_age]
  ,[zayavnyk_email]
  ,[question_registration_number]
  ,[question_ObjectTypes_name] [question_ObjectTypes]
  ,[question_object_name] [question_object]
  ,[question_organization_name] [question_organization]
  ,[question_question_type_name] [question_question_type]
  ,[question_question_state_name] [question_question_state]
  ,[question_list_state_name] [question_list_state]
  ,[assigm_executor_organization_name] [assigm_executor_organization]
  ,[assigm_main_executor]
  ,[assigm_question_content]
  ,[assigm_accountable_name] [assigm_accountable] 
  ,[assigm_assignment_state_name] [assigm_assignment_state]  
  ,[assigm_assignment_result_name] [assigm_assignment_result] 
  ,[assigm_assignment_resolution_name] [assigm_assignment_resolution]
  ,[assigm_user_reviewed_name] [assigm_user_reviewed] 
  ,[assigm_user_checked_name] [assigm_user_checked]

  ,/*convert(datetime, [registration_date])*/ [registration_date]
  ,convert(datetime, [transfer_date]) [transfer_date]
  ,convert(datetime, [state_changed_date]) [state_changed_date]
  ,convert(datetime, [state_changed_date_done]) [state_changed_date_done]
  
  ,[execution_term] 
  ,[appeals_enter_number]
  ,[control_comment]

  ,[ConsDocumentContent]
  ,[control_date]

 from
 (
  select distinct [Assignments].Id,
  [Appeals].receipt_source_id [appeals_receipt_source]
  ,[ReceiptSources].name [appeals_receipt_source_name]
  ,[Appeals].user_id [appeals_user]
  ,[Workers].name [appeals_user_name]
  ,[Districts].Id [appeals_district] 
  ,[Districts].name [appeals_district_name] 
  --,case when files_check.assignment_сons_id is not null then ''true'' else ''false'' end appeals_files_check
  ,''fasle'' appeals_files_check -- изменить
  ,[Applicants].full_name zayavnyk_full_name
  --,phone_number zayavnyk_phone_number

   --,phone_number zayavnyk_phone_number_reverse

  ,[Streets].Id [zayavnyk_building_street]
  ,[Streets].name [zayavnyk_building_street_name]
  ,[Buildings].Id [zayavnyk_building_number]
  ,[Buildings].name [zayavnyk_building_number_name]
  ,[LiveAddress].entrance [zayavnyk_entrance]
  ,[LiveAddress].flat [zayavnyk_flat]
  ,[ApplicantPrivilege].Id [zayavnyk_applicant_privilage]
  ,[ApplicantPrivilege].Name [zayavnyk_applicant_privilage_name]
  ,[SocialStates].Id [zayavnyk_social_state]
  ,[SocialStates].name [zayavnyk_social_state_name]
  ,[Applicants].sex [zayavnyk_sex]
  ,case when [Applicants].sex=1 then N''жіноча'' when [Applicants].sex=2 then N''чоловіча'' end [zayavnyk_sex_name]
  ,[ApplicantTypes].Id [zayavnyk_applicant_type]
  ,[ApplicantTypes].name [zayavnyk_applicant_type_name]
  ,case 
when [Applicants].[birth_date] is null then year(getdate())-[Applicants].birth_year
  when month([Applicants].[birth_date])<=month(getdate())
  and day([Applicants].[birth_date])<=day(getdate())
  then DATEDIFF(yy, [Applicants].[birth_date], getdate())
  else DATEDIFF(yy, [Applicants].[birth_date], getdate())-1 end zayavnyk_age,
  [Applicants].mail zayavnyk_email
  
  ,[Questions].registration_number [question_registration_number]
  ,[ObjectTypes].Id [question_ObjectTypes]
  ,[ObjectTypes].name [question_ObjectTypes_name]
  ,[Objects].Id [question_object]
  ,[Objects].name [question_object_name]
  ,[Organizations].Id [question_organization]
  ,[Organizations].short_name [question_organization_name]
  ,[QuestionTypes].Id [question_question_type]
  ,[QuestionTypes].name [question_question_type_name]
  ,[QuestionStates].Id [question_question_state]
  ,[QuestionStates].name [question_question_state_name]
  '+@comment_qls+N',[Rating].Id [question_list_state] --@comment_qls
  '+@de_comment+N' , null [question_list_state]
  '+@comment_qls+N',[Rating].name [question_list_state_name] --@comment_qls
  '+@de_comment+N' , null [question_list_state_name]

  ,[Assignments].executor_organization_id [assigm_executor_organization] -- good
  ,IIF (len([Organizations2].[head_name]) > 5,  concat([Organizations2].[head_name] , '' ( '' , [Organizations2].[short_name] , '')''),  [Organizations2].[short_name]) [assigm_executor_organization_name]
  ,[Assignments].main_executor [assigm_main_executor] -- good
  ,[Questions].question_content [assigm_question_content] -- good
   ,[Organizations10].[short_name] [assigm_accountable_name] -- good
   ,[Organizations10].Id [assigm_accountable]

  ,[AssignmentStates].Id [assigm_assignment_state] -- good
  ,[AssignmentStates].name [assigm_assignment_state_name] -- good
         
  ,[AssignmentResults].Id [assigm_assignment_result] -- good
  ,[AssignmentResults].name [assigm_assignment_result_name] -- good
        
  ,[AssignmentResolutions].Id [assigm_assignment_resolution] -- good
  ,[AssignmentResolutions].name [assigm_assignment_resolution_name] -- good

  ,[Workers2].Id [assigm_user_reviewed]
  ,[Workers2].name [assigm_user_reviewed_name] -- good


  ,[Workers3].name [assigm_user_checked_name]
  ,[Workers3].Id [assigm_user_checked]

  ,[Assignments].registration_date  as  [registration_date] -- good
  ,[AssignmentConsiderations].transfer_date [transfer_date] -- good
  ,case when [Assignments].assignment_state_id=3
  then [Assignments].state_change_date end [state_changed_date] -- good
  ,case when [Assignments].assignment_state_id=3 and [AssignmentConsiderations].assignment_result_id=4
  then [Assignments].state_change_date end [state_changed_date_done] -- good
  ,[Assignments].[execution_date] [execution_term] --good
 
 , [StreetTypes].[shortname]
 , [Appeals].[enter_number] appeals_enter_number
 , [Organizations2].Id Organizations2_Id
 , [AssignmentConsiderations].short_answer [control_comment]

 --,files_check.[content] ConsDocumentContent
 -- , null ConsDocumentContent-- изменить
 ,[AssignmentConsDocuments].[content] ConsDocumentContent
 ,[AssignmentRevisions].control_date
 ,App_phone.phone_number zayavnyk_phone_number
 ,[Appeals].[registration_number] appeals_registration_number

 ,case when [AssignmentStates].Id in (1,2) and [AssignmentRevisions].control_date<getutcdate()
 then ''true'' end overdue
 
 ,case when timeliness_table.min_date<=[AssignmentRevisions].control_date then 1
	   when timeliness_table.min_date>[AssignmentRevisions].control_date then 2
  end timeliness

  from 
  [Assignments] with (nolock)
  inner join [Questions] with (nolock) on [Assignments].question_id=[Questions].Id
  inner join [Appeals] with (nolock) on [Questions].[appeal_id]=[Appeals].Id
  left join [Applicants] with (nolock) on [Applicants].Id=[Appeals].applicant_id
  '+@filter_zayavnyk_phone_number+N' App_phone on [Applicants].Id=App_phone.applicant_id
  '+@filter_transfer_date+N' [AssignmentConsiderations] with (nolock) on [AssignmentConsiderations].Id = Assignments.current_assignment_consideration_id
  '+@filter_assigm_assignment_state+N' [AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
  '+@filter_assigm_assignment_result+N' [AssignmentResults] with (nolock) on [AssignmentConsiderations].assignment_result_id=[AssignmentResults].Id
  '+@filter_assigm_assignment_resolution+N' [AssignmentResolutions] with (nolock) on [AssignmentConsiderations].assignment_resolution_id=[AssignmentResolutions].id
  left join [AssignmentRevisions] with (nolock) on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
  inner join [Organizations] [Organizations2] with (nolock) on [Assignments].executor_organization_id=[Organizations2].Id
  '+@filter_assigm_user_reviewed+N' [Workers] [Workers2] with (nolock) on [AssignmentConsiderations].user_id=[Workers2].worker_user_id
  '+@filter_assigm_user_checked+N' [Workers] [Workers3] with (nolock) on [AssignmentRevisions].[user_edit_id]=[Workers3].worker_user_id
  '+@appeals_receipt_source+N' [ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
  left join [Workers] with (nolock) on [Appeals].user_id=[Workers].worker_user_id
  '+@filter_zayavnyk_entrance_zayavnyk_flat_district+N' [LiveAddress] with (nolock) on [LiveAddress].applicant_id=[Applicants].Id
  '+@filter_appeals_district+N' [Buildings] with (nolock) on [LiveAddress].building_id=[Buildings].Id
  '+@filter_appeals_district+N'  [Districts]  on [Buildings].district_id=[Districts].Id 
  '+@filter_appeals_district+N' [Streets] with (nolock) on [Buildings].street_id=[Streets].Id
  '+@filter_appeals_district+N' [StreetTypes] with (nolock) on [Streets].[street_type_id]=[StreetTypes].Id
  '+@filter_zayavnyk_applicant_privilage+N' [ApplicantPrivilege] with (nolock) on [Applicants].applicant_privilage_id=[ApplicantPrivilege].Id
  '+@filter_zayavnyk_social_state+N' [SocialStates] with (nolock) on [Applicants].social_state_id=[SocialStates].Id
  '+@filter_zayavnyk_applicant_type+N' [ApplicantTypes] with (nolock) on [Applicants].applicant_type_id=[ApplicantTypes].Id
  '+@filter_question_object+N' [Objects] with (nolock) on [Questions].object_id=[Objects].Id
  '+@filter_question_ObjectTypes+N' [ObjectTypes] with (nolock) on [Objects].object_type_id=[ObjectTypes].Id
  '+@filter_question_organization+N' [Organizations] with (nolock) on [Questions].organization_id=[Organizations].Id
  '+@filter_question_question_type+N' [QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
  inner join [QuestionStates] with (nolock) on [Questions].question_state_id=[QuestionStates].Id
  '+@comment_qls+N'left join [QuestionTypeInRating] with (nolock) on [QuestionTypeInRating].QuestionType_id=[QuestionTypes].Id
  '+@comment_qls+N' '+@filter_question_list_state+N' [Rating] with (nolock) on [QuestionTypeInRating].Rating_id=[Rating].Id
  '+@filter_assigm_accountable+N' [Organizations] [Organizations10] with (nolock) on [Assignments].[executor_organization_id]=[Organizations10].id
  left join [AssignmentConsDocuments] with (nolock) on [AssignmentConsiderations].Id=[AssignmentConsDocuments].assignment_сons_id
  '+@filter_timeliness+' (select [assignment_id], min([Log_Date]) min_date 
  from [Assignment_History] where assignment_state_id=3 and Log_Activity=N''UPDATE'' 
  group by [assignment_id]) timeliness_table on [Assignments].Id=timeliness_table.[assignment_id]
  
  --left join (select distinct [AssignmentConsDocuments].assignment_сons_id, [content]
  --from [10.192.200.82].[CRM_1551_Analitics].[dbo].[AssignmentConsDocuments] with (nolock)
  --right join [10.192.200.82].[CRM_1551_Analitics].[dbo].[AssignmentConsDocFiles] with (nolock) on [AssignmentConsDocuments].Id=[AssignmentConsDocFiles].assignment_cons_doc_id
  --where [AssignmentConsDocuments].[doc_type_id] in (3,4) or [AssignmentConsDocuments].Id is not null) files_check on [AssignmentConsiderations].Id=files_check.assignment_сons_id

  --изменения по фильтрации
  --номер телефона
  



  ) a
  where '+@param_new+ N'  and '+@organizations+N' 
'
-------
 -- and #filter_columns#
 -- #sort_columns#
 --offset ' + (select ltrim(@pageOffsetRows))+N' rows fetch next '+ (select ltrim(@pageLimitRows))+N' rows only
 
 --select @query
 --comment
  exec(@query)

-- declare @registration_date_fromP nvarchar(200)=
-- case when @registration_date_from is not null 
-- then N' and registration_date>= '''+format(convert(datetime2, @registration_date_from), 'yyyy-MM-dd HH:mm:00')+N'.000'''
-- else N'' end;

-- declare @registration_date_toP nvarchar(200)=
-- case when @registration_date_to is not null 
-- then N' and registration_date<= '''+format(convert(datetime2, @registration_date_to), 'yyyy-MM-dd HH:mm:59')+N'.999'''
-- else N'' end;



--  declare @transfer_date_fromP nvarchar(200)=
-- case when @transfer_date_from is not null 
-- then N' and transfer_date>= '''+format(convert(datetime2, @transfer_date_from), 'yyyy-MM-dd HH:mm:00')+N'.000'''
-- else N'' end;

-- declare @transfer_date_toP nvarchar(200)=
-- case when @transfer_date_to is not null 
-- then N' and transfer_date<= '''+format(convert(datetime2, @transfer_date_to), 'yyyy-MM-dd HH:mm:59')+N'.999'''
-- else N'' end;


-- declare @state_changed_date_fromP nvarchar(200)=
-- case when @state_changed_date_from is not null 
-- then N' and state_changed_date>= '''+format(convert(datetime2, @state_changed_date_from), 'yyyy-MM-dd HH:mm:00')+N'.000'''
-- else N'' end;

-- declare @state_changed_date_toP nvarchar(200)=
-- case when @state_changed_date_to is not null 
-- then N' and state_changed_date<= '''+format(convert(datetime2, @state_changed_date_to), 'yyyy-MM-dd HH:mm:59')+N'.999'''
-- else N'' end;



--  declare @state_changed_date_done_fromP nvarchar(200)=
-- case when @state_changed_date_done_from is not null 
-- then N' and state_changed_date_done>= '''+format(convert(datetime2, @state_changed_date_done_from), 'yyyy-MM-dd HH:mm:00')+N'.000'''
-- else N'' end;

-- declare @state_changed_date_done_toP nvarchar(200)=
-- case when @state_changed_date_done_to is not null 
-- then N' and state_changed_date_done<= '''+format(convert(datetime2, @state_changed_date_done_to), 'yyyy-MM-dd HH:mm:59')+N'.999'''
-- else N'' end;


--  declare @execution_term_fromP nvarchar(200)=
-- case when @execution_term_from is not null 
-- then N' and convert(date, execution_term)>= '''+format(convert(date, dateadd(hh, 5, @execution_term_from)), 'yyyy-MM-dd')+N''''
-- else N'' end;

-- declare @execution_term_toP nvarchar(200)=
-- case when @execution_term_to is not null 
-- then N' and convert(date, execution_term)<= '''+format(convert(date, dateadd(hh, 5, @execution_term_to)), 'yyyy-MM-dd')+N''''
-- else N'' end;

-- declare @control_date_fromP nvarchar(200)=
-- case when @control_date_from is not null 
-- then N' and control_date>= '''+format(convert(datetime2, @control_date_from), 'yyyy-MM-dd HH:mm:00')+N'.000'''
-- else N'' end;

-- declare @control_date_toP nvarchar(200)=
-- case when @control_date_to is not null 
-- then N' and control_date<= '''+format(convert(datetime2, @control_date_to), 'yyyy-MM-dd HH:mm:59')+N'.999'''
-- else N'' end;

-- --- убрать

-- --select @execution_term_fromP, @execution_term_toP 


-- declare @param4 nvarchar(max)=@registration_date_fromP+@registration_date_toP+@transfer_date_fromP+@transfer_date_toP
-- +@state_changed_date_fromP+@state_changed_date_toP
-- +@state_changed_date_done_fromP+@state_changed_date_done_toP
-- +@execution_term_fromP+@execution_term_toP
-- +@control_date_fromP+@control_date_toP


--  declare @organizations nvarchar(max);

--declare @param3 nvarchar(max);
--if CHARINDEX(N'question_question_type',@param1, 1)>0

--begin

--declare @q_types nvarchar(max)=
--(right(left(SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), 1)),
--len(left(SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), 1)))-
--CHARINDEX(N'(', left(SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), 1)), 1)+1))


--declare @input_str nvarchar(max)=REPLACE(REPLACE(@q_types, N')', N''),N'(',N'')+N','

--declare @table table (n int identity(1,1), id int)
 
---- создаем переменную, хранящую разделитель
--declare @delimeter nvarchar(1) = ','
 
---- определяем позицию первого разделителя
--declare @pos int = charindex(@delimeter,@input_str)
 
---- создаем переменную для хранения
---- одного айдишника
--declare @id nvarchar(10)
    
--while (@pos != 0)
--begin
--    -- получаем айдишник
--    set @id = SUBSTRING(@input_str, 1, @pos-1)
--    -- записываем в таблицу
--    insert into @table (id) values(cast(@id as int))
--    -- сокращаем исходную строку на
--    -- размер полученного айдишника
--    -- и разделителя
--    set @input_str = SUBSTRING(@input_str, @pos+1, LEN(@input_str))
--    -- определяем позицию след. разделителя
--    set @pos = CHARINDEX(@delimeter,@input_str)
--end

--			 declare @question_typ nvarchar(max)=(
--			 select stuff((select N', '+[QuestionTypesAndParent].QuestionTypes
--  from [QuestionTypesAndParent] with (nolock)
--  inner join @table t on [QuestionTypesAndParent].[ParentId]=t.id
--  for xml path('')), 1,2,N''))

--			 set @param3 =replace(@param1 
--			 ,left(SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), 1))
--			 ,N'question_question_type in ('+@question_typ+N')')

--			end

--			else
--			begin
--			set @param3=@param1;
--			end;

---------------- next

-- declare @assigm_executor_organizations nvarchar(max);
-- -----найти подтипы вопросов начало
-- /* найти под типы вопросов*/
----declare @param1 nvarchar(500)=N'id=123 and Id=54545';
--declare @param_ex nvarchar(max);
--if CHARINDEX(N'assigm_executor_organization',@param1, 1)>0

--begin

--declare @executors nvarchar(max)=
--(right(left(SUBSTRING(@param1,CHARINDEX(N'assigm_executor_organization',@param1, 1) ,len(@param1)-CHARINDEX(N'assigm_executor_organization',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'assigm_executor_organization',@param1, 1) ,len(@param1)-CHARINDEX(N'assigm_executor_organization',@param1, 1)+1), 1)),
--len(left(SUBSTRING(@param1,CHARINDEX(N'assigm_executor_organization',@param1, 1) ,len(@param1)-CHARINDEX(N'assigm_executor_organization',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'assigm_executor_organization',@param1, 1) ,len(@param1)-CHARINDEX(N'assigm_executor_organization',@param1, 1)+1), 1)))-
--CHARINDEX(N'(', left(SUBSTRING(@param1,CHARINDEX(N'assigm_executor_organization',@param1, 1) ,len(@param1)-CHARINDEX(N'assigm_executor_organization',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'assigm_executor_organization',@param1, 1) ,len(@param1)-CHARINDEX(N'assigm_executor_organization',@param1, 1)+1), 1)), 1)+1))



--declare @input_str_ex nvarchar(max)=REPLACE(REPLACE(@executors, N')', N''),N'(',N'')+N','

--declare @table_ex table (n int identity(1,1), id int)
 
---- создаем переменную, хранящую разделитель
--declare @delimeter_ex nvarchar(1) = ','
 
---- определяем позицию первого разделителя
--declare @pos_ex int = charindex(@delimeter_ex,@input_str_ex)
 
---- создаем переменную для хранения
---- одного айдишника
--declare @id_ex nvarchar(10)
    
--while (@pos_ex != 0)
--begin
--    -- получаем айдишник
--    set @id_ex = SUBSTRING(@input_str_ex, 1, @pos_ex-1)
--    -- записываем в таблицу
--    insert into @table_ex (id) values(cast(@id_ex as int))
--    -- сокращаем исходную строку на
--    -- размер полученного айдишника
--    -- и разделителя
--    set @input_str_ex = SUBSTRING(@input_str_ex, @pos_ex+1, LEN(@input_str_ex))
--    -- определяем позицию след. разделителя
--    set @pos_ex = CHARINDEX(@delimeter_ex,@input_str_ex)
--end

--				 set @param_ex =replace(@param3 
--				 ,left(SUBSTRING(@param3,CHARINDEX(N'assigm_executor_organization',@param3, 1) ,len(@param3)-CHARINDEX(N'assigm_executor_organization',@param3, 1)+1), CHARINDEX(N')', SUBSTRING(@param3,CHARINDEX(N'assigm_executor_organization',@param3, 1) ,len(@param3)-CHARINDEX(N'assigm_executor_organization',@param3, 1)+1), 1))
--				 ,N'assigm_executor_organization in ('+(select stuff((
--  select N', '+[OrganizationsAndParent].Organizations
--  from [OrganizationsAndParent]
--  inner join @table_ex t on [OrganizationsAndParent].ParentId=t.Id
--  for xml path('')), 1, 2,N''))+N')')
--				-- select N'question_question_type in ('+@question_typ+N')' --question_question_type in (2, 3, 7, 8)

--				end

--				else
--				begin
--				set @param_ex=@param3;
--				end;

   
--declare @OrgTable table (Id int identity(1,1), OrgId int);
--declare @Organization table(Id int);
--declare @IdT table (Id int);
--declare @OrganizationId int;
--declare @n int=1;


--  -- @execution_term_from

--  declare @param2 nvarchar(max)=
--   --case when CHARINDEX('cast(execution_term as datetime) >=', @param3, 0)=0 and CHARINDEX('cast(execution_term as datetime) <=', @param3, 0)>0

--      case when @execution_term_from is null and @execution_term_to is not null
--  then @param_ex+N' and [assigm_assignment_state_name]<>N''Закрито''' --Зареєстровано Закрито
--  else @param_ex end+@param4;


--  -------замена
--  declare @param_new nvarchar(max)=
--  (
--  select case when CHARINDEX('question_registration_number like ''%', @param2, 1)>0
--  then REPLACE(@param2, 
--  'question_registration_number like ''%'+ right(left(@param2, CHARINDEX('%''', @param2, CHARINDEX('question_registration_number like ''%', @param2, 1))-1), 
--  CHARINDEX('%''', @param2, CHARINDEX('question_registration_number like ''%', @param2, 1))
--  -CHARINDEX('question_registration_number like ''%', @param2, 1)
--  -len('question_registration_number like ''%'))+N'%''',
  
--  N'appeals_registration_number in (N'''+
--  REPLACE(
--  right(left(@param2, CHARINDEX('%''', @param2, CHARINDEX('question_registration_number like ''%', @param2, 1))-1), 
--  CHARINDEX('%''', @param2, CHARINDEX('question_registration_number like ''%', @param2, 1))
--  -CHARINDEX('question_registration_number like ''%', @param2, 1)
--  -len('question_registration_number like ''%')
--  ), N', ', N''', N''')
--  +N''')')
--  else @param2 end
--  )


-- -- select @param_new
-- /*
-- declare @param_new2 nvarchar(max)=
-- case when @zayavnyk_phone_number is not null
-- then @param_new+N' and zayavnyk_phone_number_reverse like '+N''''+REVERSE(@zayavnyk_phone_number)+N'%'''
-- else @param_new
-- end 
-- */
-- --select @param_new2;
---- select @param_new;
--  -------


--  /* здесь нужно поставить условие, что если у данного человека есть организация 1761 то 1=1
--  иначе нужн запустить пересчет*/

--  --заполение таблицы организацией и ее под
--  declare @organization_id1761 int =1761;
--  declare @Organization1761 table(Id int);
--  declare @OrganizationId1761 int = @organization_id1761;
--  declare @IdT1761 table (Id int);
-- -- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
-- insert into @IdT1761(Id)
-- select Id from [Organizations] with (nolock)
-- where (Id=@OrganizationId1761 or [parent_organization_id]=@OrganizationId1761) and Id not in (select Id from @IdT1761)
-- --  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
-- while (select count(id) from (select Id from [Organizations] with (nolock)
-- where [parent_organization_id] in (select Id from @IdT1761) --or Id in (select Id from @IdT)
-- and Id not in (select Id from @IdT1761)) q)!=0
-- begin
-- insert into @IdT1761
-- select Id from [Organizations] with (nolock)
-- where [parent_organization_id] in (select Id from @IdT1761) --or Id in (select Id from @IdT)
-- and Id not in (select Id from @IdT1761)
-- end 
-- insert into @Organization1761 (Id)
-- select Id from @IdT1761;
-- -- вторая часть, там, где данная организация является дочерней и залить в основную таблицу

-- declare @organization_id1761L int =1761;
--declare @Organization1761L table(Id int, Id_n int);
--declare @OrganizationId1761L int =  @organization_id1761L;
--declare @IdT1761L table (Id int, Id_n int identity(1,1));
--insert into @IdT1761L(Id) select @OrganizationId1761L
--while (select [parent_organization_id] from [Organizations] with (nolock) where Id=(select top 1 Id from @IdT1761L order by Id_n desc)) is not null
--begin 
---- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
--insert into @IdT1761L(Id)
--select [parent_organization_id] from [Organizations] with (nolock)
--where Id=(select top 1 Id from @IdT1761L order by Id_n desc) --and Id not in (select Id from @IdT)

--end

--insert into @Organization1761 (Id)
--select Id from @IdT1761L where id<>1761

-- -- начало оптимизации
--			 if exists
--			 (select [OrganizationInResponsibilityRights].organization_id
--			  from [OrganizationInResponsibilityRights] with (nolock)
--			  inner join [Positions] with (nolock) on [OrganizationInResponsibilityRights].position_id=[Positions].Id
--			  inner join @Organization1761 o1761 on [OrganizationInResponsibilityRights].organization_id=o1761.Id
--			  where [Positions].programuser_id=@user_id )

--			  begin
--			  set @organizations=N'1=1'
--			  end

--			  else
--			  begin

--						set @organizations=N'Organizations2_Id in ('+
--					  (select stuff((select N', '+
--[OrganizationsAndParent].Organizations
--from [OrganizationInResponsibilityRights] with (nolock)
--inner join [Positions] with (nolock) on [OrganizationInResponsibilityRights].position_id=[Positions].Id
--inner join [OrganizationsAndParent] with (nolock) on [OrganizationInResponsibilityRights].organization_id=[OrganizationsAndParent].ParentId
--where [Positions].programuser_id=@user_id
--for xml path ('')),1,2,N''))+N')'

--					  end
--  -- конец оптимизации 
--  --select @param2, @organizations
--  --SELECT RTRIM(CAST(DATEDIFF(MS, @start_time, GETDATE()) AS CHAR(10))) AS 'TimeTaken'
  
--  --select @param_new, @organizations, @zayavnyk_phone_number

--  --------параметры для фильтрации начало
--  --по номеру телефону
--  -- declare @zayavnyk_phone_number nvarchar(max);--=N'062'; --0442859062

--declare @filter_zayavnyk_phone_number nvarchar(700)=case when @zayavnyk_phone_number is not null
--then N'
--inner join
--(
--select distinct t1.applicant_id, stuff((select N'', ''+phone_number
--  from [ApplicantPhones] with (nolock)
--  where [phone_number_reverse] like '''+REVERSE(@zayavnyk_phone_number)+N'%''
--  and [ApplicantPhones].applicant_id=t1.applicant_id
--  for xml path ('''')), 1,2,N'''') phone_number
--  from
--  (select applicant_id, phone_number
--  from [ApplicantPhones] with (nolock)
--  where [phone_number_reverse] like '''+REVERSE(@zayavnyk_phone_number)+N'%'' ) t1
--  ) 
--  '
--  else N'left join (select distinct t2.applicant_id, stuff((
--  select N'', ''+[phone_number]
--  from [ApplicantPhones] t1 with (nolock)
--  where t1.applicant_id=t2.applicant_id
--  for xml path('''')), 1, 2, N'''') [phone_number]
--  from [ApplicantPhones] t2 with (nolock)) '
--  end;

-- -- select @filter_zayavnyk_phone_number

--  ---район
--  declare @filter_appeals_district nvarchar(20)=
--case when charindex(N'appeals_district in (', @param1,  1)>0
--then N'inner join'
--else N'left join'
--end;
----джерело надходження
--declare @appeals_receipt_source nvarchar(20)=
--case when charindex(N'appeals_receipt_source in (', @param1,  1)>0
--then N'inner join'
--else N'left join'
--end;

----відповідальний
--declare @filter_assigm_accountable nvarchar(20)=
--case when charindex(N'assigm_accountable in (', @param1,  1)>0
--then N'inner join'
--else N'left join'
--end;
----резолюція
--declare @filter_assigm_assignment_resolution nvarchar(20)=
--case when charindex(N'assigm_assignment_resolution in (', @param1,  1)>0
--then N'inner join'
--else N'left join'
--end;
----результат
--declare @filter_assigm_assignment_result nvarchar(20)=
--case when charindex(N'assigm_assignment_result in (', @param1,  1)>0
--then N'inner join'
--else N'left join'
--end;
----стан
--declare @filter_assigm_assignment_state nvarchar(20)=
--case when charindex(N'assigm_assignment_state in (', @param1,  1)>0
--then N'inner join'
--else N'left join'
--end;
----перевірив
--declare @filter_assigm_user_checked nvarchar(20)=
--case when charindex(N'assigm_user_checked in (', @param1,  1)>0
--then N'inner join'
--else N'left join'
--end;
----розглянув
--declare @filter_assigm_user_reviewed nvarchar(20)=
--case when charindex(N'assigm_user_reviewed in (', @param1,  1)>0
--then N'inner join'
--else N'left join'
--end;
----перелік
--declare @filter_question_list_state nvarchar(20)=
--case when charindex(N'question_list_state in (', @param1,  1)>0
--then N'inner join'
--else N'left join'
--end;
----об'єкт
--declare @filter_question_object nvarchar(20)=
--case when charindex(N'question_object in (', @param1,  1)>0
--then N'inner join'
--else N'left join'
--end;
----тип об'єкту
--declare @filter_question_ObjectTypes nvarchar(20)=
--case when charindex(N'question_ObjectTypes in (', @param1,  1)>0
--then N'inner join'
--else N'left join'
--end;
----організація
--declare @filter_question_organization nvarchar(20)=
--case when charindex(N'question_organization in (', @param1,  1)>0
--then N'inner join'
--else N'left join'
--end;
----тип питання
--declare @filter_question_question_type nvarchar(20)=
--case when charindex(N'question_question_type in (', @param1,  1)>0
--then N'inner join'
--else N'left join'
--end;
----передано
--declare @filter_transfer_date nvarchar(20)=
--case when @transfer_date_from is not null or @transfer_date_to is not null
--then N'inner join'
--else N'left join'
--end;
----пільга
--declare @filter_zayavnyk_applicant_privilage nvarchar(20)=
--case when charindex(N'zayavnyk_applicant_privilage in (', @param1,  1)>0
--then N'inner join'
--else N'left join'
--end;
----тип заявника
--declare @filter_zayavnyk_applicant_type nvarchar(20)=
--case when charindex(N'zayavnyk_applicant_type in (', @param1,  1)>0
--then N'inner join'
--else N'left join'
--end;
----парадне, квартира
--declare @filter_zayavnyk_entrance_zayavnyk_flat_district nvarchar(20)=
--case when charindex(N'zayavnyk_entrance like', @param1,  1)>0 or charindex(N'zayavnyk_flat like', @param1,  1)>0
--or charindex(N'appeals_district in (', @param1,  1)>0
--then N'inner join'
--else N'left join'
--end;
----соціальний стан
--declare @filter_zayavnyk_social_state nvarchar(20)=
--case when charindex(N'zayavnyk_social_state in (', @param1,  1)>0
--then N'inner join'
--else N'left join'
--end;
--  --------параметры для фильтрации конец

----select @param_new

--declare @query nvarchar(max)=N'
--select distinct --top 5000
--   [Id]
--  ,[appeals_receipt_source_name] [appeals_receipt_source]
--  ,[appeals_user_name] [appeals_user]
--  ,[appeals_district_name] [appeals_district] 
--  ,[appeals_files_check]
--  ,[zayavnyk_full_name]
--  ,[zayavnyk_phone_number]
--  ,[zayavnyk_building_street_name] [zayavnyk_building_street]

--  ,isnull([shortname],N'''')+N'' ''+[zayavnyk_building_street_name]+N'', ''+[zayavnyk_building_number_name] [zayavnyk_building_number]


--  ,[zayavnyk_entrance]
--  ,[zayavnyk_flat]
--  ,[zayavnyk_applicant_privilage_name] [zayavnyk_applicant_privilage]
--  ,[zayavnyk_social_state_name] [zayavnyk_social_state]
--  ,[zayavnyk_sex_name] [zayavnyk_sex]
--  ,[zayavnyk_applicant_type_name] [zayavnyk_applicant_type]
--  ,[zayavnyk_age]
--  ,[zayavnyk_email]
--  ,[question_registration_number]
--  ,[question_ObjectTypes_name] [question_ObjectTypes]
--  ,[question_object_name] [question_object]
--  ,[question_organization_name] [question_organization]
--  ,[question_question_type_name] [question_question_type]
--  ,[question_question_state_name] [question_question_state]
--  ,[question_list_state_name] [question_list_state]
--  ,[assigm_executor_organization_name] [assigm_executor_organization]
--  ,[assigm_main_executor]
--  ,[assigm_question_content]
--  ,[assigm_accountable_name] [assigm_accountable] 
--  ,[assigm_assignment_state_name] [assigm_assignment_state]  
--  ,[assigm_assignment_result_name] [assigm_assignment_result] 
--  ,[assigm_assignment_resolution_name] [assigm_assignment_resolution]
--  ,[assigm_user_reviewed_name] [assigm_user_reviewed] 
--  ,[assigm_user_checked_name] [assigm_user_checked]

--  ,convert(datetime, [registration_date]) [registration_date]
--  ,convert(datetime, [transfer_date]) [transfer_date]
--  ,convert(datetime, [state_changed_date]) [state_changed_date]
--  ,convert(datetime, [state_changed_date_done]) [state_changed_date_done]
  
--  ,[execution_term] 
--  ,[appeals_enter_number]
--  ,[control_comment]

--  ,[ConsDocumentContent]
--  ,[control_date]

-- from
-- (
--  select distinct [Assignments].Id,
--  [Appeals].receipt_source_id [appeals_receipt_source]
--  ,[ReceiptSources].name [appeals_receipt_source_name]
--  ,[Appeals].user_id [appeals_user]
--  ,[Workers].name [appeals_user_name]
--  ,[Districts].Id [appeals_district] 
--  ,[Districts].name [appeals_district_name] 
--  --,case when files_check.assignment_сons_id is not null then ''true'' else ''false'' end appeals_files_check
--  ,''fasle'' appeals_files_check -- изменить
--  ,[Applicants].full_name zayavnyk_full_name
--  --,phone_number zayavnyk_phone_number

--   --,phone_number zayavnyk_phone_number_reverse

--  ,[Streets].Id [zayavnyk_building_street]
--  ,[Streets].name [zayavnyk_building_street_name]
--  ,[Buildings].Id [zayavnyk_building_number]
--  ,[Buildings].name [zayavnyk_building_number_name]
--  ,[LiveAddress].entrance [zayavnyk_entrance]
--  ,[LiveAddress].flat [zayavnyk_flat]
--  ,[ApplicantPrivilege].Id [zayavnyk_applicant_privilage]
--  ,[ApplicantPrivilege].Name [zayavnyk_applicant_privilage_name]
--  ,[SocialStates].Id [zayavnyk_social_state]
--  ,[SocialStates].name [zayavnyk_social_state_name]
--  ,[Applicants].sex [zayavnyk_sex]
--  ,case when [Applicants].sex=1 then N''жіноча'' when [Applicants].sex=2 then N''чоловіча'' end [zayavnyk_sex_name]
--  ,[ApplicantTypes].Id [zayavnyk_applicant_type]
--  ,[ApplicantTypes].name [zayavnyk_applicant_type_name]
--  ,case 
--when [Applicants].[birth_date] is null then year(getdate())-[Applicants].birth_year
--  when month([Applicants].[birth_date])<=month(getdate())
--  and day([Applicants].[birth_date])<=day(getdate())
--  then DATEDIFF(yy, [Applicants].[birth_date], getdate())
--  else DATEDIFF(yy, [Applicants].[birth_date], getdate())-1 end zayavnyk_age,
--  [Applicants].mail zayavnyk_email
  
--  ,[Questions].registration_number [question_registration_number]
--  ,[ObjectTypes].Id [question_ObjectTypes]
--  ,[ObjectTypes].name [question_ObjectTypes_name]
--  ,[Objects].Id [question_object]
--  ,[Objects].name [question_object_name]
--  ,[Organizations].Id [question_organization]
--  ,[Organizations].short_name [question_organization_name]
--  ,[QuestionTypes].Id [question_question_type]
--  ,[QuestionTypes].name [question_question_type_name]
--  ,[QuestionStates].Id [question_question_state]
--  ,[QuestionStates].name [question_question_state_name]
--  ,[Rating].Id [question_list_state]
--  ,[Rating].name [question_list_state_name]

--  ,[Assignments].executor_organization_id [assigm_executor_organization] -- good
--  ,IIF (len([Organizations2].[head_name]) > 5,  concat([Organizations2].[head_name] , '' ( '' , [Organizations2].[short_name] , '')''),  [Organizations2].[short_name]) [assigm_executor_organization_name]
--  ,[Assignments].main_executor [assigm_main_executor] -- good
--  ,[Questions].question_content [assigm_question_content] -- good
--   ,[Organizations10].[short_name] [assigm_accountable_name] -- good
--   ,[Organizations10].Id [assigm_accountable]

--  ,[AssignmentStates].Id [assigm_assignment_state] -- good
--  ,[AssignmentStates].name [assigm_assignment_state_name] -- good
         
--  ,[AssignmentResults].Id [assigm_assignment_result] -- good
--  ,[AssignmentResults].name [assigm_assignment_result_name] -- good
        
--  ,[AssignmentResolutions].Id [assigm_assignment_resolution] -- good
--  ,[AssignmentResolutions].name [assigm_assignment_resolution_name] -- good

--  ,[Workers2].Id [assigm_user_reviewed]
--  ,[Workers2].name [assigm_user_reviewed_name] -- good


--  ,[Workers3].name [assigm_user_checked_name]
--  ,[Workers3].Id [assigm_user_checked]

--  ,[Assignments].registration_date  as  [registration_date] -- good
--  ,[AssignmentConsiderations].transfer_date [transfer_date] -- good
--  ,case when [Assignments].assignment_state_id=3
--  then [Assignments].state_change_date end [state_changed_date] -- good
--  ,case when [Assignments].assignment_state_id=3 and [AssignmentConsiderations].assignment_result_id=4
--  then [Assignments].state_change_date end [state_changed_date_done] -- good
--  ,[Assignments].[execution_date] [execution_term] --good
 
-- , [StreetTypes].[shortname]
-- , [Appeals].[enter_number] appeals_enter_number
-- , [Organizations2].Id Organizations2_Id
-- , [AssignmentConsiderations].short_answer [control_comment]

-- --,files_check.[content] ConsDocumentContent
-- , null ConsDocumentContent-- изменить
-- ,[AssignmentRevisions].control_date
-- ,App_phone.phone_number zayavnyk_phone_number
-- ,[Appeals].[registration_number] appeals_registration_number
--  from 
--  [Assignments] with (nolock)
--  inner join [Questions] with (nolock) on [Assignments].question_id=[Questions].Id
--  inner join [Appeals] with (nolock) on [Questions].[appeal_id]=[Appeals].Id
--  inner join [Applicants] with (nolock) on [Applicants].Id=[Appeals].applicant_id
--  '+@filter_zayavnyk_phone_number+N' App_phone on [Applicants].Id=App_phone.applicant_id
--  '+@filter_transfer_date+N' [AssignmentConsiderations] with (nolock) on [AssignmentConsiderations].Id = Assignments.current_assignment_consideration_id
--  '+@filter_assigm_assignment_state+N' [AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
--  '+@filter_assigm_assignment_result+N' [AssignmentResults] with (nolock) on [AssignmentConsiderations].assignment_result_id=[AssignmentResults].Id
--  '+@filter_assigm_assignment_resolution+N' [AssignmentResolutions] with (nolock) on [AssignmentConsiderations].assignment_resolution_id=[AssignmentResolutions].id
--  left join [AssignmentRevisions] with (nolock) on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
--  inner join [Organizations] [Organizations2] with (nolock) on [Assignments].executor_organization_id=[Organizations2].Id
--  '+@filter_assigm_user_reviewed+N' [Workers] [Workers2] with (nolock) on [AssignmentConsiderations].user_id=[Workers2].worker_user_id
--  '+@filter_assigm_user_checked+N' [Workers] [Workers3] with (nolock) on [AssignmentRevisions].[user_edit_id]=[Workers3].worker_user_id
--  '+@appeals_receipt_source+N' [ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
--  left join [Workers] with (nolock) on [Appeals].user_id=[Workers].worker_user_id
--  '+@filter_zayavnyk_entrance_zayavnyk_flat_district+N' [LiveAddress] with (nolock) on [LiveAddress].applicant_id=[Applicants].Id
--  '+@filter_appeals_district+' [Buildings] with (nolock) on [LiveAddress].building_id=[Buildings].Id
--  '+@filter_appeals_district+N'  [Districts]  on [Buildings].district_id=[Districts].Id 
--  inner join [Streets] with (nolock) on [Buildings].street_id=[Streets].Id
--  left join [StreetTypes] with (nolock) on [Streets].[street_type_id]=[StreetTypes].Id
--  '+@filter_zayavnyk_applicant_privilage+N' [ApplicantPrivilege] with (nolock) on [Applicants].applicant_privilage_id=[ApplicantPrivilege].Id
--  '+@filter_zayavnyk_social_state+' [SocialStates] with (nolock) on [Applicants].social_state_id=[SocialStates].Id
--  '+@filter_zayavnyk_applicant_type+' [ApplicantTypes] with (nolock) on [Applicants].applicant_type_id=[ApplicantTypes].Id
--  '+@filter_question_object+N' [Objects] with (nolock) on [Questions].object_id=[Objects].Id
--  '+@filter_question_ObjectTypes+N' [ObjectTypes] with (nolock) on [Objects].object_type_id=[ObjectTypes].Id
--  '+@filter_question_organization+N' [Organizations] with (nolock) on [Questions].organization_id=[Organizations].Id
--  '+@filter_question_question_type+N' [QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
--  inner join [QuestionStates] with (nolock) on [Questions].question_state_id=[QuestionStates].Id
--  left join [QuestionTypeInRating] with (nolock) on [QuestionTypeInRating].QuestionType_id=[QuestionTypes].Id
--  '+@filter_question_list_state+N' [Rating] with (nolock) on [QuestionTypeInRating].Rating_id=[Rating].Id
--  '+@filter_assigm_accountable+N' [Organizations] [Organizations10] with (nolock) on [Assignments].[executor_organization_id]=[Organizations10].id
--  /*left join (select distinct [AssignmentConsDocuments].assignment_сons_id, [content]
--  from [AssignmentConsDocuments] with (nolock)
--  right join [AssignmentConsDocFiles] with (nolock) on [AssignmentConsDocuments].Id=[AssignmentConsDocFiles].assignment_cons_doc_id
--  where [AssignmentConsDocuments].[doc_type_id] in (3,4) or [AssignmentConsDocuments].Id is not null) files_check on [AssignmentConsiderations].Id=files_check.assignment_сons_id*/

--  --изменения по фильтрации
--  --номер телефона
  



--  ) a
--  where '+@param_new+ N'  and '+@organizations+N' 
--'
---------
-- -- and #filter_columns#
-- -- #sort_columns#
-- --offset ' + (select ltrim(@pageOffsetRows))+N' rows fetch next '+ (select ltrim(@pageLimitRows))+N' rows only
 
-- --select @query
-- --comment
--  exec(@query)


-----------до 2019 11 28 Артем
--set @DateStart1=getdate();




--set @DateEnd1=GETDATE();


--set @t1=DATEDIFF(MS, @DateStart1, @DateEnd1)

------
--set @DateStart2=getdate();



--  declare @registration_date_fromP nvarchar(200)=
--  case when @registration_date_from is not null 
--  then N' and registration_date>= '''+format(convert(datetime2, @registration_date_from), 'yyyy-MM-dd HH:mm:00')+N'.000'''
--  else N'' end;

--  declare @registration_date_toP nvarchar(200)=
--  case when @registration_date_to is not null 
--  then N' and registration_date<= '''+format(convert(datetime2, @registration_date_to), 'yyyy-MM-dd HH:mm:59')+N'.999'''
--  else N'' end;



--   declare @transfer_date_fromP nvarchar(200)=
--  case when @transfer_date_from is not null 
--  then N' and transfer_date>= '''+format(convert(datetime2, @transfer_date_from), 'yyyy-MM-dd HH:mm:00')+N'.000'''
--  else N'' end;

--  declare @transfer_date_toP nvarchar(200)=
--  case when @transfer_date_to is not null 
--  then N' and transfer_date<= '''+format(convert(datetime2, @transfer_date_to), 'yyyy-MM-dd HH:mm:59')+N'.999'''
--  else N'' end;


--  declare @state_changed_date_fromP nvarchar(200)=
--  case when @state_changed_date_from is not null 
--  then N' and state_changed_date>= '''+format(convert(datetime2, @state_changed_date_from), 'yyyy-MM-dd HH:mm:00')+N'.000'''
--  else N'' end;

--  declare @state_changed_date_toP nvarchar(200)=
--  case when @state_changed_date_to is not null 
--  then N' and state_changed_date<= '''+format(convert(datetime2, @state_changed_date_to), 'yyyy-MM-dd HH:mm:59')+N'.999'''
--  else N'' end;



--   declare @state_changed_date_done_fromP nvarchar(200)=
--  case when @state_changed_date_done_from is not null 
--  then N' and state_changed_date_done>= '''+format(convert(datetime2, @state_changed_date_done_from), 'yyyy-MM-dd HH:mm:00')+N'.000'''
--  else N'' end;

--  declare @state_changed_date_done_toP nvarchar(200)=
--  case when @state_changed_date_done_to is not null 
--  then N' and state_changed_date_done<= '''+format(convert(datetime2, @state_changed_date_done_to), 'yyyy-MM-dd HH:mm:59')+N'.999'''
--  else N'' end;


--   declare @execution_term_fromP nvarchar(200)=
--  case when @execution_term_from is not null 
--  then N' and convert(date, execution_term)>= '''+format(convert(date, dateadd(hh, 5, @execution_term_from)), 'yyyy-MM-dd')+N''''
--  else N'' end;

--  declare @execution_term_toP nvarchar(200)=
--  case when @execution_term_to is not null 
--  then N' and convert(date, execution_term)<= '''+format(convert(date, dateadd(hh, 5, @execution_term_to)), 'yyyy-MM-dd')+N''''
--  else N'' end;

--  declare @control_date_fromP nvarchar(200)=
--  case when @control_date_from is not null 
--  then N' and control_date>= '''+format(convert(datetime2, @control_date_from), 'yyyy-MM-dd HH:mm:00')+N'.000'''
--  else N'' end;

--  declare @control_date_toP nvarchar(200)=
--  case when @control_date_to is not null 
--  then N' and control_date<= '''+format(convert(datetime2, @control_date_to), 'yyyy-MM-dd HH:mm:59')+N'.999'''
--  else N'' end;

--  --- убрать

--  --select @execution_term_fromP, @execution_term_toP 

--    ---перелік параметры начало
--   declare @comment_qls nvarchar(5);
--   declare @de_comment nvarchar(5);

--   set @comment_qls =(
--   select case when CHARINDEX(N'question_list_state in (', @param1, 0)>0
--   then N'' else N'--' end);

--   set @de_comment = case when @comment_qls=N'--' then N'' else N'--' end;

--   ---перелік параметры конец
--   --select @comment_qls, @de_comment


--  declare @param4 nvarchar(max)=@registration_date_fromP+@registration_date_toP+@transfer_date_fromP+@transfer_date_toP
--  +@state_changed_date_fromP+@state_changed_date_toP
--  +@state_changed_date_done_fromP+@state_changed_date_done_toP
--  +@execution_term_fromP+@execution_term_toP
--  +@control_date_fromP+@control_date_toP


--   declare @organizations nvarchar(max);

-- declare @param3 nvarchar(max);
-- if CHARINDEX(N'question_question_type',@param1, 1)>0

-- begin

-- declare @q_types nvarchar(max)=
-- (right(left(SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), 1)),
-- len(left(SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), 1)))-
-- CHARINDEX(N'(', left(SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), 1)), 1)+1))


-- declare @input_str nvarchar(max)=REPLACE(REPLACE(@q_types, N')', N''),N'(',N'')+N','

-- declare @table table (n int identity(1,1), id int)
 
-- -- создаем переменную, хранящую разделитель
-- declare @delimeter nvarchar(1) = ','
 
-- -- определяем позицию первого разделителя
-- declare @pos int = charindex(@delimeter,@input_str)
 
-- -- создаем переменную для хранения
-- -- одного айдишника
-- declare @id nvarchar(10)
    
-- while (@pos != 0)
-- begin
--     -- получаем айдишник
--     set @id = SUBSTRING(@input_str, 1, @pos-1)
--     -- записываем в таблицу
--     insert into @table (id) values(cast(@id as int))
--     -- сокращаем исходную строку на
--     -- размер полученного айдишника
--     -- и разделителя
--     set @input_str = SUBSTRING(@input_str, @pos+1, LEN(@input_str))
--     -- определяем позицию след. разделителя
--     set @pos = CHARINDEX(@delimeter,@input_str)
-- end

-- 			 declare @question_typ nvarchar(max)=(
-- 			 select stuff((select N', '+[QuestionTypesAndParent].QuestionTypes
--   from [QuestionTypesAndParent] with (nolock)
--   inner join @table t on [QuestionTypesAndParent].[ParentId]=t.id
--   for xml path('')), 1,2,N''))

-- 			 set @param3 =replace(@param1 
-- 			 ,left(SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'question_question_type',@param1, 1) ,len(@param1)-CHARINDEX(N'question_question_type',@param1, 1)+1), 1))
-- 			 ,N'question_question_type in ('+@question_typ+N')')

-- 			end

-- 			else
-- 			begin
-- 			set @param3=@param1;
-- 			end;

-- -------------- next

--  declare @assigm_executor_organizations nvarchar(max);
--  -----найти подтипы вопросов начало
--  /* найти под типы вопросов*/
-- --declare @param1 nvarchar(500)=N'id=123 and Id=54545';
-- declare @param_ex nvarchar(max);
-- if CHARINDEX(N'assigm_executor_organization',@param1, 1)>0

-- begin

-- declare @executors nvarchar(max)=
-- (right(left(SUBSTRING(@param1,CHARINDEX(N'assigm_executor_organization',@param1, 1) ,len(@param1)-CHARINDEX(N'assigm_executor_organization',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'assigm_executor_organization',@param1, 1) ,len(@param1)-CHARINDEX(N'assigm_executor_organization',@param1, 1)+1), 1)),
-- len(left(SUBSTRING(@param1,CHARINDEX(N'assigm_executor_organization',@param1, 1) ,len(@param1)-CHARINDEX(N'assigm_executor_organization',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'assigm_executor_organization',@param1, 1) ,len(@param1)-CHARINDEX(N'assigm_executor_organization',@param1, 1)+1), 1)))-
-- CHARINDEX(N'(', left(SUBSTRING(@param1,CHARINDEX(N'assigm_executor_organization',@param1, 1) ,len(@param1)-CHARINDEX(N'assigm_executor_organization',@param1, 1)+1), CHARINDEX(N')', SUBSTRING(@param1,CHARINDEX(N'assigm_executor_organization',@param1, 1) ,len(@param1)-CHARINDEX(N'assigm_executor_organization',@param1, 1)+1), 1)), 1)+1))



-- declare @input_str_ex nvarchar(max)=REPLACE(REPLACE(@executors, N')', N''),N'(',N'')+N','

-- declare @table_ex table (n int identity(1,1), id int)
 
-- -- создаем переменную, хранящую разделитель
-- declare @delimeter_ex nvarchar(1) = ','
 
-- -- определяем позицию первого разделителя
-- declare @pos_ex int = charindex(@delimeter_ex,@input_str_ex)
 
-- -- создаем переменную для хранения
-- -- одного айдишника
-- declare @id_ex nvarchar(10)
    
-- while (@pos_ex != 0)
-- begin
--     -- получаем айдишник
--     set @id_ex = SUBSTRING(@input_str_ex, 1, @pos_ex-1)
--     -- записываем в таблицу
--     insert into @table_ex (id) values(cast(@id_ex as int))
--     -- сокращаем исходную строку на
--     -- размер полученного айдишника
--     -- и разделителя
--     set @input_str_ex = SUBSTRING(@input_str_ex, @pos_ex+1, LEN(@input_str_ex))
--     -- определяем позицию след. разделителя
--     set @pos_ex = CHARINDEX(@delimeter_ex,@input_str_ex)
-- end

-- 				 set @param_ex =replace(@param3 
-- 				 ,left(SUBSTRING(@param3,CHARINDEX(N'assigm_executor_organization',@param3, 1) ,len(@param3)-CHARINDEX(N'assigm_executor_organization',@param3, 1)+1), CHARINDEX(N')', SUBSTRING(@param3,CHARINDEX(N'assigm_executor_organization',@param3, 1) ,len(@param3)-CHARINDEX(N'assigm_executor_organization',@param3, 1)+1), 1))
-- 				 ,N'assigm_executor_organization in ('+(select stuff((
--   select N', '+[OrganizationsAndParent].Organizations
--   from [OrganizationsAndParent]
--   inner join @table_ex t on [OrganizationsAndParent].ParentId=t.Id
--   for xml path('')), 1, 2,N''))+N')')
-- 				-- select N'question_question_type in ('+@question_typ+N')' --question_question_type in (2, 3, 7, 8)

-- 				end

-- 				else
-- 				begin
-- 				set @param_ex=@param3;
-- 				end;

   
-- declare @OrgTable table (Id int identity(1,1), OrgId int);
-- declare @Organization table(Id int);
-- declare @IdT table (Id int);
-- declare @OrganizationId int;
-- declare @n int=1;


--   -- @execution_term_from

--   declare @param2 nvarchar(max)=
--    --case when CHARINDEX('cast(execution_term as datetime) >=', @param3, 0)=0 and CHARINDEX('cast(execution_term as datetime) <=', @param3, 0)>0

--       case when @execution_term_from is null and @execution_term_to is not null
--   then @param_ex+N' and [assigm_assignment_state_name]<>N''Закрито''' --Зареєстровано Закрито
--   else @param_ex end+@param4;


--   -------замена
--   declare @param_new nvarchar(max)=
--   (
--   select case when CHARINDEX('question_registration_number like ''%', @param2, 1)>0
--   then REPLACE(@param2, 
--   'question_registration_number like ''%'+ right(left(@param2, CHARINDEX('%''', @param2, CHARINDEX('question_registration_number like ''%', @param2, 1))-1), 
--   CHARINDEX('%''', @param2, CHARINDEX('question_registration_number like ''%', @param2, 1))
--   -CHARINDEX('question_registration_number like ''%', @param2, 1)
--   -len('question_registration_number like ''%'))+N'%''',
  
--   N'appeals_registration_number in (N'''+
--   REPLACE(
--   right(left(@param2, CHARINDEX('%''', @param2, CHARINDEX('question_registration_number like ''%', @param2, 1))-1), 
--   CHARINDEX('%''', @param2, CHARINDEX('question_registration_number like ''%', @param2, 1))
--   -CHARINDEX('question_registration_number like ''%', @param2, 1)
--   -len('question_registration_number like ''%')
--   ), N', ', N''', N''')
--   +N''')')
--   else @param2 end
--   )


--  -- select @param_new
--  /*
--  declare @param_new2 nvarchar(max)=
--  case when @zayavnyk_phone_number is not null
--  then @param_new+N' and zayavnyk_phone_number_reverse like '+N''''+REVERSE(@zayavnyk_phone_number)+N'%'''
--  else @param_new
--  end 
--  */
--  --select @param_new2;
-- -- select @param_new;
--   -------


--   /* здесь нужно поставить условие, что если у данного человека есть организация 1761 то 1=1
--   иначе нужн запустить пересчет*/

--   --заполение таблицы организацией и ее под
--   declare @organization_id1761 int =1761;
--   declare @Organization1761 table(Id int);
--   declare @OrganizationId1761 int = @organization_id1761;
--   declare @IdT1761 table (Id int);
--  -- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
--  insert into @IdT1761(Id)
--  select Id from [Organizations] with (nolock)
--  where (Id=@OrganizationId1761 or [parent_organization_id]=@OrganizationId1761) and Id not in (select Id from @IdT1761)
--  --  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
--  while (select count(id) from (select Id from [Organizations] with (nolock)
--  where [parent_organization_id] in (select Id from @IdT1761) --or Id in (select Id from @IdT)
--  and Id not in (select Id from @IdT1761)) q)!=0
--  begin
--  insert into @IdT1761
--  select Id from [Organizations] with (nolock)
--  where [parent_organization_id] in (select Id from @IdT1761) --or Id in (select Id from @IdT)
--  and Id not in (select Id from @IdT1761)
--  end 
--  insert into @Organization1761 (Id)
--  select Id from @IdT1761;
--  -- вторая часть, там, где данная организация является дочерней и залить в основную таблицу

--  declare @organization_id1761L int =1761;
-- declare @Organization1761L table(Id int, Id_n int);
-- declare @OrganizationId1761L int =  @organization_id1761L;
-- declare @IdT1761L table (Id int, Id_n int identity(1,1));
-- insert into @IdT1761L(Id) select @OrganizationId1761L
-- while (select [parent_organization_id] from [Organizations] with (nolock) where Id=(select top 1 Id from @IdT1761L order by Id_n desc)) is not null
-- begin 
-- -- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
-- insert into @IdT1761L(Id)
-- select [parent_organization_id] from [Organizations] with (nolock)
-- where Id=(select top 1 Id from @IdT1761L order by Id_n desc) --and Id not in (select Id from @IdT)

-- end

-- insert into @Organization1761 (Id)
-- select Id from @IdT1761L where id<>1761

--  -- начало оптимизации
-- 			 if exists
-- 			 (select [OrganizationInResponsibilityRights].organization_id
-- 			  from [OrganizationInResponsibilityRights] with (nolock)
-- 			  inner join [Positions] with (nolock) on [OrganizationInResponsibilityRights].position_id=[Positions].Id
-- 			  inner join @Organization1761 o1761 on [OrganizationInResponsibilityRights].organization_id=o1761.Id
-- 			  where [Positions].programuser_id=@user_id )

-- 			  begin
-- 			  set @organizations=N'1=1'
-- 			  end

-- 			  else
-- 			  begin

-- 						set @organizations=N'Organizations2_Id in ('+
-- 					  (select stuff((select N', '+
-- [OrganizationsAndParent].Organizations
-- from [OrganizationInResponsibilityRights] with (nolock)
-- inner join [Positions] with (nolock) on [OrganizationInResponsibilityRights].position_id=[Positions].Id
-- inner join [OrganizationsAndParent] with (nolock) on [OrganizationInResponsibilityRights].organization_id=[OrganizationsAndParent].ParentId
-- where [Positions].programuser_id=@user_id
-- for xml path ('')),1,2,N''))+N')'

-- 					  end
--   -- конец оптимизации 
--   --select @param2, @organizations
--   --SELECT RTRIM(CAST(DATEDIFF(MS, @start_time, GETDATE()) AS CHAR(10))) AS 'TimeTaken'
  
--   --select @param_new, @organizations, @zayavnyk_phone_number

--   --------параметры для фильтрации начало
--   --по номеру телефону
--   -- declare @zayavnyk_phone_number nvarchar(max);--=N'062'; --0442859062

-- declare @filter_zayavnyk_phone_number nvarchar(700)=case when @zayavnyk_phone_number is not null
-- then N'
-- inner join
-- (
-- select distinct t1.applicant_id, stuff((select N'', ''+phone_number
--   from [ApplicantPhones] with (nolock)
--   where [phone_number_reverse] like '''+REVERSE(@zayavnyk_phone_number)+N'%''
--   and [ApplicantPhones].applicant_id=t1.applicant_id
--   for xml path ('''')), 1,2,N'''') phone_number
--   from
--   (select applicant_id, phone_number
--   from [ApplicantPhones] with (nolock)
--   where [phone_number_reverse] like '''+REVERSE(@zayavnyk_phone_number)+N'%'' ) t1
--   ) 
--   '
--   else N'left join (select distinct t2.applicant_id, stuff((
--   select N'', ''+[phone_number]
--   from [ApplicantPhones] t1 with (nolock)
--   where t1.applicant_id=t2.applicant_id
--   for xml path('''')), 1, 2, N'''') [phone_number]
--   from [ApplicantPhones] t2 with (nolock)) '
--   end;

--  -- select @filter_zayavnyk_phone_number

--   ---район
--   declare @filter_appeals_district nvarchar(20)=
-- case when charindex(N'appeals_district in (', @param1,  1)>0
-- then N'inner join'
-- else N'left join'
-- end;
-- --джерело надходження
-- declare @appeals_receipt_source nvarchar(20)=
-- case when charindex(N'appeals_receipt_source in (', @param1,  1)>0
-- then N'inner join'
-- else N'left join'
-- end;

-- --відповідальний
-- declare @filter_assigm_accountable nvarchar(20)=
-- case when charindex(N'assigm_accountable in (', @param1,  1)>0
-- then N'inner join'
-- else N'left join'
-- end;
-- --резолюція
-- declare @filter_assigm_assignment_resolution nvarchar(20)=
-- case when charindex(N'assigm_assignment_resolution in (', @param1,  1)>0
-- then N'inner join'
-- else N'left join'
-- end;
-- --результат
-- declare @filter_assigm_assignment_result nvarchar(20)=
-- case when charindex(N'assigm_assignment_result in (', @param1,  1)>0
-- then N'inner join'
-- else N'left join'
-- end;
-- --стан
-- declare @filter_assigm_assignment_state nvarchar(20)=
-- case when charindex(N'assigm_assignment_state in (', @param1,  1)>0
-- then N'inner join'
-- else N'left join'
-- end;
-- --перевірив
-- declare @filter_assigm_user_checked nvarchar(20)=
-- case when charindex(N'assigm_user_checked in (', @param1,  1)>0
-- then N'inner join'
-- else N'left join'
-- end;
-- --розглянув
-- declare @filter_assigm_user_reviewed nvarchar(20)=
-- case when charindex(N'assigm_user_reviewed in (', @param1,  1)>0
-- then N'inner join'
-- else N'left join'
-- end;
-- --перелік
-- declare @filter_question_list_state nvarchar(20)=
-- case when charindex(N'question_list_state in (', @param1,  1)>0
-- then N'inner join'
-- else N'left join'
-- end;
-- --об'єкт
-- declare @filter_question_object nvarchar(20)=
-- case when charindex(N'question_object in (', @param1,  1)>0
-- then N'inner join'
-- else N'left join'
-- end;
-- --тип об'єкту
-- declare @filter_question_ObjectTypes nvarchar(20)=
-- case when charindex(N'question_ObjectTypes in (', @param1,  1)>0
-- then N'inner join'
-- else N'left join'
-- end;
-- --організація
-- declare @filter_question_organization nvarchar(20)=
-- case when charindex(N'question_organization in (', @param1,  1)>0
-- then N'inner join'
-- else N'left join'
-- end;
-- --тип питання
-- declare @filter_question_question_type nvarchar(20)=
-- case when charindex(N'question_question_type in (', @param1,  1)>0
-- then N'inner join'
-- else N'left join'
-- end;
-- --передано
-- declare @filter_transfer_date nvarchar(20)=
-- case when @transfer_date_from is not null or @transfer_date_to is not null
-- then N'inner join'
-- else N'left join'
-- end;
-- --пільга
-- declare @filter_zayavnyk_applicant_privilage nvarchar(20)=
-- case when charindex(N'zayavnyk_applicant_privilage in (', @param1,  1)>0
-- then N'inner join'
-- else N'left join'
-- end;
-- --тип заявника
-- declare @filter_zayavnyk_applicant_type nvarchar(20)=
-- case when charindex(N'zayavnyk_applicant_type in (', @param1,  1)>0
-- then N'inner join'
-- else N'left join'
-- end;
-- --парадне, квартира
-- declare @filter_zayavnyk_entrance_zayavnyk_flat_district nvarchar(20)=
-- case when charindex(N'zayavnyk_entrance like', @param1,  1)>0 or charindex(N'zayavnyk_flat like', @param1,  1)>0
-- or charindex(N'appeals_district in (', @param1,  1)>0
-- then N'inner join'
-- else N'left join'
-- end;
-- --соціальний стан
-- declare @filter_zayavnyk_social_state nvarchar(20)=
-- case when charindex(N'zayavnyk_social_state in (', @param1,  1)>0
-- then N'inner join'
-- else N'left join'
-- end;
--   --------параметры для фильтрации конец

-- --select @param_new

-- declare @query nvarchar(max)=N'
-- select distinct --top 5000
--    [Id]
--   ,[appeals_receipt_source_name] [appeals_receipt_source]
--   ,[appeals_user_name] [appeals_user]
--   ,[appeals_district_name] [appeals_district] 
--   ,[appeals_files_check]
--   ,[zayavnyk_full_name]
--   ,[zayavnyk_phone_number]
--   ,[zayavnyk_building_street_name] [zayavnyk_building_street]

--   ,isnull([shortname],N'''')+N'' ''+[zayavnyk_building_street_name]+N'', ''+[zayavnyk_building_number_name] [zayavnyk_building_number]


--   ,[zayavnyk_entrance]
--   ,[zayavnyk_flat]
--   ,[zayavnyk_applicant_privilage_name] [zayavnyk_applicant_privilage]
--   ,[zayavnyk_social_state_name] [zayavnyk_social_state]
--   ,[zayavnyk_sex_name] [zayavnyk_sex]
--   ,[zayavnyk_applicant_type_name] [zayavnyk_applicant_type]
--   ,[zayavnyk_age]
--   ,[zayavnyk_email]
--   ,[question_registration_number]
--   ,[question_ObjectTypes_name] [question_ObjectTypes]
--   ,[question_object_name] [question_object]
--   ,[question_organization_name] [question_organization]
--   ,[question_question_type_name] [question_question_type]
--   ,[question_question_state_name] [question_question_state]
--   ,[question_list_state_name] [question_list_state]
--   ,[assigm_executor_organization_name] [assigm_executor_organization]
--   ,[assigm_main_executor]
--   ,[assigm_question_content]
--   ,[assigm_accountable_name] [assigm_accountable] 
--   ,[assigm_assignment_state_name] [assigm_assignment_state]  
--   ,[assigm_assignment_result_name] [assigm_assignment_result] 
--   ,[assigm_assignment_resolution_name] [assigm_assignment_resolution]
--   ,[assigm_user_reviewed_name] [assigm_user_reviewed] 
--   ,[assigm_user_checked_name] [assigm_user_checked]

--   ,convert(datetime, [registration_date]) [registration_date]
--   ,convert(datetime, [transfer_date]) [transfer_date]
--   ,convert(datetime, [state_changed_date]) [state_changed_date]
--   ,convert(datetime, [state_changed_date_done]) [state_changed_date_done]
  
--   ,[execution_term] 
--   ,[appeals_enter_number]
--   ,[control_comment]

--   ,[ConsDocumentContent]
--   ,[control_date]

--  from
--  (
--   select distinct [Assignments].Id,
--   [Appeals].receipt_source_id [appeals_receipt_source]
--   ,[ReceiptSources].name [appeals_receipt_source_name]
--   ,[Appeals].user_id [appeals_user]
--   ,[Workers].name [appeals_user_name]
--   ,[Districts].Id [appeals_district] 
--   ,[Districts].name [appeals_district_name] 
--   --,case when files_check.assignment_сons_id is not null then ''true'' else ''false'' end appeals_files_check
--   ,''fasle'' appeals_files_check -- изменить
--   ,[Applicants].full_name zayavnyk_full_name
--   --,phone_number zayavnyk_phone_number

--    --,phone_number zayavnyk_phone_number_reverse

--   ,[Streets].Id [zayavnyk_building_street]
--   ,[Streets].name [zayavnyk_building_street_name]
--   ,[Buildings].Id [zayavnyk_building_number]
--   ,[Buildings].name [zayavnyk_building_number_name]
--   ,[LiveAddress].entrance [zayavnyk_entrance]
--   ,[LiveAddress].flat [zayavnyk_flat]
--   ,[ApplicantPrivilege].Id [zayavnyk_applicant_privilage]
--   ,[ApplicantPrivilege].Name [zayavnyk_applicant_privilage_name]
--   ,[SocialStates].Id [zayavnyk_social_state]
--   ,[SocialStates].name [zayavnyk_social_state_name]
--   ,[Applicants].sex [zayavnyk_sex]
--   ,case when [Applicants].sex=1 then N''жіноча'' when [Applicants].sex=2 then N''чоловіча'' end [zayavnyk_sex_name]
--   ,[ApplicantTypes].Id [zayavnyk_applicant_type]
--   ,[ApplicantTypes].name [zayavnyk_applicant_type_name]
--   ,case 
-- when [Applicants].[birth_date] is null then year(getdate())-[Applicants].birth_year
--   when month([Applicants].[birth_date])<=month(getdate())
--   and day([Applicants].[birth_date])<=day(getdate())
--   then DATEDIFF(yy, [Applicants].[birth_date], getdate())
--   else DATEDIFF(yy, [Applicants].[birth_date], getdate())-1 end zayavnyk_age,
--   [Applicants].mail zayavnyk_email
  
--   ,[Questions].registration_number [question_registration_number]
--   ,[ObjectTypes].Id [question_ObjectTypes]
--   ,[ObjectTypes].name [question_ObjectTypes_name]
--   ,[Objects].Id [question_object]
--   ,[Objects].name [question_object_name]
--   ,[Organizations].Id [question_organization]
--   ,[Organizations].short_name [question_organization_name]
--   ,[QuestionTypes].Id [question_question_type]
--   ,[QuestionTypes].name [question_question_type_name]
--   ,[QuestionStates].Id [question_question_state]
--   ,[QuestionStates].name [question_question_state_name]
--   '+@comment_qls+N',[Rating].Id [question_list_state] --@comment_qls
--   '+@de_comment+N' , null [question_list_state]
--   '+@comment_qls+N',[Rating].name [question_list_state_name] --@comment_qls
--   '+@de_comment+N' , null [question_list_state_name]

--   --,[Rating].name [question_list_state_name]

--   ,[Assignments].executor_organization_id [assigm_executor_organization] -- good
--   ,IIF (len([Organizations2].[head_name]) > 5,  concat([Organizations2].[head_name] , '' ( '' , [Organizations2].[short_name] , '')''),  [Organizations2].[short_name]) [assigm_executor_organization_name]
--   ,[Assignments].main_executor [assigm_main_executor] -- good
--   ,[Questions].question_content [assigm_question_content] -- good
--    ,[Organizations10].[short_name] [assigm_accountable_name] -- good
--    ,[Organizations10].Id [assigm_accountable]

--   ,[AssignmentStates].Id [assigm_assignment_state] -- good
--   ,[AssignmentStates].name [assigm_assignment_state_name] -- good
         
--   ,[AssignmentResults].Id [assigm_assignment_result] -- good
--   ,[AssignmentResults].name [assigm_assignment_result_name] -- good
        
--   ,[AssignmentResolutions].Id [assigm_assignment_resolution] -- good
--   ,[AssignmentResolutions].name [assigm_assignment_resolution_name] -- good

--   ,[Workers2].Id [assigm_user_reviewed]
--   ,[Workers2].name [assigm_user_reviewed_name] -- good


--   ,[Workers3].name [assigm_user_checked_name]
--   ,[Workers3].Id [assigm_user_checked]

--   ,[Assignments].registration_date  as  [registration_date] -- good
--   ,[AssignmentConsiderations].transfer_date [transfer_date] -- good
--   ,case when [Assignments].assignment_state_id=3
--   then [Assignments].state_change_date end [state_changed_date] -- good
--   ,case when [Assignments].assignment_state_id=3 and [AssignmentConsiderations].assignment_result_id=4
--   then [Assignments].state_change_date end [state_changed_date_done] -- good
--   ,[Assignments].[execution_date] [execution_term] --good
 
--  , [StreetTypes].[shortname]
--  , [Appeals].[enter_number] appeals_enter_number
--  , [Organizations2].Id Organizations2_Id
--  , [AssignmentConsiderations].short_answer [control_comment]

--  --,files_check.[content] ConsDocumentContent
--  , null ConsDocumentContent-- изменить
--  ,[AssignmentRevisions].control_date
--  ,App_phone.phone_number zayavnyk_phone_number
--  ,[Appeals].[registration_number] appeals_registration_number
--   from 
--   [Assignments] with (nolock)
--   inner join [Questions] with (nolock) on [Assignments].question_id=[Questions].Id
--   inner join [Appeals] with (nolock) on [Questions].[appeal_id]=[Appeals].Id
--   left join [Applicants] with (nolock) on [Applicants].Id=[Appeals].applicant_id
--   '+@filter_zayavnyk_phone_number+N' App_phone on [Applicants].Id=App_phone.applicant_id
--   '+@filter_transfer_date+N' [AssignmentConsiderations] with (nolock) on [AssignmentConsiderations].Id = Assignments.current_assignment_consideration_id
--   '+@filter_assigm_assignment_state+N' [AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
--   '+@filter_assigm_assignment_result+N' [AssignmentResults] with (nolock) on [AssignmentConsiderations].assignment_result_id=[AssignmentResults].Id
--   '+@filter_assigm_assignment_resolution+N' [AssignmentResolutions] with (nolock) on [AssignmentConsiderations].assignment_resolution_id=[AssignmentResolutions].id
--   left join [AssignmentRevisions] with (nolock) on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
--   inner join [Organizations] [Organizations2] with (nolock) on [Assignments].executor_organization_id=[Organizations2].Id
--   '+@filter_assigm_user_reviewed+N' [Workers] [Workers2] with (nolock) on [AssignmentConsiderations].user_id=[Workers2].worker_user_id
--   '+@filter_assigm_user_checked+N' [Workers] [Workers3] with (nolock) on [AssignmentRevisions].[user_edit_id]=[Workers3].worker_user_id
--   '+@appeals_receipt_source+N' [ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
--   left join [Workers] with (nolock) on [Appeals].user_id=[Workers].worker_user_id
--   '+@filter_zayavnyk_entrance_zayavnyk_flat_district+N' [LiveAddress] with (nolock) on [LiveAddress].applicant_id=[Applicants].Id
--   '+@filter_appeals_district+' [Buildings] with (nolock) on [LiveAddress].building_id=[Buildings].Id
--   '+@filter_appeals_district+N'  [Districts]  on [Buildings].district_id=[Districts].Id 
--   '+@filter_appeals_district+N' [Streets] with (nolock) on [Buildings].street_id=[Streets].Id
--   '+@filter_appeals_district+N' [StreetTypes] with (nolock) on [Streets].[street_type_id]=[StreetTypes].Id
--   '+@filter_zayavnyk_applicant_privilage+N' [ApplicantPrivilege] with (nolock) on [Applicants].applicant_privilage_id=[ApplicantPrivilege].Id
--   '+@filter_zayavnyk_social_state+' [SocialStates] with (nolock) on [Applicants].social_state_id=[SocialStates].Id
--   '+@filter_zayavnyk_applicant_type+' [ApplicantTypes] with (nolock) on [Applicants].applicant_type_id=[ApplicantTypes].Id
--   '+@filter_question_object+N' [Objects] with (nolock) on [Questions].object_id=[Objects].Id
--   '+@filter_question_ObjectTypes+N' [ObjectTypes] with (nolock) on [Objects].object_type_id=[ObjectTypes].Id
--   '+@filter_question_organization+N' [Organizations] with (nolock) on [Questions].organization_id=[Organizations].Id
--   '+@filter_question_question_type+N' [QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
--   inner join [QuestionStates] with (nolock) on [Questions].question_state_id=[QuestionStates].Id
--   '+@comment_qls+N'left join [QuestionTypeInRating] with (nolock) on [QuestionTypeInRating].QuestionType_id=[QuestionTypes].Id
--   '+@comment_qls+N' '+@filter_question_list_state+N' [Rating] with (nolock) on [QuestionTypeInRating].Rating_id=[Rating].Id
--   '+@filter_assigm_accountable+N' [Organizations] [Organizations10] with (nolock) on [Assignments].[executor_organization_id]=[Organizations10].id
--   /*left join (select distinct [AssignmentConsDocuments].assignment_сons_id, [content]
--   from [AssignmentConsDocuments] with (nolock)
--   right join [AssignmentConsDocFiles] with (nolock) on [AssignmentConsDocuments].Id=[AssignmentConsDocFiles].assignment_cons_doc_id
--   where [AssignmentConsDocuments].[doc_type_id] in (3,4) or [AssignmentConsDocuments].Id is not null) files_check on [AssignmentConsiderations].Id=files_check.assignment_сons_id*/

  



--   ) a
--   where '+@param_new+ N'  and '+@organizations+N' 
-- '
-- -------
--  -- and #filter_columns#
--  -- #sort_columns#
--  --offset ' + (select ltrim(@pageOffsetRows))+N' rows fetch next '+ (select ltrim(@pageLimitRows))+N' rows only
 
--  --select @query
--  --comment
--   exec(@query)

  