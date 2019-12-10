--  declare @dateFrom datetime = '2019-06-01 22:00:00';
--  declare @dateTo datetime = current_timestamp;

--  declare @questionType int = 0;
--  declare @questionGroup int = 0;

 declare @filterFrom datetime = cast(dateadd(day,0,@datefrom) as date);
 declare @filterTo datetime = dateadd(second,59,(dateadd(minute,59,(dateadd(hour,23,cast(cast(dateadd(day,0,@dateTo) as date) as datetime))))));


 declare @question_t table (typeQ int)
 declare @question_g table (typeG int)
 
if @questionType = 0
begin  
 insert into @question_t (typeQ)
 SELECT [Id] from QuestionTypes
 end
 else 
 begin

 -- НАХОДИМ ИД QuestionTypes ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
 insert into @question_t(typeQ)
 select Id from [CRM_1551_Analitics].[dbo].[QuestionTypes] 
 where (Id=@questionType or [question_type_id]=@questionType) and Id not in (select typeQ from @question_t)

 --  НАХОДИМ ПАРЕНТЫ QuestionTypes, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
 while (select count(id) from (select Id from [CRM_1551_Analitics].[dbo].[QuestionTypes]
 where [question_type_id] in (select typeQ from @question_t) 
 and Id not in (select typeQ from @question_t)) q)!=0
 begin
  insert into @question_t
 select Id from [CRM_1551_Analitics].[dbo].[QuestionTypes]
 where [question_type_id] in (select typeQ from @question_t)
 and Id not in (select typeQ from @question_t)
 end 
end
--- Для поиска QuestionTypes по группе
if @questionGroup = 0
begin  
 insert into @question_g (typeG)
 SELECT [Id] from QuestionTypes
 end
 else 
 begin

 -- НАХОДИМ ИД QuestionTypes которые входят в выбранную QuestionGroups
 insert into @question_g(typeG)
 select qt.Id from QuestionTypes qt 
 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
      where qg.report_code = 'Analitica_spheres'  
	  and qg.Id = @questionGroup        
 end


select TOP 10 ROW_NUMBER() OVER(ORDER BY x.questionType DESC) as Id, *,
sum(x.Golosiivsky + x.Darnitsky + x.Desnyansky + x.Dnirovsky + x.Obolonsky +
    x.Pechersky + x.Podilsky + x.Svyatoshinsky + x.Solomiansky + x.Shevchenkovsky) as allQuestionsQty
	from (
select 
 PivotTable.questionType as questionType,
 isnull(PivotTable.[Голосіївський],0) as Golosiivsky,
 isnull(PivotTable.[Дарницький],0) as Darnitsky,
 isnull(PivotTable.[Деснянський],0) as Desnyansky,
 isnull(PivotTable.[Дніпровський],0) as Dnirovsky,
 isnull(PivotTable.[Оболонський],0) as Obolonsky,
 isnull(PivotTable.[Печерський],0) as Pechersky,
 isnull(PivotTable.[Подільський],0) as Podilsky,
 isnull(PivotTable.[Святошинський],0) as Svyatoshinsky,
 isnull(PivotTable.[Солом`янський],0) as Solomiansky,
 isnull(PivotTable.[Шевченківський],0) as Shevchenkovsky
 from (SELECT 
  qt.[name] AS questionType, d.[name] as district, isnull(count(q.Id),0) as questionQty
FROM Questions q 
left join QuestionTypes qt on qt.Id = q.question_type_id
			left join [Objects] o on o.Id = q.[object_id]
			left join [Buildings] b on b.Id = o.builbing_id
			left join [Districts] d on d.Id = b.district_id
			left join [QGroupIncludeQTypes] qgiqt on qgiqt.type_question_id = qt.Id
			left join [QuestionGroups] qg on qg.Id = qgiqt.group_question_id
  where q.registration_date between @filterFrom and @filterTo
  and qt.Id in (select typeQ from @question_t) 
  and qt.Id in (select typeG from @question_g) 
  and qg.report_code = 'Analitica_spheres'
 
  group by qt.[name], d.[name]
 ) as q_tab

PIVOT  
(  
SUM(questionQty)  
FOR district IN ([Голосіївський], [Дарницький], [Деснянський], 
                 [Дніпровський], [Оболонський], [Печерський], 
				 [Подільський], [Святошинський], 
			     [Солом`янський], [Шевченківський])  
) AS PivotTable 
							  ) x group by x.questionType, x.Darnitsky,x.Desnyansky,x.Dnirovsky,x.Golosiivsky,x.Obolonsky,x.Pechersky,
							               x.Podilsky, x.Shevchenkovsky, x.Solomiansky, x.Svyatoshinsky
										   order by allQuestionsQty desc