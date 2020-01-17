declare @sources table (Id int, source nvarchar(200));
declare @call_q int;
declare @site_q int;
declare @ugl_q int;
declare @result table (source nvarchar(200), val int);

 --declare @dateFrom datetime = '2019-01-05 00:00:00';
 --declare @dateTo datetime = '2019-12-05 00:00:00';

 declare @filterTo datetime = dateadd(second,59,(dateadd(minute,59,(dateadd(hour,23,cast(cast(dateadd(day,0,@dateTo) as date) as datetime))))));

select qt.Id as Id, qt.[name] as qType, count(q.Id) qty
from Questions q
join QuestionTypes qt on qt.Id = q.question_type_id
join [Objects] o on o.Id = q.[object_id]
where o.Id = 125342
and q.registration_date between @dateFrom and @filterTo 
and #filter_columns#
group by qt.[name], qt.Id
order by qty desc