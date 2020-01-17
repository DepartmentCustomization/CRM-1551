exec pr_check_date @registration_date



/*
    -- declare @registration_date datetime = '2019-05-06 12:45'
    declare @getdate datetime = getutcdate()
    declare @control_date date = dateadd(day, 3, @registration_date)
    
    select 
    case when dat1.[is_work] = 0 then dateadd(second,59,dateadd(minute,59,dateadd(hour,23,cast(dat2.execution_date as datetime))))
    else dateadd(second,59,dateadd(minute,59,dateadd(hour,23,cast(@control_date as datetime)))) end as control_date
    from  [dbo].[WorkDaysCalendar] as dat1 
    left join  [dbo].[WorkDaysCalendar] as dat2 on dat1.[execution_date] = dat2.[date]
    where dat1.date = @control_date
*/