
/*
 declare @date_from datetime='2019-11-09 00:00:00.000'
    ,@date_to datetime='2019-11-09 00:00:00.000'
	,@rda_id  int=2008
	,@rating_id int=1;
	*/
  declare @date_from_d date=CONVERT(datetime, SWITCHOFFSET(@date_from, DATEPART(TZOFFSET,@date_from AT TIME ZONE 'E. Europe Standard Time')))
  --@date_from
  declare @date_to_d date=CONVERT(datetime, SWITCHOFFSET(@date_to, DATEPART(TZOFFSET,@date_to AT TIME ZONE 'E. Europe Standard Time')))
  --@date_to
  declare @date_first date=
  case when day(@date_from_d)=1
	then datefromparts(year(dateadd(dd, -1, @date_from_d)),month(dateadd(dd, -1, @date_from_d)),1)
    else datefromparts(year(@date_from_d),month(@date_from_d),1) 
	end
  --declare @date_first date=datefromparts(year(getutcdate()),month(getutcdate()),1)

  --select @date_from_d, @date_first, @date_to_d
  --таблица для РДА начало
    IF object_id('tempdb..#temp_rda_table') is not null BEGIN DROP TABLE #temp_rda_table END

  ;with
it as --дети @id
(select Id, [parent_organization_id] ParentId, short_name name
from [CRM_1551_Analitics].[dbo].[Organizations] t
where id=@rda_id
union all
select t.Id, t.[parent_organization_id]  ParentId, t.short_name name
from [CRM_1551_Analitics].[dbo].[Organizations] t 
inner join it on t.[parent_organization_id]=it.Id)

