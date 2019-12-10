/*
declare @CalcDate date = N'2019-10-16',
		@RatingId int = 1
*/

--------------------------------
declare @StartDate_IN date = rtrim(left(dateadd(day,-1,cast(@CalcDate as date)), 7))+ '-01',
        @EndDate_IN  date = @CalcDate
--select  @StartDate_IN, @CalcDate

declare @str nvarchar(MAX)
declare @q nvarchar(MAX)
declare @fromDate date
declare @toDate date

set @fromDate =@StartDate_IN
set @toDate =@EndDate_IN
set @str=''
select @str = @str + '[' + cast(DateCalc as varchar) + '],'
from (select distinct DateCalc from [dbo].[Rating_IntegratedMetric_PerformanceLevel] where DateCalc between @fromDate and @toDate) as A
--select @str

set @q =
'SELECT pvt.RDAId
,t3.[short_name] as [RDAName]
,'+left(@str,len(@str)-1)+'
,t2.IndicatorAVG
,RANK() OVER(ORDER BY t2.IndicatorAVG desc) rnk
FROM 
	(  select DateCalc,
		RDAId,
		Indicator as Indicator
		from [dbo].[Rating_IntegratedMetric_PerformanceLevel]
		where DateCalc between N'''+convert(nvarchar,@fromDate,121)+''' and N'''+convert(nvarchar,@toDate,121)+'''
		and RatingId = '+rtrim(@RatingId)+' ) p
PIVOT
(
MAX(Indicator)
FOR [DateCalc] IN
( '+left(@str,len(@str)-1)+' )
) AS pvt
left join (select   RDAId,  AVG(Indicator) as IndicatorAVG   
		   from [dbo].[Rating_IntegratedMetric_PerformanceLevel]   
		   where DateCalc between N'''+convert(nvarchar,@fromDate,121)+''' and N'''+convert(nvarchar,@toDate,121)+'''
		   and RatingId = '+rtrim(@RatingId)+'    
		   group by RDAId
		) t2 on t2.RDAId = pvt.RDAId
left join [CRM_1551_Analitics].[dbo].[Organizations] as t3 on t3.Id = pvt.RDAId 
ORDER BY rnk DESC
'
--select @q
exec (@q)

