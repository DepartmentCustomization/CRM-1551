	
-- declare  @DateCalc date = N'2019-11-01' 
-- ,@RatingId int = 1
-- ,@RDAId int = 2000	

if isnull(@RDAId,0) = 0
begin 
	--IndexOfSpeedToExecution_QType
	if object_id('tempdb..#temp_IndexOfSpeedToExecution_QType_All') is not null drop table #temp_IndexOfSpeedToExecution_QType_All
	SELECT	 [id] as [QuestionTypeId],
			 [name] as [QuestionTypeName]
	into #temp_IndexOfSpeedToExecution_QType_All
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


	
	--IndexOfSpeedToExecution_Place_All
	if object_id('tempdb..#temp_IndexOfSpeedToExecution_Place_All') is not null drop table #temp_IndexOfSpeedToExecution_Place_All
	SELECT	 [id] as [QuestionTypeId],
			 --[name] as [QuestionTypeName],
			 [2000],[2001],[2002],[2003],[2004],[2005],[2006],[2007],[2008],[2009]
	into #temp_IndexOfSpeedToExecution_Place_All
			 FROM ( select * from (
				 select  t0.id,
						t0.name,
						t1.RDAId,
						t1.[AvgPlace]
				from [CRM_1551_Analitics].[dbo].[QuestionTypes] as t0
				left join (
							SELECT [QuestionTypeId],
								   [RDAId],
								   avg(Execution_Place) as [AvgPlace]
							  FROM [CRM_1551_Rating].[dbo].[Rating_DaysToExecution]
							  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].Id = [Rating_DaysToExecution].[QuestionTypeId]
							  where [RDAId] is not null
							  and [RatingId] = @RatingId
							  and [DateCalc] = @DateCalc
							group by [QuestionTypeId],[RDAId]
						) as t1 on t1.QuestionTypeId = t0.Id
	) as Table123) x
			 PIVOT
			 (min([AvgPlace])
			 FOR RDAId
			 IN([2000],[2001],[2002],[2003],[2004],[2005],[2006],[2007],[2008],[2009])
	 ) pvt
	 where isnull(pvt.[2000],0)+isnull(pvt.[2001],0)+isnull(pvt.[2002],0)+isnull(pvt.[2003],0)+isnull(pvt.[2004],0)+isnull(pvt.[2005],0)+isnull(pvt.[2006],0)+isnull(pvt.[2007],0)+isnull(pvt.[2008],0)+isnull(pvt.[2009],0) > 0
	


	--IndexOfSpeedToExecution_Percent
		if object_id('tempdb..#temp_IndexOfSpeedToExecution_Percent_All') is not null drop table #temp_IndexOfSpeedToExecution_Percent_All
		SELECT	 [id] as [QuestionTypeId],
			 --[name] as [QuestionTypeName],
			 [2000],[2001],[2002],[2003],[2004],[2005],[2006],[2007],[2008],[2009]
			 into #temp_IndexOfSpeedToExecution_Percent_All
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
		
		
		
	
	 select 
	 t0.QuestionTypeId, 
	 t0.QuestionTypeName, 
	 t1.EtalonDaysToExecution as [EtalonDays],
	 t_Percent.[2000] as [Percent_2000],
	 t_Percent.[2001] as [Percent_2001],
	 t_Percent.[2002] as [Percent_2002],
	 t_Percent.[2003] as [Percent_2003],
	 t_Percent.[2004] as [Percent_2004],
	 t_Percent.[2005] as [Percent_2005],
	 t_Percent.[2006] as [Percent_2006],
	 t_Percent.[2007] as [Percent_2007],
	 t_Percent.[2008] as [Percent_2008],
	 t_Percent.[2009] as [Percent_2009],

	 t_Place.[2000] as [Place_2000],
	 t_Place.[2001] as [Place_2001],
	 t_Place.[2002] as [Place_2002],
	 t_Place.[2003] as [Place_2003],
	 t_Place.[2004] as [Place_2004],
	 t_Place.[2005] as [Place_2005],
	 t_Place.[2006] as [Place_2006],
	 t_Place.[2007] as [Place_2007],
	 t_Place.[2008] as [Place_2008],
	 t_Place.[2009] as [Place_2009]
	 from #temp_IndexOfSpeedToExecution_QType_All as t0
	 left join #temp_IndexOfSpeedToExecution_Place_All as t_Place on t_Place.QuestionTypeId = t0.QuestionTypeId
	 left join #temp_IndexOfSpeedToExecution_Percent_All as t_Percent on t_Percent.QuestionTypeId = t0.QuestionTypeId
	 left join [CRM_1551_Rating].[dbo].[Rating_EtalonDaysToExecution] as t1 on t1.QuestionTypeId = t0.QuestionTypeId
																		and t1.Id in (select max(Id) 
																						from [CRM_1551_Rating].[dbo].[Rating_EtalonDaysToExecution]
																						where DateStart <= @DateCalc
																						group by QuestionTypeId)

end
else 
begin
	declare @sql nvarchar(max)  = N'	
			/*if object_id(''tempdb..##temp_IndexOfSpeedToExecution'') is not null drop table ##temp_IndexOfSpeedToExecution*/
			select  t_Percent.QuestionTypeId,
			t_Percent.QuestionTypeName,
			t1.EtalonDaysToExecution as [EtalonDays],
			t_Percent.[Value] as [Percent_'+rtrim(@RDAId)+'],
			t_Place.[Value] as [Place_'+rtrim(@RDAId)+']
			/*into ##temp_IndexOfSpeedToExecution*/
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
										  and [RatingId] = '+rtrim(@RatingId)+'
										  and [DateCalc] = '''+rtrim(CONVERT(nvarchar, @DateCalc, 23))+'''
										  and RDAId = '+rtrim(@RDAId)+'
										group by [QuestionTypeId]
									) as t1 on t1.QuestionTypeId = t0.Id
							where t1.[AvgDays] is not null
				) as t_Percent

				left join 
				(
							 select  t0.id as QuestionTypeId,
									t1.[AvgDays] as [Value]
							from [CRM_1551_Analitics].[dbo].[QuestionTypes] as t0
							left join (
										SELECT [QuestionTypeId],
											   avg(Execution_Place) as [AvgDays]
										  FROM [CRM_1551_Rating].[dbo].[Rating_DaysToExecution]
										  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].Id = [Rating_DaysToExecution].[QuestionTypeId]
										  where [RDAId] is not null
										  and [RatingId] = '+rtrim(@RatingId)+'
										  and [DateCalc] = '''+rtrim(CONVERT(nvarchar, @DateCalc, 23))+'''
										  and RDAId = '+rtrim(@RDAId)+'
										group by [QuestionTypeId]
									) as t1 on t1.QuestionTypeId = t0.Id
							where t1.[AvgDays] is not null
				) as t_Place on t_Place.QuestionTypeId = t_Percent.QuestionTypeId
				left join [CRM_1551_Rating].[dbo].[Rating_EtalonDaysToExecution] as t1 on t1.QuestionTypeId = t_Place.QuestionTypeId
	'
	exec sp_executesql @sql
	/*
	select *	
	from ##temp_IndexOfSpeedToExecution*/
end


