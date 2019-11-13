if object_id('tempdb..#temp_OUT') is not null drop table #temp_OUT
create table #temp_OUT(
GroupQuestionId    int,
QuestionTypeName  nvarchar(200),
QuestionTypeId     int
)
--declare @typeId int = 3;
--declare @dateFrom datetime = '2019-01-01 00:00:00';
--declare @dateTo datetime = current_timestamp;

DECLARE @QuestionRowId INT
DECLARE @CURSOR CURSOR
SET @CURSOR  = CURSOR SCROLL
FOR
  select Id from [dbo].[QuestionTypes] where question_type_id = @typeId
OPEN @CURSOR
FETCH NEXT FROM @CURSOR INTO @QuestionRowId
WHILE @@FETCH_STATUS = 0
BEGIN

		;WITH  QuestionTypesH (ParentId, Id, [Name], level, Label) AS
		  (
		      SELECT question_type_id as ParentId, Id, name as [Name], 0, 
			  CAST(rtrim(Id)+ '/' AS NVARCHAR(MAX)) As Label
		      FROM [dbo].[QuestionTypes]
		      WHERE Id = @QuestionRowId
		      UNION ALL
		    SELECT o.question_type_id as ParentId, o.Id, o.name as [Name], level + 1,
			  CAST(rtrim(h.Label)  + rtrim(o.Id) + '/' AS NVARCHAR(MAX)) As Label
		      FROM [dbo].[QuestionTypes]  o 
		      JOIN QuestionTypesH h ON o.question_type_id = h.Id
		  )
		  insert into #temp_OUT (GroupQuestionId, QuestionTypeId, QuestionTypeName)
		  SELECT @QuestionRowId, Id, Name
		  FROM QuestionTypesH

FETCH NEXT FROM @CURSOR INTO @QuestionRowId
END
CLOSE @CURSOR

  select top 10 QuestionTypeId as Id,
   case when QuestionTypeId is not null then 
   (select name from QuestionTypes where Id = QuestionTypeId) else '' end
   as qName, isnull(sum(val),0) qty
  from #temp_OUT o
  left join (select count(q.Id) val, qt.Id 
             from Questions q
			 JOIN QuestionTypes qt ON q.question_type_id = qt.Id
			 where q.registration_date between @dateFrom and @dateTo
			 group by qt.Id  
			 ) z on z.Id = o.QuestionTypeId		 
			 group by o.QuestionTypeId
			 order by qty desc