select * 
into #temp_rda_table
from it-- pit it
  --таблица для РДА конец

  --select @date_first
  --все нужные организации
  IF object_id('tempdb..#temp_org_table') is not null BEGIN DROP TABLE #temp_org_table END

  select distinct r.OrganizationId, [Organizations].short_name OrganizationName
  into #temp_org_table
  from 
  #temp_rda_table rda
  inner join [dbo].[Rating_ResultTable_ByOrganization] r on rda.Id=r.OrganizationId
  inner join [CRM_1551_Analitics].[dbo].[Organizations] on r.OrganizationId=[Organizations].Id
  --inner join #temp_rda_table rda on [Organizations].Id=rda.Id
  where r.[DateCalc] between @date_first and @date_to_d and r.[RatingId]=@rating_id
  and
  (
  [PercentClosedOnTime] is not null or --Процент закритий на час
      [PercentOfExecution] is not null or --Відсоток виконання
      [PercentOnVeracity] is not null or --Відсоток від правдивості
      [IndexOfSpeedToExecution] is not null or --Індекс швидкості виконання
      [IndexOfSpeedToExplain] is not null or --Індекс швидкості для пояснення
      [IndexOfFactToExecution] is not null or --Індекс факту виконання
      [PercentPleasureOfExecution] is not null --Відсоток задоволення від виконання
  )

  --select  @date_first, @date_from_d, @date_to_d
  --select * from #temp_org_table
  -- для определенного периода

  IF object_id('tempdb..#temp_org_filter') is not null BEGIN DROP TABLE #temp_org_filter END

  select r.[OrganizationId]--, [Organizations].short_name name
  ,avg(r.[PercentClosedOnTime]) avg_PercentClosedOnTime --Процент закритий на час
      ,avg(r.[PercentOfExecution]) avg_PercentOfExecution --Відсоток виконання
      ,avg(r.[PercentOnVeracity]) avg_PercentOnVeracity --Відсоток від правдивості
      ,avg(r.[IndexOfSpeedToExecution]) avg_IndexOfSpeedToExecution --Індекс швидкості виконання
      ,avg(r.[IndexOfSpeedToExplain]) avg_IndexOfSpeedToExplain --Індекс швидкості для пояснення
      ,avg(r.[IndexOfFactToExecution]) avg_IndexOfFactToExecution --Індекс факту виконання
      ,avg(r.[PercentPleasureOfExecution]) avg_PercentPleasureOfExecution --Відсоток задоволення від виконання
  into #temp_org_filter
  from #temp_rda_table rda
  inner join [dbo].[Rating_ResultTable_ByOrganization] r on r.[OrganizationId]=rda.Id
    --inner join #temp_rda_table rda on r.[OrganizationId]=rda.Id
  --inner join [CRM_1551_Analitics].[dbo].[Organizations] on r.OrganizationId=[Organizations].Id
  where r.[DateCalc] between @date_from_d and @date_to_d and r.[RatingId]=@rating_id
  group by r.[OrganizationId]--, [Organizations].short_name

  --для периода с 1го числа

  IF object_id('tempdb..#temp_org_first') is not null BEGIN DROP TABLE #temp_org_first END

  select r.[OrganizationId]--, [Organizations].short_name name
  ,avg(r.[PercentClosedOnTime]) avg_PercentClosedOnTime --Процент закритий на час
      ,avg(r.[PercentOfExecution]) avg_PercentOfExecution --Відсоток виконання
      ,avg(r.[PercentOnVeracity]) avg_PercentOnVeracity --Відсоток від правдивості
      ,avg(r.[IndexOfSpeedToExecution]) avg_IndexOfSpeedToExecution --Індекс швидкості виконання
      ,avg(r.[IndexOfSpeedToExplain]) avg_IndexOfSpeedToExplain --Індекс швидкості для пояснення
      ,avg(r.[IndexOfFactToExecution]) avg_IndexOfFactToExecution --Індекс факту виконання
      ,avg(r.[PercentPleasureOfExecution]) avg_PercentPleasureOfExecution --Відсоток задоволення від виконання
  into #temp_org_first
  from #temp_rda_table rda
  inner join [dbo].[Rating_ResultTable_ByOrganization] r on r.[OrganizationId]=rda.Id
  --inner join #temp_rda_table rda on r.[OrganizationId]=rda.Id
  --inner join [CRM_1551_Analitics].[dbo].[Organizations] on r.OrganizationId=[Organizations].Id
  where r.[DateCalc]>= @date_first and r.[DateCalc]<@date_from_d and r.[RatingId]=@rating_id
  group by r.[OrganizationId]--, [Organizations].short_name

  select tab.OrganizationId Id, tab.OrganizationName,
  convert(numeric(8,2), fir.avg_PercentClosedOnTime) avg_PercentClosedOnTime_with_1, --Процент закритий на час
  convert(numeric(8,2), fil.avg_PercentClosedOnTime) avg_PercentClosedOnTime_with_filter,
  case when fil.avg_PercentClosedOnTime-fir.avg_PercentClosedOnTime>0
  then N'+'+ltrim(convert(numeric(8,2), fil.avg_PercentClosedOnTime-fir.avg_PercentClosedOnTime))
  when fil.avg_PercentClosedOnTime-fir.avg_PercentClosedOnTime<0
  then ltrim(convert(numeric(8,2), fil.avg_PercentClosedOnTime-fir.avg_PercentClosedOnTime))
  end avg_PercentClosedOnTime_dyn,

  convert(numeric(8,2), fir.avg_PercentOfExecution) avg_PercentOfExecution_with_1, --Відсоток виконання
  convert(numeric(8,2), fil.avg_PercentOfExecution) avg_PercentOfExecution_with_filter,
  case when fil.avg_PercentOfExecution-fir.avg_PercentOfExecution>0
  then N'+'+ltrim(convert(numeric(8,2), fil.avg_PercentOfExecution-fir.avg_PercentOfExecution))
  when fil.avg_PercentOfExecution-fir.avg_PercentOfExecution<0
  then ltrim(convert(numeric(8,2), fil.avg_PercentOfExecution-fir.avg_PercentOfExecution))
  end avg_PercentOfExecution_dyn,

  convert(numeric(8,2), fir.avg_PercentOnVeracity) avg_PercentOnVeracity_with_1, --Відсоток від правдивості
  convert(numeric(8,2), fil.avg_PercentOnVeracity) avg_PercentOnVeracity_with_filter,
  case when fil.avg_PercentOnVeracity-fir.avg_PercentOnVeracity>0
  then N'+'+ltrim(convert(numeric(8,2), fil.avg_PercentOnVeracity-fir.avg_PercentOnVeracity))
  when fil.avg_PercentOnVeracity-fir.avg_PercentOnVeracity<0
  then ltrim(convert(numeric(8,2), fil.avg_PercentOnVeracity-fir.avg_PercentOnVeracity))
  end avg_PercentOnVeracity_dyn,

  convert(numeric(8,2), fir.avg_IndexOfSpeedToExecution) avg_IndexOfSpeedToExecution_with_1, --Індекс швидкості виконання
  convert(numeric(8,2), fil.avg_IndexOfSpeedToExecution) avg_IndexOfSpeedToExecution_with_filter,
  case when fil.avg_IndexOfSpeedToExecution-fir.avg_IndexOfSpeedToExecution>0
  then N'+'+ltrim(convert(numeric(8,2), fil.avg_IndexOfSpeedToExecution-fir.avg_IndexOfSpeedToExecution))
  when fil.avg_IndexOfSpeedToExecution-fir.avg_IndexOfSpeedToExecution<0
  then ltrim(convert(numeric(8,2), fil.avg_IndexOfSpeedToExecution-fir.avg_IndexOfSpeedToExecution))
  end avg_IndexOfSpeedToExecution_dyn,

  convert(numeric(8,2), fir.avg_IndexOfSpeedToExplain) avg_IndexOfSpeedToExplain_with_1, --Індекс швидкості для пояснення
  convert(numeric(8,2), fil.avg_IndexOfSpeedToExplain) avg_IndexOfSpeedToExplain_with_filter,
  case when fil.avg_IndexOfSpeedToExplain-fir.avg_IndexOfSpeedToExplain>0
  then N'+'+ltrim(convert(numeric(8,2), fil.avg_IndexOfSpeedToExplain-fir.avg_IndexOfSpeedToExplain))
  when fil.avg_IndexOfSpeedToExplain-fir.avg_IndexOfSpeedToExplain<0
  then ltrim(convert(numeric(8,2), fil.avg_IndexOfSpeedToExplain-fir.avg_IndexOfSpeedToExplain))
  end avg_IndexOfSpeedToExplain_dyn,

  convert(numeric(8,2), fir.avg_IndexOfFactToExecution) avg_IndexOfFactToExecution_with_1, --Індекс факту виконання
  convert(numeric(8,2), fil.avg_IndexOfFactToExecution) avg_IndexOfFactToExecution_with_filter,
  case when fil.avg_IndexOfFactToExecution-fir.avg_IndexOfFactToExecution>0
  then N'+'+ltrim(convert(numeric(8,2), fil.avg_IndexOfFactToExecution-fir.avg_IndexOfFactToExecution))
  when fil.avg_IndexOfFactToExecution-fir.avg_IndexOfFactToExecution<0
  then ltrim(convert(numeric(8,2), fil.avg_IndexOfFactToExecution-fir.avg_IndexOfFactToExecution))
  end avg_IndexOfFactToExecution_dyn,

  convert(numeric(8,2), fir.avg_PercentPleasureOfExecution) avg_PercentPleasureOfExecution_with_1, --Індекс факту виконання
  convert(numeric(8,2), fil.avg_PercentPleasureOfExecution) avg_PercentPleasureOfExecution_with_filter,
  case when fil.avg_PercentPleasureOfExecution-fir.avg_PercentPleasureOfExecution>0
  then N'+'+ltrim(convert(numeric(8,2), fil.avg_PercentPleasureOfExecution-fir.avg_PercentPleasureOfExecution))
  when fil.avg_PercentPleasureOfExecution-fir.avg_PercentPleasureOfExecution<0
  then ltrim(convert(numeric(8,2), fil.avg_PercentPleasureOfExecution-fir.avg_PercentPleasureOfExecution)) 
  end avg_PercentPleasureOfExecution_dyn

  from #temp_org_table tab
  left join #temp_org_first fir on tab.OrganizationId=fir.OrganizationId
  left join #temp_org_filter fil on tab.OrganizationId=fil.OrganizationId

  order by tab.OrganizationName

  --select * from #temp_org_first where OrganizationId=2454
  --select * from #temp_org_filter where OrganizationId=2454