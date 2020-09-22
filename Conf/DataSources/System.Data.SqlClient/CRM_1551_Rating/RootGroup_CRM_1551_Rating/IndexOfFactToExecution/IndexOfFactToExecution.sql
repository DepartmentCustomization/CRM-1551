
--  declare  @DateCalc date = N'2019-11-01' 
--  ,@RatingId int = 1
--  ,@RDAId int


if object_id('tempdb..##temp_RatingPlace') is not null drop table ##temp_RatingPlace
create table ##temp_RatingPlace(
Id int identity(1,1),
RDAId int, 
RatingId int,
QuestionTypeId int,
Inticator_Fact numeric(18,6),
Inticator_Plan numeric(18,6),
Inticator_Place int
)


if object_id('tempdb..#temp_RatingPlace_TEMP') is not null drop table #temp_RatingPlace_TEMP
create table #temp_RatingPlace_TEMP(
IdRow int,
PlaceRating int)

if object_id('tempdb..#temp_RatingPlace_Result') is not null drop table #temp_RatingPlace_Result
create table #temp_RatingPlace_Result(
Id int identity(1,1),
RDAId int, 
RatingId int,
AvgPlaceRating numeric(18,6))

/*Індекс фактичного виконання*/

if object_id('tempdb..#temp_Indicator6_1') is not null drop table #temp_Indicator6_1
create table #temp_Indicator6_1(
Id int identity(1,1),
RDAId int, 
RatingId int,
QuestionTypeId int,
ResultValue numeric(18,6),
IndicatorPlace int
)

insert into #temp_Indicator6_1 (RDAId, RatingId, QuestionTypeId, ResultValue)
select t2.RDAId,
		t2.RatingId,
		t2.QuestionTypeId,
case  when sum(isnull(t2.Indicator2,0))= 0 then NULL else cast(sum(isnull(t2.Indicator1,0) ) as numeric(18,6)) / cast(sum(isnull(t2.Indicator2,0)) as numeric(18,6)) * 100 end 
from [dbo].[Rating_IndexToFactExecution] as t2 
where t2.DateCalc = @DateCalc
group by t2.RDAId,
		t2.RatingId,
		t2.QuestionTypeId



-----------------------------
delete from ##temp_RatingPlace
		delete from #temp_RatingPlace_TEMP
		delete from #temp_RatingPlace_Result
		
		insert into ##temp_RatingPlace (RDAId, RatingId, QuestionTypeId, Inticator_Fact)
		select  RDAId, RatingId, QuestionTypeId, ResultValue
		from #temp_Indicator6_1 where RDAId is not null and RatingId is not null and QuestionTypeId is not null
		
		delete from ##temp_RatingPlace where Inticator_Fact is null
		
		insert into #temp_RatingPlace_TEMP (IdRow, PlaceRating)
		select Id, case when RANK() OVER(PARTITION BY QuestionTypeId, RatingId ORDER BY Inticator_Fact desc) = 1 then 1
						when RANK() OVER(PARTITION BY QuestionTypeId, RatingId ORDER BY Inticator_Fact desc) = 2 then 2
						when RANK() OVER(PARTITION BY QuestionTypeId, RatingId ORDER BY Inticator_Fact desc) = 3 then 3
						when RANK() OVER(PARTITION BY QuestionTypeId, RatingId ORDER BY Inticator_Fact desc) = 4 then 4
						when RANK() OVER(PARTITION BY QuestionTypeId, RatingId ORDER BY Inticator_Fact desc) = 5 then 5
						when RANK() OVER(PARTITION BY QuestionTypeId, RatingId ORDER BY Inticator_Fact desc) = 6 then 6
						when RANK() OVER(PARTITION BY QuestionTypeId, RatingId ORDER BY Inticator_Fact desc) = 7 then 7
						when RANK() OVER(PARTITION BY QuestionTypeId, RatingId ORDER BY Inticator_Fact desc) = 8 then 8
						when RANK() OVER(PARTITION BY QuestionTypeId, RatingId ORDER BY Inticator_Fact desc) = 9 then 9
						when RANK() OVER(PARTITION BY QuestionTypeId, RatingId ORDER BY Inticator_Fact desc) = 10 then 10
				end
		from ##temp_RatingPlace
		where Inticator_Place is null
		
		update ##temp_RatingPlace set Inticator_Place = #temp_RatingPlace_TEMP.PlaceRating
		from ##temp_RatingPlace
		inner join #temp_RatingPlace_TEMP on #temp_RatingPlace_TEMP.IdRow = ##temp_RatingPlace.Id
		
		insert into #temp_RatingPlace_Result (RDAId, RatingId, AvgPlaceRating)
		select RDAId, RatingId, Avg(cast(Inticator_Place as numeric(18,6))) as Inticator_Place 
		from ##temp_RatingPlace
		group by RDAId, RatingId
		order by RatingId, RDAId



-- update [dbo].[Rating_IndexToFactExecution] set IndicatorPlace = t2.Inticator_Place
-- 	from [dbo].[Rating_IndexToFactExecution] 
-- 	inner join ##temp_RatingPlace as t2 on t2.RatingId = [Rating_IndexToFactExecution].RatingId
-- 										and t2.QuestionTypeId = [Rating_IndexToFactExecution].QuestionTypeId
-- 										and t2.RDAId = [Rating_IndexToFactExecution].RDAId
-- 	where [Rating_IndexToFactExecution].DateCalc = @DateCalc





delete from ##temp_RatingPlace where RatingId != @RatingId


