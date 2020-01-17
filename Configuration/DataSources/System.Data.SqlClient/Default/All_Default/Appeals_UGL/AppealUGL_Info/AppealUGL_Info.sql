-- declare @Id int = 5399849;

declare @uglId int = (select top 1 Id from [Звернення УГЛ] where Appeals_id = @Id)
declare @full_phone1 nvarchar(500) = (select top 1 Телефон from [Звернення УГЛ] where Id = @uglId )

declare @numbers table (rownum int, uglId int, num nvarchar(15));
insert into @numbers
SELECT 
  ROW_NUMBER() OVER(ORDER BY value ASC), 
  @uglId, value from string_split(@full_phone1, ',');

update @numbers set num = replace(num,' ', '')

update @numbers
set num = 
case 
  when len(num) > 10 then 
case 
when (LEFT(num, 2) = '38') then RIGHT(num, len(num)-2)
when (LEFT(num, 1) = '3') and (LEFT(num, 2) <> '38') then RIGHT(num, len(num)-1)
when (LEFT(num, 1) = '8') then RIGHT(num, len(num)-1)
 end 
  when len(num) < 10 AND (LEFT(num, 1) != '0') then N'0' + num 
  else num
end

declare @phone_qty int = (select count(1) from @numbers);
declare @step int = 1;
declare @full_phone2 nvarchar(500);
declare @current_phone nvarchar(10);

while (@step <= @phone_qty)
begin
set @current_phone = (select num from @numbers ORDER BY rownum ASC OFFSET @step-1 ROW FETCH NEXT 1 ROWS ONLY);
set @full_phone2 = isnull(@full_phone2,'') + IIF(len(@full_phone2)>1,N', ' + @current_phone, @current_phone)
set @step += 1;
end

select top 1
[№ звернення] as incomNum, 
@full_phone2 as phone,
@full_phone2 as full_phone,
convert(varchar, [Дата завантаження],(120)) as incomDate,
Заявник as Applicant_PIB,
Зміст as Question_Content, 
Заявник +
  + CHAR(13) +
 case when Адреса is not null then 
 'Адреса: ' + Адреса else '' end
  + CHAR(13) + 
  case when [E-mail] is not null then 
  [E-mail] else '' end 
  + case when [Соціальний стан] is not null and [E-mail] is not null then 
   ', Соц. стан: ' + [Соціальний стан] 
         when a.[Соціальний стан] is not null and a.[E-mail] is null then 
		 'Соц. стан: ' + [Соціальний стан] else '' end +
   case when a.Категорія is not null and [Соціальний стан] is not null then 
   ( ', ' + 'Категорія: ' + Категорія) 
   when Категорія is not null and [Соціальний стан] is null then
   ('Категорія: ' + Категорія) else '' end + 
   case when [Дата народження] is not null and Категорія is not null then 
  ', ' + cast([Дата народження] as varchar) 
  when [Дата народження] is not null and a.Категорія is null then
  cast([Дата народження] as varchar)  else '' end
 as ApplicantUGL,
 a.Id as uglId,
 appeal.registration_number as appealNum,
 Адреса as applicantAddress 

from dbo.[Звернення УГЛ] a
join Appeals appeal on appeal.Id = a.Appeals_id
where Appeals_id = @Id