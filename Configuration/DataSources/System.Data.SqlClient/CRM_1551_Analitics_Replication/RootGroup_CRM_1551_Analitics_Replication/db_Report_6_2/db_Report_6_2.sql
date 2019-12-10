--  declare @dateFrom datetime = '2019-11-05 00:00:00';
--  declare @dateTo datetime = current_timestamp;

 declare @filterTo datetime = dateadd(second,59,(dateadd(minute,59,(dateadd(hour,23,cast(cast(dateadd(day,0,@dateTo) as date) as datetime))))));

select
ROW_NUMBER() OVER(ORDER BY d.name) as Id,
       d.[name] as district, 
       isnull(gvp.gvpQty, 0) as gvpQty,
       isnull(hvp.hvpQty, 0) as hvpQty, 
	   isnull(heating.heatingQty,0) as heatingQty,
	   isnull(electricity.electricityQty,0) as electricityQty
from [Districts] d
left join 
(
select d.name as dName, count(o.Id) as gvpQty
from [Districts] d
left join Buildings b on b.district_id = d.Id
left join [Objects] o on o.builbing_id = b.Id
left join Questions q on q.[object_id] = o.Id
left join QuestionTypes qt on qt.Id = q.question_type_id
where qt.Id in (67) and d.name is not null 
and q.registration_date between @dateFrom and @filterTo
group by d.name) gvp on gvp.dName = d.[name]
left join 
(
select d.name as dName, count(o.Id) as hvpQty
from [Districts] d
left join Buildings b on b.district_id = d.Id
left join [Objects] o on o.builbing_id = b.Id
left join Questions q on q.[object_id] = o.Id
left join QuestionTypes qt on qt.Id = q.question_type_id
where qt.Id in (75) and d.name is not null 
and q.registration_date between @dateFrom and @filterTo
group by d.name) hvp on hvp.dName = d.[name]
left join 
(
select d.name as dName, count(o.Id) as heatingQty
from [Districts] d
left join Buildings b on b.district_id = d.Id
left join [Objects] o on o.builbing_id = b.Id
left join Questions q on q.[object_id] = o.Id
left join QuestionTypes qt on qt.Id = q.question_type_id
where qt.Id in (86) and d.name is not null 
and q.registration_date between @dateFrom and @filterTo
group by d.name) heating on heating.dName = d.[name]
left join 
(
select d.name as dName, count(o.Id) as electricityQty
from [Districts] d
left join Buildings b on b.district_id = d.Id
left join [Objects] o on o.builbing_id = b.Id
left join Questions q on q.[object_id] = o.Id
left join QuestionTypes qt on qt.Id = q.question_type_id
where qt.Id in (97) and d.name is not null 
and q.registration_date between @dateFrom and @filterTo
group by d.name) electricity on electricity.dName = d.[name]
where d.Id <> 11