if isnull(@RDAId,0) = 0
begin 
	select  t_Percent.QuestionTypeId, 
	 t_Percent.QuestionTypeName, 
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
	from (
			SELECT	 [id] as [QuestionTypeId],
					 [name] as [QuestionTypeName],
					 [2000],[2001],[2002],[2003],[2004],[2005],[2006],[2007],[2008],[2009]
					 FROM ( select * from (
						 select  t0.id,
								t0.name,
								t1.RDAId,
								t1.AvgPlace
						from [CRM_1551_Analitics].[dbo].[QuestionTypes] as t0
						left join (
									SELECT [QuestionTypeId],
										   [RDAId],
										   min(##temp_RatingPlace.Inticator_Fact) as [AvgPlace]
									  FROM ##temp_RatingPlace
									  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].Id = ##temp_RatingPlace.[QuestionTypeId]
									  where [RDAId] is not null
									group by [QuestionTypeId],[RDAId]
								) as t1 on t1.QuestionTypeId = t0.Id
			) as Table123) x
					 PIVOT
					 (MIN(AvgPlace)
					 FOR RDAId
					 IN([2000],[2001],[2002],[2003],[2004],[2005],[2006],[2007],[2008],[2009])
			 ) pvt
			 where isnull(pvt.[2000],0)+isnull(pvt.[2001],0)+isnull(pvt.[2002],0)+isnull(pvt.[2003],0)+isnull(pvt.[2004],0)+isnull(pvt.[2005],0)+isnull(pvt.[2006],0)+isnull(pvt.[2007],0)+isnull(pvt.[2008],0)+isnull(pvt.[2009],0) > 0
	 ) as t_Percent
	 left join 
	 (
		SELECT	 [id] as [QuestionTypeId],
				 --[name] as [QuestionTypeName],
				 [2000],[2001],[2002],[2003],[2004],[2005],[2006],[2007],[2008],[2009]
				 FROM ( select * from (
					 select  t0.id,
							t0.name,
							t1.RDAId,
							t1.AvgPlace
					from [CRM_1551_Analitics].[dbo].[QuestionTypes] as t0
					left join (
								SELECT [QuestionTypeId],
									   [RDAId],
									   min(##temp_RatingPlace.Inticator_Place) as [AvgPlace]
								  FROM ##temp_RatingPlace
								  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].Id = ##temp_RatingPlace.[QuestionTypeId]
								  where [RDAId] is not null
								group by [QuestionTypeId],[RDAId]
							) as t1 on t1.QuestionTypeId = t0.Id
			)	 as Table123) x
				 PIVOT
				 (MIN(AvgPlace)
				 FOR RDAId
				 IN([2000],[2001],[2002],[2003],[2004],[2005],[2006],[2007],[2008],[2009])
		) pvt
		where isnull(pvt.[2000],0)+isnull(pvt.[2001],0)+isnull(pvt.[2002],0)+isnull(pvt.[2003],0)+isnull(pvt.[2004],0)+isnull(pvt.[2005],0)+isnull(pvt.[2006],0)+isnull(pvt.[2007],0)+isnull(pvt.[2008],0)+isnull(pvt.[2009],0) > 0
	 ) as t_Place on t_Place.QuestionTypeId = t_Percent.[QuestionTypeId]


end
else 
begin

	declare @sql nvarchar(max)  = N'	
select  t_Percent.QuestionTypeId, 
	 t_Percent.QuestionTypeName, 
	 t_Percent.['+rtrim(@RDAId)+'] as [Percent_'+rtrim(@RDAId)+'],
	 t_Place.['+rtrim(@RDAId)+'] as [Place_'+rtrim(@RDAId)+'] 
	from (
			SELECT	 [id] as [QuestionTypeId],
					 [name] as [QuestionTypeName],
					 ['+rtrim(@RDAId)+']
					 FROM ( select * from (
						 select  t0.id,
								t0.name,
								t1.RDAId,
								t1.AvgPlace
						from [CRM_1551_Analitics].[dbo].[QuestionTypes] as t0
						left join (
									SELECT [QuestionTypeId],
										   [RDAId],
										   min(##temp_RatingPlace.Inticator_Fact) as [AvgPlace]
									  FROM ##temp_RatingPlace
									  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].Id = ##temp_RatingPlace.[QuestionTypeId]
									  where [RDAId] is not null
									group by [QuestionTypeId],[RDAId]
								) as t1 on t1.QuestionTypeId = t0.Id
			) as Table123) x
					 PIVOT
					 (MIN(AvgPlace)
					 FOR RDAId
					 IN(['+rtrim(@RDAId)+'])
			 ) pvt
			 where isnull(pvt.['+rtrim(@RDAId)+'],0) > 0
	 ) as t_Percent
	 left join 
	 (
		SELECT	 [id] as [QuestionTypeId],
				 --[name] as [QuestionTypeName],
				 ['+rtrim(@RDAId)+']
				 FROM ( select * from (
					 select  t0.id,
							t0.name,
							t1.RDAId,
							t1.AvgPlace
					from [CRM_1551_Analitics].[dbo].[QuestionTypes] as t0
					left join (
								SELECT [QuestionTypeId],
									   [RDAId],
									   min(##temp_RatingPlace.Inticator_Place) as [AvgPlace]
								  FROM ##temp_RatingPlace
								  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].Id = ##temp_RatingPlace.[QuestionTypeId]
								  where [RDAId] is not null
								group by [QuestionTypeId],[RDAId]
							) as t1 on t1.QuestionTypeId = t0.Id
			)	 as Table123) x
				 PIVOT
				 (MIN(AvgPlace)
				 FOR RDAId
				 IN(['+rtrim(@RDAId)+'])
		) pvt
		where isnull(pvt.['+rtrim(@RDAId)+'],0) > 0
	 ) as t_Place on t_Place.QuestionTypeId = t_Percent.[QuestionTypeId]
'
	exec sp_executesql @sql
end

