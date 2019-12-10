
/*
declare @Ids nvarchar(300)=N'1490251,1490252'
declare @true_applicant_id int =1490251;
declare @user_Id nvarchar(128)=N'Тестовый';
declare @Id_table int=3;
*/

declare @phone nvarchar(50)=(select PhoneNumber from [ApplicantDublicate] where Id=@Id_table);

-- наша входная строка с айдишниками
declare @input_str nvarchar(max) = @Ids+N',';
-- создаем таблицу в которую будем
-- записывать наши айдишники
declare @table_applicant table (id int)
-- создаем переменную, хранящую разделитель
declare @delimeter nvarchar(1) = ','
-- определяем позицию первого разделителя
declare @pos int = charindex(@delimeter,@input_str)
-- создаем переменную для хранения
-- одного айдишника
declare @id nvarchar(100) 
while (@pos != 0)
begin
    -- получаем айдишник
    set @id = SUBSTRING(@input_str, 1, @pos-1)
    -- записываем в таблицу
    insert into @table_applicant (id) values(cast(@id as int))
    -- сокращаем исходную строку на
    -- размер полученного айдишника
    -- и разделителя
    set @input_str = SUBSTRING(@input_str, @pos+1, LEN(@input_str))
    -- определяем позицию след. разделителя
    set @pos = CHARINDEX(@delimeter,@input_str)
end

--select * from @table_applicant

-- обновить таблицу дубликатов 
/**/
update [ApplicantDublicate]
set [IsDone]='true',
[User_done_id]=@user_Id,
[Done_date]=getutcdate()
where Id=@Id_table

--сформировать таблицу истории

-- апликант, номера телефона через запятую
declare @table_phones table (applicant_id int, phones nvarchar(max));

insert into @table_phones (applicant_id, phones)
select distinct ap1.applicant_id,

stuff((select distinct N', '+replace(ap2.[phone_number], N'+38', N'')
from [ApplicantPhones] ap2
where ap2.applicant_id=ap1.applicant_id
for xml path ('')),1,2,N'') phones

from [ApplicantPhones] ap1
where ap1.applicant_id in (select Id from @table_applicant)

--select * from @table_phones

-- табличка адресов заявителей, заявителей через запятую
declare @table_addresses table (applicant_id int, addresses nvarchar(max));

insert into @table_addresses (applicant_id, addresses)

select distinct la1.applicant_id,

stuff((select N', Id:'+ltrim(la2.Id)+isnull(N', '+st.shortname, N'')+isnull(N', '+s.name, N'')
+isnull(N', корпус '+la2.house_block, N'')+isnull(N', парадне '+ltrim(la2.entrance), N'')+isnull(N', квартира '+la2.flat, N'')
from [LiveAddress] la2
inner join [Buildings] b on la2.building_id=b.Id
left join [Streets] s on b.street_id=s.Id
left join [StreetTypes] st on s.street_type_id=st.Id
where la2.applicant_id=la1.applicant_id
for xml path('')),1,2,N'') addresses

from [LiveAddress] la1
where la1.applicant_id in (select Id from @table_applicant);

--select * from @table_addresses

--заполняется таблица для history
/**/
insert into [ApplicantDublicateHistory]
(
[phone_number]
      ,[applicant_id]
      ,[full_name]
      ,[live_address]
      ,[birth_date]
      ,[birth_year]
      ,[social_state_id]
      ,[category_type_id]
      ,[true_applicant_id]
      ,[user_done_id]
      ,[done_date]
)

select tp.phones-- [phone_number]
      ,a.Id --[applicant_id]
      ,a.full_name--[full_name]
      ,ta.addresses--[live_address]
      ,a.birth_date [birth_date]
      ,a.birth_year [birth_year]
      ,a.social_state_id [social_state_id]
      ,a.category_type_id [category_type_id]
      ,@true_applicant_id [true_applicant_id]
      ,@user_Id [user_done_id]
      ,GETUTCDATE() [done_date]
from [Applicants] a
left join @table_phones tp on a.Id=tp.applicant_id
left join @table_addresses ta on a.Id=ta.applicant_id
where a.Id in (select Id from @table_applicant)


-- обновление таблицы Appeals на новых заявителей
/**/
update [Appeals]
set applicant_id=@true_applicant_id
,[edit_date]=GETUTCDATE()
,[user_edit_id]=@user_Id
where applicant_id in (select Id from @table_applicant)

--Appeal_getApplicantAddress
--обновить таблицу [ApplicantPhones] на нового заявителя и его телефон главный, остальные других выбраных не главные
/**/
update [ApplicantPhones]
set [IsMain]=case when applicant_id=@true_applicant_id then 'true' else 'false' end
,applicant_id=@true_applicant_id
where applicant_id in (select Id from @table_applicant)

--удалить дубликаты по заявителю и по номеру с таблицы [ApplicantPhones]
/**/
delete
from [ApplicantPhones]
where applicant_id=@true_applicant_id
and Id not in (
select min(Id) mid
from [ApplicantPhones]
where applicant_id=@true_applicant_id
group by replace([ApplicantPhones].[phone_number], N'+38', N''))


--обновить таблицу [LiveAddress] на нового заявителя и его адресс главный, остальные других выбраных не главные
/**/
update [LiveAddress]
set main=case when applicant_id=@true_applicant_id then 'true' else 'false' end
,applicant_id=@true_applicant_id
where applicant_id in (select Id from @table_applicant)


--удалить дубликаты по заявителю и по адресу с таблицы [LiveAddress]
/**/
delete
from [LiveAddress]
where applicant_id=@true_applicant_id
and Id not in(
select min(Id) mid
from [LiveAddress]
where applicant_id=@true_applicant_id
group by [building_id], [flat]
)
