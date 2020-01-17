/**/
--declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';

--declare @organization_id int =1762;
--declare @navigation nvarchar(400)=N'Усі';
--declare @appealNum nvarchar(400)=N'9-811';


--declare @appealNum nvarchar(400)=N'9-1000, 9-994, 9-986, Вася привет,Вася пока';

declare @input_str nvarchar(2000) = replace(@appealNum, N', ', N',')+N', ';

-- создаем таблицу в которую будем
-- записывать наши айдишники
declare @table table (id nvarchar(500))
 
-- создаем переменную, хранящую разделитель
declare @delimeter nvarchar(2) = ','
 
-- определяем позицию первого разделителя
declare @pos int = charindex(@delimeter,@input_str)
 
-- создаем переменную для хранения
-- одного айдишника
declare @id nvarchar(500)
    
while (@pos != 0)
begin
    -- получаем айдишник
    set @id = SUBSTRING(@input_str, 1, @pos-1)
    -- записываем в таблицу
    insert into @table (id) values(@id)
    -- сокращаем исходную строку на
    -- размер полученного айдишника
    -- и разделителя
    set @input_str = SUBSTRING(@input_str, @pos+1, LEN(@input_str))
    -- определяем позицию след. разделителя
    set @pos = CHARINDEX(@delimeter,@input_str)
end;


--select * from @table


select [Assignments].Id, 
case when [ReceiptSources].code=N'UGL' then N'УГЛ' 
when [ReceiptSources].code=N'Website_mob.addition' then N'Електронні джерела'
when [QuestionTypes].emergency=N'true' then N'Пріоритетне'
when [QuestionTypes].parent_organization_is=N'true' then N'Зауваження'
else N'Інші доручення'
end 
Navigation,
[Questions].Registration_number,
[QuestionTypes].name QuestionType,
[Applicants].full_name Zayavnyk,
isnull([Districts].name+N' р-н, ', N'')
  +isnull([StreetTypes].shortname, N'')
  +isnull([Streets].name,N'')
  +isnull(N', '+[Buildings].name,N'')
  +isnull(N', п. '+[Questions].[entrance], N'')
  +isnull(N', кв. '+[Questions].flat, N'') Adress,
  [Organizations].short_name Vykonavets,
  [Applicants].Id ZayavnykId,
  [Questions].Id QuestionId,
  [Applicants].[ApplicantAdress] Zayavnyk_adress, 
  [Questions].question_content Zayavnyk_zmist,
  [Organizations2].Id [Transfer_to_organization_id],
  [Organizations2].[short_name] [Transfer_to_organization_name],
  [Assignments].[registration_date] Ass_registration_date,
  [Organizations3].short_name Balans_name,
  [Questions].Control_date,
  [AssignmentStates].name AssignmentState

from 
[Assignments] with (nolock) inner join 
[Questions] with (nolock) on [Assignments].question_id=[Questions].Id
left join [Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
left join [ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
left join [AssignmentTypes] with (nolock) on [Assignments].assignment_type_id=[AssignmentTypes].Id
left join [AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [AssignmentConsiderations] with (nolock) on [Assignments].[current_assignment_consideration_id]=[AssignmentConsiderations].id
left join [AssignmentResults] with (nolock) on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
left join [AssignmentResolutions] with (nolock) on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left join [Organizations] with (nolock) on [Assignments].executor_organization_id=[Organizations].Id
left join [Objects] with (nolock) on [Questions].[object_id]=[Objects].Id
left join [Buildings] with (nolock) on [Objects].builbing_id=[Buildings].Id
left join [Streets] with (nolock) on [Buildings].street_id=[Streets].Id
left join [Applicants] with (nolock) on [Appeals].applicant_id=[Applicants].Id
left join [StreetTypes] with (nolock) on [Streets].street_type_id=[StreetTypes].Id
left join [Districts] with (nolock) on [Buildings].district_id=[Districts].Id
left join [Organizations] [Organizations2] with (nolock) on [AssignmentConsiderations].[transfer_to_organization_id]=[Organizations2].Id

left join (select [building_id], [executor_id]
  from [ExecutorInRoleForObject] with (nolock)
  where [executor_role_id]=1 /*Балансоутримувач*/) balans on [Buildings].Id=balans.building_id

left join [Organizations] [Organizations3] with (nolock) on balans.executor_id=[Organizations3].Id

where 
/*((([AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'Registered' and [AssignmentResults].[name]=N'Очікує прийому в роботу') 
or ([AssignmentResults].code=N'ReturnedToTheArtist' and [AssignmentStates].code=N'Registered')))
and*/ Appeals.registration_number in (select Id from @table)
 and #filter_columns#
  order by [Assignments].[registration_date]
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only

--)


