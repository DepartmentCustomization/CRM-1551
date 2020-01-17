  --declare @dateFrom datetime = '2020-01-01 00:00:00';
  --declare @dateTo datetime = '2020-01-09 00:00:00';

--  declare @filterTo datetime = dateadd(second,59,(dateadd(minute,59,(dateadd(hour,23,cast(cast(dateadd(day,0,@dateTo) as date) as datetime))))));

 declare @currentYear int = year(@dateFrom);
 declare @previousYear int = year(@dateFrom)-1;

 declare @dayNumStart int = datepart(dayofyear, @dateFrom);
 declare @dayNumEnd int = datepart(dayofyear, @dateTo);

 SELECT
 qtyPrev,
 qtyCurrent,
 qtyMail_prev,
 qtyMail_curr,
 qtyPos_prev,
 qtyPos_curr,
 qtyNeg_prev,
 qtyNeg_curr,
 qtyPersonal_prev,
 qtyPersonal_curr,
 qtyExpl_prev,
 qtyExpl_curr,
 IIF(qtyElse_prev = '0', N'-', qtyElse_prev) qtyElse_prev,
 IIF(qtyElse_curr = '0', N'-', qtyElse_curr) qtyElse_curr
 FROM (
SELECT *,
CAST(((CAST(qtyPrev AS INT) - CAST(ISNULL(qtyNeg_prev,0) AS INT) ) - (CAST(qtyPos_prev AS INT) ) - CAST(qtyExpl_prev AS INT)) AS NVARCHAR(10))
AS qtyElse_prev,
CAST(((CAST(qtyCurrent AS INT) - CAST(ISNULL(qtyNeg_curr,0) AS INT) ) - (CAST(qtyPos_curr AS INT) ) - CAST(qtyExpl_curr AS INT)) AS NVARCHAR(10))
AS qtyElse_curr
FROM (
select distinct
IIF(qtyPrev = '0', N'-', qtyPrev ) qtyPrev, 
IIF(qtyCurrent = '0', N'-', qtyCurrent ) qtyCurrent, 
IIF(qtyMail_prev = '0', N'-', qtyMail_prev ) qtyMail_prev,
IIF(qtyMail_curr = '0', N'-', qtyMail_curr ) qtyMail_curr,
qtyPersonal_prev, qtyPersonal_curr,
IIF(qtyPos_prev = '0', N'-', qtyPos_prev ) qtyPos_prev,
IIF(qtyPos_curr = '0', N'-', qtyPos_curr ) qtyPos_curr,
IIF(qtyNeg_prev = '0', N'-', qtyNeg_prev ) qtyNeg_prev,
IIF(qtyNeg_curr = '0', N'-', qtyNeg_curr ) qtyNeg_curr,
IIF(qtyExpl_prev = '0', N'-',qtyExpl_prev ) qtyExpl_prev,
IIF(qtyExpl_curr = '0', N'-', qtyExpl_curr ) qtyExpl_curr

from Questions q
 -- Всього за попередній 
left join (select cast(count(Id) as nvarchar) as qtyPrev
           from Questions 
		   where question_type_id is not null
		   and year(registration_date) = 
		   @previousYear
		   and datepart(dayofyear, registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
		   ) qPrev on 1 <> 0
 -- Всього за теперішній
left join (select cast(count(Id) as nvarchar) as qtyCurrent
           from Questions 
		   where question_type_id is not null
		   and year(registration_date) = 
		                        @currentYear
		   and datepart(dayofyear, registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
		   ) qCurr on 1 <> 0
-- Поштовим листом за попередній
left join (select cast(count(q.Id) as nvarchar) as qtyMail_prev
           from Questions q
		   join Appeals a on a.Id = q.appeal_id 
		   where a.receipt_source_id = 5 
		   	and	year(q.registration_date) = @previousYear
		    		   and datepart(dayofyear, q.registration_date) 
		   between @dayNumStart and @dayNumEnd
		   ) qMail_prev on 1 <> 0
-- Поштовим листом за теперішній
left join (select cast(count(q.Id) as nvarchar) as qtyMail_curr
           from Questions q
		   join Appeals a on a.Id = q.appeal_id 
		   where a.receipt_source_id = 5 
		    and year(q.registration_date) = 
		                        @currentYear
		   		   and datepart(dayofyear, q.registration_date) 
		   between @dayNumStart and @dayNumEnd
		   ) qMail_curr on 1 <> 0
-- На особистому прийомі за попередній
left join (select '-' as qtyPersonal_prev
		   ) qPersonal_prev on 1 <> 0
-- На особистому прийомі за теперішній
left join (select '-' as qtyPersonal_curr
		   ) qPersonal_curr on 1 <> 0
-- Вирішено позитивно (виконано) за попередній 
left join (select cast(count(q.Id) as nvarchar) as qtyPos_prev
           from Questions q
		   join Assignments ass on q.Id = ass.question_id
		   where ass.main_executor = 1 
		    and ass.assignment_state_id = 5 and ass.AssignmentResultsId = 4
		    and year(q.registration_date) = @previousYear
		    		   and datepart(dayofyear, q.registration_date) 
		   between @dayNumStart and @dayNumEnd
		   ) qPos_prev on 1 <> 0
-- Вирішено позитивно (виконано) за теперішній
left join (select cast(count(q.Id) as nvarchar) as qtyPos_curr
           from Questions q
		   join Assignments ass on q.Id = ass.question_id
		   where ass.main_executor = 1 
		   and ass.assignment_state_id = 5 and ass.AssignmentResultsId = 4
		   and year(q.registration_date) = 
		                        @currentYear
		    		   and datepart(dayofyear, q.registration_date) 
		   between @dayNumStart and @dayNumEnd
		   ) qPos_curr on 1 <> 0
-- Вирішено негативно (не виконано) за попередній 
left join (select cast(count(q.Id) as nvarchar) as qtyNeg_prev
           from Questions q
		   join Assignments ass on q.Id = ass.question_id
		   where ass.main_executor = 1 
		    and ass.assignment_state_id = 4
			and ass.AssignmentResultsId in (5, 12)
		    and	year(q.registration_date) = @previousYear
		    		   and datepart(dayofyear, q.registration_date) 
		   between @dayNumStart and @dayNumEnd
		   ) qNeg_prev on 1 <> 0
-- Вирішено негативно (не виконано) за теперішній
left join (select cast(count(q.Id) as nvarchar) as qtyNeg_curr
           from Questions q
		   join Assignments ass on q.Id = ass.question_id
		   where ass.main_executor = 1 
		    and ass.assignment_state_id = 4
			and ass.AssignmentResultsId in (5, 12)
            and year(q.registration_date) = 
		                        @currentYear
		   		   and datepart(dayofyear, q.registration_date) 
		   between @dayNumStart and @dayNumEnd
		   ) qNeg_curr on 1 <> 0
-- Дано роз'яснення за попередній 
left join (select cast(count(q.Id) as nvarchar) as qtyExpl_prev
           from Questions q
		   join Assignments ass on q.Id = ass.question_id
		   where ass.main_executor = 1 
		    and ass.assignment_state_id = 5
		    and ass.AssignmentResultsId = 7  
            and	year(q.registration_date) = @previousYear
		    		   and datepart(dayofyear, q.registration_date) 
		   between @dayNumStart and @dayNumEnd
		   ) qExpl_prev on 1 <> 0
-- Дано роз'яснення за теперішній
left join (select cast(count(q.Id) as nvarchar) as qtyExpl_curr
           from Questions q
		   join Assignments ass on q.Id = ass.question_id
		   where ass.main_executor = 1 
		    and ass.assignment_state_id = 5
		    and ass.AssignmentResultsId  = 7 
            and year(q.registration_date) = 
		                        @currentYear
		   	and datepart(dayofyear, q.registration_date) 
		   between datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
		   ) qExpl_curr on 1 <> 0
-- Інше 
) x
) z