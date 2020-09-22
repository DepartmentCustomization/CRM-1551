   --DECLARE @dateFrom DATE='2018-01-01';
   --DECLARE @dateTo DATE='2020-12-12';

--  DECLARE @date DATE = --GETUTCDATE();--CONVERT(DATE,'2019-09-25 17:37:06.090');
----DECLARE @date DATE = CONVERT(DATE,'2019-09-25 17:37:06.090');
--  (SELECT TOP 1 [DateStart]
--  FROM (
--  select DISTINCT [DateStart], DATEDIFF(DAY,[DateStart],CONVERT(DATE,GETUTCDATE())) diff, ABS(DATEDIFF(DAY,[DateStart],CONVERT(DATE,GETUTCDATE()))) abs_diff
--  from [dbo].[Rating_EtalonDaysToExecution] with (nolock)
--  --order by ABS(DATEDIFF(DAY,[DateStart],CONVERT(DATE,GETUTCDATE()))), DATEDIFF(DAY,[DateStart],CONVERT(DATE,GETUTCDATE())) DESC
--  ) t
--  order by abs_diff, diff DESC)

  --типы вопросов и даты, которые отображать начало
  IF OBJECT_ID('tempdb..#temp_Rating_EtalonDaysToExecution') IS NOT NULL	DROP TABLE #temp_Rating_EtalonDaysToExecution;

  select r.[Id], [QuestionTypeId], [DateStart], [EtalonDaysToExecution], [EtalonDaysToExplain]
  into #temp_Rating_EtalonDaysToExecution
  from [dbo].[Rating_EtalonDaysToExecution] r with (nolock)
  inner join
  (
  select [Id]
  
  ,row_number() over (partition by [QuestionTypeId] order by ABS(DATEDIFF(DAY,[DateStart],CONVERT(DATE,GETUTCDATE()))), DATEDIFF(DAY,[DateStart],CONVERT(DATE,GETUTCDATE()))) n
  from [dbo].[Rating_EtalonDaysToExecution] with (nolock)) t on r.Id=t.Id and t.n=1

  --типы вопросов и даты, которые отображать конец


  --знаходимо всі РДА та їх підлеглих начало
  IF OBJECT_ID('tempdb..#temp_RDAorg') IS NOT NULL	DROP TABLE #temp_RDAorg;
  ;with
it as --дети @id
(select [Id], [parent_organization_id] ParentId
from [CRM_1551_Analitics].[dbo].[Organizations] with (nolock)
where [organization_type_id]=5 /*Районні державні адміністрації*/
union all
select t.Id, [parent_organization_id] ParentId
from [CRM_1551_Analitics].[dbo].[Organizations] t with (nolock) inner join it on t.[parent_organization_id]=it.Id)

