--declare @dateFrom date = '2019-05-01';
--declare @dateTo date = cast(current_timestamp as date);

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
IIF(qtyExpl_curr = '0', N'-', qtyExpl_curr ) qtyExpl_curr,
IIF(qtyElse_prev = '0', N'-',qtyElse_prev ) qtyElse_prev,
IIF(qtyElse_curr = '0', N'-', qtyElse_curr ) qtyElse_curr
from Questions q
 -- Всього за попередній 
left join (select cast(count(Id) as nvarchar) as qtyPrev
           from Questions where year(registration_date) = 
		   (select dateadd(year, -1, year(current_timestamp)))
		    and registration_date between dateadd(year, -1, year(@dateFrom))
			and dateadd(year, -1, year(@dateTo)) 
		   ) qPrev on 1 <> 0
 -- Всього за теперішній
left join (select cast(count(Id) as nvarchar) as qtyCurrent
           from Questions where year(registration_date) = 
		                        year(current_timestamp)
			and registration_date between @dateFrom and @dateTo
		   ) qCurr on 1 <> 0
-- Поштовим листом за попередній
left join (select cast(count(q.Id) as nvarchar) as qtyMail_prev
           from Questions q
		   join Appeals a on a.Id = q.appeal_id 
		   where a.receipt_source_id = 5 and year(q.registration_date) = 
		           (select dateadd(year, -1, year(current_timestamp)))
		    and q.registration_date between dateadd(year, -1, year(@dateFrom))
			and dateadd(year, -1, year(@dateTo)) 
		   ) qMail_prev on 1 <> 0
-- Поштовим листом за теперішній
left join (select cast(count(q.Id) as nvarchar) as qtyMail_curr
           from Questions q
		   join Appeals a on a.Id = q.appeal_id 
		   where a.receipt_source_id = 5 and year(q.registration_date) = 
		                                     year(current_timestamp)
			and q.registration_date between @dateFrom and @dateTo
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
		   and year(q.registration_date) = (select dateadd(year, -1, year(current_timestamp)))
		   and q.registration_date between dateadd(year, -1, year(@dateFrom))
		   and dateadd(year, -1, year(@dateTo))
		   ) qPos_prev on 1 <> 0
-- Вирішено позитивно (виконано) за теперішній
left join (select cast(count(q.Id) as nvarchar) as qtyPos_curr
           from Questions q
		   join Assignments ass on q.Id = ass.question_id
		   where ass.main_executor = 1 
		   and ass.assignment_state_id = 5 and ass.AssignmentResultsId = 4
		   and year(q.registration_date) = year(current_timestamp)
		   and q.registration_date between @dateFrom and @dateTo
		   ) qPos_curr on 1 <> 0
-- Вирішено негативно (не виконано) за попередній 
left join (select cast(count(q.Id) as nvarchar) as qtyNeg_prev
           from Questions q
		   join Assignments ass on q.Id = ass.question_id
		   where ass.main_executor = 1 
		   and ass.assignment_state_id = 4 
		   and year(q.registration_date) = (select dateadd(year, -1, year(current_timestamp)))
		   and q.registration_date between dateadd(year, -1, year(@dateFrom))
		   and dateadd(year, -1, year(@dateTo))
		   ) qNeg_prev on 1 <> 0
-- Вирішено негативно (не виконано) за теперішній
left join (select cast(count(q.Id) as nvarchar) as qtyNeg_curr
           from Questions q
		   join Assignments ass on q.Id = ass.question_id
		   where ass.main_executor = 1 
		   and ass.assignment_state_id = 4 
		   and year(q.registration_date) = year(current_timestamp)
		   and q.registration_date between @dateFrom and @dateTo
		   ) qNeg_curr on 1 <> 0
-- Дано роз'яснення за попередній 
left join (select cast(count(q.Id) as nvarchar) as qtyExpl_prev
           from Questions q
		   join Assignments ass on q.Id = ass.question_id
		   where ass.main_executor = 1 
		   and ass.AssignmentResultsId  = 7  
--		   and ass.assignment_state_id not in (1,2,3)
		   and year(q.registration_date) = (select dateadd(year, -1, year(current_timestamp)))
		   and q.registration_date between dateadd(year, -1, year(@dateFrom))
		   and dateadd(year, -1, year(@dateTo))
		   ) qExpl_prev on 1 <> 0
-- Дано роз'яснення за теперішній
left join (select cast(count(q.Id) as nvarchar) as qtyExpl_curr
           from Questions q
		   join Assignments ass on q.Id = ass.question_id
		   where ass.main_executor = 1 
		   and ass.AssignmentResultsId  = 7 
--		   and ass.assignment_state_id not in (1,2,3)
		   and year(q.registration_date) = year(current_timestamp)
		   and q.registration_date between @dateFrom and @dateTo
		   ) qExpl_curr on 1 <> 0
-- Інше (зареєстровано, в роботі, на перевірці) за попередній 
left join (select cast(count(q.Id) as nvarchar) as qtyElse_prev
           from Questions q
		   join Assignments ass on q.Id = ass.question_id
		   where ass.main_executor = 1 
		   and ass.assignment_state_id in (1,2,3)  
		   and year(q.registration_date) = (select dateadd(year, -1, year(current_timestamp)))
		   and q.registration_date between dateadd(year, -1, year(@dateFrom))
		   and dateadd(year, -1, year(@dateTo))
		   ) qElse_prev on 1 <> 0
-- Інше (зареєстровано, в роботі, на перевірці) за теперішній
left join (select cast(count(q.Id) as nvarchar) as qtyElse_curr
           from Questions q
		   join Assignments ass on q.Id = ass.question_id
		   where ass.main_executor = 1 
		   and ass.assignment_state_id in (1,2,3) 
		   and year(q.registration_date) = year(current_timestamp)
		   and q.registration_date between @dateFrom and @dateTo
		   ) qElse_curr on 1 <> 0
