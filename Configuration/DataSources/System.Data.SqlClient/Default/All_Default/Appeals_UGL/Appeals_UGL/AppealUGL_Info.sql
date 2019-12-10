declare @appealInfo table (incomNum nvarchar(50), phone nvarchar(13), full_phone nvarchar(max),
                           incomDate varchar(20), Applicant_PIB nvarchar(500), Question_Content nvarchar(max), 
						   ApplicantUGL nvarchar(max), uglId int, appealNum nvarchar(200), applicantAddress nvarchar(500) );
-- declare @Id int = 5398676

Insert into @appealInfo

select 
[№ звернення] as incomNum, 
IIF(
charindex(',', Телефон) > 0, 
(substring(Телефон, 1, 12)),
Телефон 
)  as phone,
Телефон as full_phone,
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

declare @phone nvarchar(12) = ( select phone from @appealInfo );

if (LEN(@phone) > 10 )
begin

  if(LEFT(@phone, 2) = '38')
  update @appealInfo set phone = RIGHT(phone, len(phone)-2);

  else if(LEFT(@phone, 1) = '3') and (LEFT(@phone, 2) <> '38')
  update @appealInfo set phone = RIGHT(phone, len(phone)-1);

  else if(LEFT(@phone, 1) = '8')
  update @appealInfo set phone = RIGHT(phone, len(phone)-1);

  end

  select * from @appealInfo