
-- declare  @DateCalc date = N'2019-11-01' 
-- ,@RatingId int = 1
-- ,@RDAId int = 2000


if isnull(@RDAId,0) = 0
begin 
	if object_id('tempdb..#temp_RatingResultData2') is not null drop table #temp_RatingResultData2

	SELECT	 [id] as [QuestionTypeId],
			 [name] as [QuestionTypeName]
	into #temp_RatingResultData2
			 FROM ( select * from (
				 select  t0.id,
						t0.name,
						t1.RDAId,
						t1.[AvgDays]
				from [CRM_1551_Analitics].[dbo].[QuestionTypes] as t0
				left join (
							SELECT [QuestionTypeId],
								   [RDAId],
								   case when sum([Execution_CountAssignments]) = 0 then NULL else sum(cast([Execution_SumDays] as numeric(18,6)))/sum(cast([Execution_CountAssignments] as numeric(18,6))) end as [AvgDays]
							  FROM [CRM_1551_Rating].[dbo].[Rating_DaysToExecution]
							  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].Id = [Rating_DaysToExecution].[QuestionTypeId]
							  where [RDAId] is not null
							  and [RatingId] = @RatingId
							  and [DateCalc] = @DateCalc
							group by [QuestionTypeId],[RDAId]
						) as t1 on t1.QuestionTypeId = t0.Id
	) as Table123) x
			 PIVOT
			 (min([AvgDays])
			 FOR RDAId
			 IN([2000],[2001],[2002],[2003],[2004],[2005],[2006],[2007],[2008],[2009])
	 ) pvt
	 where isnull(pvt.[2000],0)+isnull(pvt.[2001],0)+isnull(pvt.[2002],0)+isnull(pvt.[2003],0)+isnull(pvt.[2004],0)+isnull(pvt.[2005],0)+isnull(pvt.[2006],0)+isnull(pvt.[2007],0)+isnull(pvt.[2008],0)+isnull(pvt.[2009],0) > 0
	 order by Id

	 select t0.QuestionTypeId, t0.QuestionTypeName, t1.EtalonDaysToExecution as [EtalonDays]
	 from #temp_RatingResultData2 as t0
	 left join [CRM_1551_Rating].[dbo].[Rating_EtalonDaysToExecution] as t1 on t1.QuestionTypeId = t0.QuestionTypeId
																		and t1.Id in (select max(Id) 
																						from [CRM_1551_Rating].[dbo].[Rating_EtalonDaysToExecution]
																						where DateStart <= @DateCalc
																						group by QuestionTypeId)
end
else 
begin
	if object_id('tempdb..##temp_RatingResultData') is not null drop table ##temp_RatingResultData

	declare @Col nvarchar(10) = rtrim(@RDAId)
	select * 
	into ##temp_RatingResultData
	from (
				 select  t0.id as QuestionTypeId,
						t0.name as QuestionTypeName,
						t1.[AvgDays] as [Value]
				from [CRM_1551_Analitics].[dbo].[QuestionTypes] as t0
				left join (
							SELECT [QuestionTypeId],
								   case when sum([Execution_CountAssignments]) = 0 then NULL else sum(cast([Execution_SumDays] as numeric(18,6)))/sum(cast([Execution_CountAssignments] as numeric(18,6))) end as [AvgDays]
							  FROM [CRM_1551_Rating].[dbo].[Rating_DaysToExecution]
							  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].Id = [Rating_DaysToExecution].[QuestionTypeId]
							  where [RDAId] is not null
							  and [RatingId] = @RatingId
							  and [DateCalc] = @DateCalc
							  and RDAId = @RDAId
							group by [QuestionTypeId]
						) as t1 on t1.QuestionTypeId = t0.Id
				where t1.[AvgDays] is not null
	) as Table123

	
	select t0.QuestionTypeId, t0.QuestionTypeName, t1.EtalonDaysToExecution as [EtalonDays]
	from ##temp_RatingResultData as t0
	left join [CRM_1551_Rating].[dbo].[Rating_EtalonDaysToExecution] as t1 on t1.QuestionTypeId = t0.QuestionTypeId 
																		and t1.Id in (select max(Id) 
																						from [CRM_1551_Rating].[dbo].[Rating_EtalonDaysToExecution]
																						where DateStart <= @DateCalc
																						group by QuestionTypeId)
	order by t0.QuestionTypeId
end

