--declare @dateFrom datetime = '2019-06-01 00:00:00';
--declare @dateTo datetime = current_timestamp;

select qt.Id as Id, qt.[name] as qType, count(q.Id) qty
from Questions q
join QuestionTypes qt on qt.Id = q.question_type_id
join [Objects] o on o.Id = q.[object_id]
where o.Id = 125342
and q.registration_date between @dateFrom and @dateTo 
and #filter_columns#
group by qt.[name], qt.Id
order by qty desc