--declare @q_type_id int = 4
-- declare @getdate datetime = dateadd(day,-3,getutcdate())
declare @getdate datetime = getutcdate()


select 
case when dat1.[is_work] = 0 then dateadd(second,59,dateadd(minute,59,dateadd(hour,23,cast(dat2.execution_date as datetime))))
else dateadd(second,59,dateadd(minute,59,dateadd(hour,23,cast(cast(@getdate + [QuestionTypes].[execution_term]/24 as date) as datetime)))) end as execut/*,
@getdate + [QuestionTypes].[execution_term]/24,
[QuestionTypes].[execution_term]
,dat1.*
,dat2.**/
from [dbo].[QuestionTypes]
left join  [dbo].[WorkDaysCalendar] as dat1 on dat1.[date] = cast((@getdate + [QuestionTypes].[execution_term]/24) as date)
left join  [dbo].[WorkDaysCalendar] as dat2 on dat1.[execution_date] = dat2.[date]
where [QuestionTypes].[id] = @q_type_id


/*select 
getdate() + execution_term/24 as execut
from QuestionTypes
where id = @q_type_id
*/