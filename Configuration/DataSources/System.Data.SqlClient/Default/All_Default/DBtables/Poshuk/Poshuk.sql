/*
declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
declare @organization_id int =1762;
declare @navigation nvarchar(400)=N'Усі';
declare @appealNum nvarchar(400)=N'9-811';
*/

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
end

--select * from @table

declare @Organization table(Id int);


declare @OrganizationId int = 
case 
when @organization_id is not null
then @organization_id
else (select Id
  from [CRM_1551_Analitics].[dbo].[Organizations]
  where Id in (select organization_id
  from [CRM_1551_Analitics].[dbo].[Workers]
  where worker_user_id=@user_id))
 end


declare @IdT table (Id int);

-- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
insert into @IdT(Id)
select Id from [CRM_1551_Analitics].[dbo].[Organizations] 
where (Id=@OrganizationId or [parent_organization_id]=@OrganizationId) and Id not in (select Id from @IdT)

--  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
while (select count(id) from (select Id from [CRM_1551_Analitics].[dbo].[Organizations]
where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
and Id not in (select Id from @IdT)) q)!=0
begin

insert into @IdT
select Id from [CRM_1551_Analitics].[dbo].[Organizations]
where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
and Id not in (select Id from @IdT)
end 

insert into @Organization (Id)
select Id from @IdT;



  
 with

main as
(
select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].name OrganizationsName,
[Applicants].full_name zayavnyk, N'Вул.'+Streets.name+N', буд.'+[Buildings].name adress, [Questions].registration_number,
[QuestionTypes].name QuestionType,
--стало
case when [ReceiptSources].name=N'УГЛ' then N'УГЛ' 
when [ReceiptSources].name=N'Сайт/моб. додаток' then N'Електронні джерела'
when [QuestionTypes].emergency=N'true' then N'Пріоритетне'
when [QuestionTypes].parent_organization_is=N'true' then N'Зауваження'
else N'Інші доручення'
end navigation,
--стало

case when [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'Registered' then 1 else 0 end nadiyshlo,
case when [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'Closed' and [AssignmentResults].code=N'NotInTheCompetence' then 1 else 0 end neVKompetentsii,
case when [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork' and 

dateadd(HH, [execution_term], [Assignments].registration_date)<getdate() 

then 1 else 0 end prostrocheni, 


case when [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork' and 

datediff(HH, [Assignments].registration_date, getdate())>[Attention_term_hours]
and datediff(HH, [Assignments].registration_date, getdate())<=[execution_term]

then 1 else 0 end uvaga,

case when [AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'InWork' and 
datediff(HH, [Assignments].registration_date, getdate())<=[Attention_term_hours]

 then 1 else 0 end vroboti,

 case when [AssignmentTypes].code=N'ToAttention' then 1 else 0 end dovidima,

 case when [AssignmentStates].code=N'NotFulfilled' and [AssignmentResults].code=N'ForWork' then 1 else 0 end naDoopratsiyvanni,
 case when [AssignmentStates].code=N'NotFulfilled' and [AssignmentResults].code=N'ItIsNotPossibleToPerformThisPeriod' then 1 else 0 end neVykonNeMozhl,
 null NotUse

 , [Applicants].Id zayavnykId, [Questions].Id QuestionId, Appeals.registration_number Appealregistration_number,
 [Organizations].short_name vykonavets
 , [AssignmentConsiderations].short_answer, [Questions].question_content
, 
 [Applicants].[ApplicantAdress] adressZ
 ,[AssignmentStates].name AssignmentStates
,[Questions].control_date
from 
[CRM_1551_Analitics].[dbo].[Assignments] left join 
[CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
left join [CRM_1551_Analitics].[dbo].[Appeals] on [Questions].appeal_id=[Appeals].Id
left join [CRM_1551_Analitics].[dbo].[ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
left join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].id
left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left join [CRM_1551_Analitics].[dbo].[Organizations] on [Assignments].executor_organization_id=[Organizations].Id
left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].[object_id]=[Objects].Id
left join [CRM_1551_Analitics].[dbo].[Buildings] on [Objects].builbing_id=[Buildings].Id
left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=[Streets].Id
left join [CRM_1551_Analitics].[dbo].[Applicants] on [Appeals].applicant_id=[Applicants].Id
where [Assignments].[executor_organization_id] in (select id from @Organization)
),

nav as 
(
select 1 Id, N'УГЛ' name union all select 2 Id, N'Сайт' name union all select 3	Id, N'Пріоритетне' name union all select 4 Id, N'Інші доручення' name union all select 5 Id, N'Зауваження' name 
),

table2 as
(
select nav.Id, nav.name navigation, sum(nadiyshlo) nadiyshlo, sum(neVKompetentsii) neVKompetentsii, sum(prostrocheni) prostrocheni, sum(uvaga) uvaga,
sum(vroboti) vroboti, sum(dovidima) dovidoma, sum(naDoopratsiyvanni) naDoopratsiyvanni, sum(neVykonNeMozhl) neVykonNeMozhl
from nav left join main on nav.name=main.navigation
group by nav.Id, nav.name
)



select /*ROW_NUMBER() over(order by registration_number)*/ main.Id, navigation, registration_number, QuestionType, zayavnyk, adress, vykonavets, zayavnykId, QuestionId 
,short_answer, question_content, adressZ, AssignmentStates states, control_date
 from main --where nadiyshlo=1 --navigation, registration_number, from main
 where Appealregistration_number--=@appealNum
 in (select Id from @table)