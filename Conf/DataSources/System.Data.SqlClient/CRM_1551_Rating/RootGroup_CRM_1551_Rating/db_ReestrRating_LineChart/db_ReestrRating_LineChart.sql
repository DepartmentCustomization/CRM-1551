/*
declare @CalcDate date = N'2020-09-30',
		@RatingId int = 1
*/
--------------------------------
declare @StartDate_IN date = rtrim(left(dateadd(day,-1,cast(@CalcDate as date)), 7))+ '-02',
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
from (select distinct DateCalc from [dbo].[Rating_ResultTable] where DateCalc between @fromDate and @toDate) as A
order by DateCalc
--select @str

set @q =
'SELECT pvt.RDAId
		,t3.[short_name] as [RDAName]
		,'+left(@str,len(@str)-1)+'
FROM 
	(  select DateCalc,
		RDAId,
		RANK() OVER(PARTITION BY RatingId, DateCalc ORDER BY IntegratedMetric_PerformanceLevel desc) as [Place]
		from [dbo].[Rating_ResultTable]
		where DateCalc between N'''+convert(nvarchar,@fromDate,121)+''' and N'''+convert(nvarchar,@toDate,121)+'''
		and RatingId = '+rtrim(@RatingId)+' ) p
PIVOT
(
MAX([Place])
FOR [DateCalc] IN
( '+left(@str,len(@str)-1)+' )
) AS pvt
left join [CRM_1551_Analitics].[dbo].[Organizations] as t3 on t3.Id = pvt.RDAId 

'
--select @q
exec (@q)