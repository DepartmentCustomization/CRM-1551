
--declare @appealNum nvarchar(400)=N'9-5, 9-470, 9-1000, 9-994, 9-986, Вася привет,Вася пока';

declare @input_str nvarchar(max) = replace(@appealNum, N', ', N',')+N', ';

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
end

--select * from @table



select [Assignments].Id, [ReceiptSources].name navigation, [Questions].registration_number, [QuestionTypes].name QuestionType,
[Applicants].full_name zayavnyk, [StreetTypes].shortname+Streets.name+N', '+[Buildings].name adress,
[Organizations].short_name vykonavets, [Applicants].Id zayavnykId, [Questions].Id QuestionId
,[AssignmentConsiderations].short_answer, [Questions].question_content
, 
 [Applicants].[ApplicantAdress] adressZ
from [Assignments] with (nolock)
inner join [Questions] with (nolock) on [Assignments].question_id=[Questions].Id
inner join [Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
inner join [ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
left join [Applicants] with (nolock) on [Appeals].applicant_id=[Applicants].Id
left join [Objects] with (nolock) on [Questions].[object_id]=[Objects].Id
left join [Buildings] with (nolock) on [Objects].builbing_id=[Buildings].Id
left join [Streets] with (nolock) on [Buildings].street_id=[Streets].Id
left join [StreetTypes] with (nolock) on [Streets].street_type_id=[StreetTypes].Id
left join [Organizations] with (nolock) on [Assignments].executor_organization_id=[Organizations].Id
left join [AssignmentConsiderations] with (nolock) on [AssignmentConsiderations].Id = Assignments.current_assignment_consideration_id

where ([Appeals].registration_number in (select Id from @table o) or [Appeals].[enter_number] in (select Id from @table o))--=@appealNum
/**/
and #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only


