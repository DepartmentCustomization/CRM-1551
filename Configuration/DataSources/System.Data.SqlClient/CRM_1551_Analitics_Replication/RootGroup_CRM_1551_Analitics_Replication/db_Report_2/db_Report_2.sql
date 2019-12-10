declare @question_t table (typeQ int)
declare @question_g table (typeG int)

--  declare @questionType int = 2;
--  declare @questionGroup int = 11;
--  declare @dateFrom date = '2019-01-01';
--  declare @dateTo date = cast(current_timestamp as date);

if @questionType = 0
begin  
 insert into @question_t (typeQ)
 SELECT [Id] from QuestionTypes
 end
 else 
 begin 
 declare @question_type_id int =@questionType;
--declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
--[QuestionTypes].question_type_id

 declare @QuestionTypes table(Id int);
 declare @QuestionTypesId int = @question_type_id;
 declare @IdT table (Id int);

 -- НАХОДИМ ИД QuestionTypes ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
 insert into @IdT(Id)
 select Id from [CRM_1551_Analitics].[dbo].[QuestionTypes] 
 where (Id=@QuestionTypesId or [question_type_id]=@QuestionTypesId) and Id not in (select Id from @IdT)

 --  НАХОДИМ ПАРЕНТЫ QuestionTypes, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
 while (select count(id) from (select Id from [CRM_1551_Analitics].[dbo].[QuestionTypes]
 where [question_type_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
 and Id not in (select Id from @IdT)) q)!=0
 begin

 insert into @IdT
 select Id from [CRM_1551_Analitics].[dbo].[QuestionTypes]
 where [question_type_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
 and Id not in (select Id from @IdT)
 end 

 insert into @QuestionTypes (Id)
 select Id from @IdT;

 insert into @question_t (typeQ)
 select Id
 from @QuestionTypes
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
 select distinct qt.Id from QuestionTypes qt 
 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
      where qg.report_code = 'Analitica_spheres'  
	  and qg.Id = @questionGroup        
 end
--  select * from @question_g
select ROW_NUMBER() OVER(ORDER BY z.questionQty DESC) Id, *
from (
SELECT distinct 
  --ROW_NUMBER() OVER(ORDER BY qty.questionQ DESC) Id,
  qt.[name] AS questionType, isnull(qty.questionQ,0) as questionQty
FROM QuestionTypes qt 
			left join [QGroupIncludeQTypes] qgiqt on qgiqt.type_question_id = qt.Id
			left join [QuestionGroups] qg on qg.Id = qgiqt.group_question_id
left join (select COUNT(q.Id) as questionQ, 
              question_type_id as typeId
            FROM [dbo].[Questions] q (nolock)			
            LEFT JOIN [dbo].[Assignments] a (nolock) ON q.last_assignment_for_execution_id = a.id
			where q.registration_date between @dateFrom and dateadd(day, 1, @dateTo)	
			group by q.question_type_id ) qty on qty.typeId = qt.Id
 			where (qt.Id in (select typeQ from @question_t)
			or qt.Id in (select Id from QuestionTypes 
			             where question_type_id in 
				(select typeQ from @question_t) ) )
			and qt.Id in (select typeG from @question_g) 
			) z