select Id into #temp_RDAorg from it-- pit it
  --знаходимо всі РДА та їх підлеглих конец

  create index i1 ON #temp_RDAorg (Id)
  --select * from #temp_RDAorg



  /*Стан - На перевірці, результат - Виконано. K 3*/

  IF OBJECT_ID('tempdb..#temp_column3') IS NOT NULL	DROP TABLE #temp_column3;


  select [Questions].question_type_id, convert(numeric(8,2), avg(convert(float,datediff(MINUTE, [Assignments].registration_date, l.Log_Date)/3600.00))) count_day
  into #temp_column3
  from [CRM_1551_Analitics].[dbo].[Assignments] with (nolock)

  INNER JOIN #temp_RDAorg temp_RDAorg ON [Assignments].executor_organization_id=temp_RDAorg.Id

  INNER JOIN

  (select [assignment_id], MIN([Log_Date]) [Log_Date]
  from [CRM_1551_Analitics].[dbo].[Assignment_History] with (nolock)
  where [assignment_state_id]=3 /*На перевірці*/ and [AssignmentResultsId]=4 /*Виконано*/
  and registration_date between @dateFrom and @dateTo
  group by [assignment_id]) l 
  
  on [Assignments].Id=l.[assignment_id]
  INNER JOIN [CRM_1551_Analitics].[dbo].[Questions] with (nolock) ON [Assignments].question_id=[Questions].Id
  where [Assignments].main_executor='true'
  group by [Questions].question_type_id


  create index i1 ON #temp_column3 (question_type_id)
  --select * from #temp_column3


  /*Стан - На перевірці, результат - Роз'яснено K6*/
  IF OBJECT_ID('tempdb..#temp_column6') IS NOT NULL	DROP TABLE #temp_column6;


  select [Questions].question_type_id, convert(numeric(8,2), avg(convert(float,datediff(MINUTE, [Assignments].registration_date, l.Log_Date)/3600.00))) count_day
  into #temp_column6
  from [CRM_1551_Analitics].[dbo].[Assignments] with (nolock)

  INNER JOIN #temp_RDAorg temp_RDAorg ON [Assignments].executor_organization_id=temp_RDAorg.Id

  INNER JOIN

  (select [assignment_id], MIN([Log_Date]) [Log_Date]
  from [CRM_1551_Analitics].[dbo].[Assignment_History] with (nolock)
  where [assignment_state_id]=3 /*На перевірці*/ and [AssignmentResultsId]=7 /*Роз`яснено*/
  and registration_date between @dateFrom and @dateTo
  group by [assignment_id]) l 
  
  on [Assignments].Id=l.[assignment_id]
  INNER JOIN [CRM_1551_Analitics].[dbo].[Questions] with (nolock) ON [Assignments].question_id=[Questions].Id
  where [Assignments].main_executor='true'
  group by [Questions].question_type_id

 -- select * from #temp_column6
 create index i1 ON #temp_column6 (question_type_id)



  --where [assignment_state_id]=3 /*На перевірці*/ and [AssignmentResultsId]=7 /*Роз`яснено*/

  SELECT [QuestionTypes].Id,
  [QuestionTypes].Id QuestionTypes_Id, 
  [QuestionTypes].name QuestionTypes_Name, --1
  [Rating_EtalonDaysToExecution].EtalonDaysToExecution, --2
  --CONVERT(NUMERIC(8,2),avg_EtalonDaysToExecution.avg_EtalonDaysToExecution) avg_EtalonDaysToExecution, --3
  temp_column3.count_day avg_EtalonDaysToExecution, --3
  --CONVERT(NUMERIC(8,2),avg_EtalonDaysToExecution.avg_EtalonDaysToExecution) avg_EtalonDaysToExecution_change, --4 МОЖЛИВІСТЬ ЗМІНИ
  temp_column3.count_day avg_EtalonDaysToExecution_change, --4 МОЖЛИВІСТЬ ЗМІНИ,
  [Rating_EtalonDaysToExecution].[EtalonDaysToExplain], --5
  --CONVERT(NUMERIC(8,2),avg_EtalonDaysToExplain.avg_EtalonDaysToExplain) avg_EtalonDaysToExplain, --6
  temp_column6.count_day avg_EtalonDaysToExplain, --6
  --CONVERT(NUMERIC(8,2),avg_EtalonDaysToExplain.avg_EtalonDaysToExplain) avg_EtalonDaysToExplain_change, --7 МОЖЛИВІСТЬ ЗМІНИ
  temp_column6.count_day avg_EtalonDaysToExplain_change, --7 МОЖЛИВІСТЬ ЗМІНИ
  [Rating_EtalonDaysToExecution].DateStart --8
  FROM --[dbo].[Rating_EtalonDaysToExecution] with (nolock)
  #temp_Rating_EtalonDaysToExecution [Rating_EtalonDaysToExecution]
  INNER JOIN [CRM_1551_Analitics].[dbo].[QuestionTypes] with (nolock) ON [Rating_EtalonDaysToExecution].QuestionTypeId=[QuestionTypes].Id


  --LEFT JOIN 
  --(SELECT QuestionTypeId, AVG(CONVERT(FLOAT,EtalonDaysToExecution)) avg_EtalonDaysToExecution
  --FROM [dbo].[Rating_EtalonDaysToExecution]
  --WHERE EtalonDaysToExecution IS NOT NULL AND [Rating_EtalonDaysToExecution].[DateStart] 
  --BETWEEN CONVERT(DATE,@dateFrom) AND CONVERT(DATE,@dateTo)
  --GROUP BY QuestionTypeId) avg_EtalonDaysToExecution ON [Rating_EtalonDaysToExecution].QuestionTypeId=avg_EtalonDaysToExecution.QuestionTypeId

  LEFT JOIN 
  (SELECT QuestionTypeId, AVG(CONVERT(FLOAT,EtalonDaysToExplain)) avg_EtalonDaysToExplain
  FROM [dbo].[Rating_EtalonDaysToExecution] with (nolock)
  WHERE EtalonDaysToExplain IS NOT NULL AND [Rating_EtalonDaysToExecution].[DateStart] 
  BETWEEN CONVERT(DATE,@dateFrom) AND CONVERT(DATE,@dateTo)
  GROUP BY QuestionTypeId) avg_EtalonDaysToExplain ON [Rating_EtalonDaysToExecution].QuestionTypeId=avg_EtalonDaysToExplain.QuestionTypeId

  LEFT JOIN #temp_column3 temp_column3 ON [Rating_EtalonDaysToExecution].QuestionTypeId=temp_column3.question_type_id
  LEFT JOIN #temp_column6 temp_column6 ON [Rating_EtalonDaysToExecution].QuestionTypeId=temp_column6.question_type_id

  --WHERE CONVERT(DATE, [Rating_EtalonDaysToExecution].[DateStart])=@date

   WHERE #filter_columns#
   order by 1 --#sort_columns#
   offset @pageOffsetRows rows fetch next @pageLimitRows rows only
