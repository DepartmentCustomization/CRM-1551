 --declare @dateFrom datetime = '2019-01-01 00:00:00';
 --declare @dateTo datetime = current_timestamp;

 declare @filterTo datetime = dateadd(second,59,(dateadd(minute,59,(dateadd(hour,23,cast(cast(dateadd(day,0,@dateTo) as date) as datetime))))));

declare @tab_All table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Agr table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Trans table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Finance table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Social table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Work table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Health table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);

IF OBJECT_ID('tempdb..#sources') IS NOT NULL DROP TABLE #sources
CREATE TABLE #sources (
    row# nvarchar(3) null,
    source_name VARCHAR(MAX) COLLATE Ukrainian_CI_AS
);
begin
insert into #sources (source_name)
select [name] 
from ReceiptSources
where Id not in (4,5,6,7)
Union 
select  'КБУ'
--select * from #sources
end
--- По всім групам питань
begin 
insert into @tab_All ([source], prev_val, cur_val) 
-- Попередній рік
select z.source_name, isnull(AllPrev,0) AllPrev, isnull(AllCur,0) AllCur
from #sources z
left join (
select source_name, count(q.Id) AllPrev
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where year(q.registration_date) = (select dateadd(year, -1, year(current_timestamp)))
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@filterTo)) 
group by #sources.source_name 
UNION 
select 'КБУ' as source_name, isnull(count(Id),0)
from Questions q
where year(registration_date) = (select dateadd(year, -1, year(current_timestamp))) 
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@filterTo))) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) AllCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where year(q.registration_date) = year(current_timestamp)
and q.registration_date between @dateFrom and @filterTo 
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(Id),0) Val
from Questions q
where year(registration_date) = year(current_timestamp)
and q.registration_date between @dateFrom and @filterTo) ss on ss.source_name = z.source_name
end
--select * from @tab_All
--- Аграрної політики і земельних відносин
begin 
insert into @tab_Agr (source, prev_val, cur_val) 
-- Попередній рік
select z.source_name, isnull(AgrPrev,0) AgrPrev, isnull(AgrCur,0) AgrCur
from #sources z
left join (
select source_name, count(q.Id) AgrPrev
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 5
and year(q.registration_date) = (select dateadd(year, -1, year(current_timestamp)))
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@filterTo)) 
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 5 and 
year(registration_date) = (select dateadd(year, -1, year(current_timestamp)))
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@filterTo)) ) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) AgrCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 5
and year(q.registration_date) = year(current_timestamp) 
and q.registration_date between @dateFrom and @filterTo
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 5 and 
year(registration_date) = year(current_timestamp)
and q.registration_date between @dateFrom and @filterTo
) ss on ss.source_name = z.source_name
end
--select * from @tab_Agr
--- Транспорту і зв'язку
begin 
insert into @tab_Trans (source, prev_val, cur_val) 
-- Попередній рік
select z.source_name, isnull(TransPrev,0) TransPrev, isnull(TransCur,0) TransCur
from #sources z
left join (
select source_name, count(q.Id) TransPrev
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 6
and year(q.registration_date) = (select dateadd(year, -1, year(current_timestamp)))
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@filterTo)) 
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 6 and 
year(registration_date) = (select dateadd(year, -1, year(current_timestamp))) 
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@filterTo))) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) TransCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 6
and year(q.registration_date) = year(current_timestamp) 
and q.registration_date between @dateFrom and @filterTo
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 6 and 
year(registration_date) = year(current_timestamp)
and q.registration_date between @dateFrom and @filterTo
) ss on ss.source_name = z.source_name
end
--select * from @tab_Trans
--- Фінансової, податкової, митної політики
begin 
insert into @tab_Finance (source, prev_val, cur_val) 
-- Попередній рік
select z.source_name, isnull(FinancePrev,0) FinancePrev, isnull(FinanceCur,0) FinanceCur
from #sources z
left join (
select source_name, count(q.Id) FinancePrev
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 7
and year(q.registration_date) = (select dateadd(year, -1, year(current_timestamp))) 
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@filterTo))
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 7 and 
year(registration_date) = (select dateadd(year, -1, year(current_timestamp)))
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@filterTo))) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) FinanceCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 7
and year(q.registration_date) = year(current_timestamp) 
and q.registration_date between @dateFrom and @filterTo
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 7 and 
year(registration_date) = year(current_timestamp)
and q.registration_date between @dateFrom and @filterTo
) ss on ss.source_name = z.source_name
end
--select * from @tab_Finance
--- Cоціального захисту
begin 
insert into @tab_Social (source, prev_val, cur_val) 
-- Попередній рік
select z.source_name, isnull(SocialPrev,0) SocialPrev, isnull(SocialCur,0) SocialCur
from #sources z
left join (
select source_name, count(q.Id) SocialPrev
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 8
and year(q.registration_date) = (select dateadd(year, -1, year(current_timestamp))) 
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@filterTo))
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 8 and 
year(registration_date) = (select dateadd(year, -1, year(current_timestamp))) 
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@filterTo))) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) SocialCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 8
and year(q.registration_date) = year(current_timestamp) 
and q.registration_date between @dateFrom and @filterTo
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 8 and 
year(registration_date) = year(current_timestamp)
and q.registration_date between @dateFrom and @filterTo
) ss on ss.source_name = z.source_name
end
--select * from @tab_Social
--- Праці і заробітної плати, охорони праці, промислової безпеки
begin 
insert into @tab_Work (source, prev_val, cur_val) 
-- Попередній рік
select z.source_name, isnull(WorkPrev,0) WorkPrev, isnull(WorkCur,0) WorkCur
from #sources z
left join (
select source_name, count(q.Id) WorkPrev
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 9
and year(q.registration_date) = (select dateadd(year, -1, year(current_timestamp)))
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@filterTo)) 
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 9 and 
year(registration_date) = (select dateadd(year, -1, year(current_timestamp))) 
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@filterTo))) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) WorkCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 9
and year(q.registration_date) = year(current_timestamp) 
and q.registration_date between @dateFrom and @filterTo
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 9 and 
year(registration_date) = year(current_timestamp)
and q.registration_date between @dateFrom and @filterTo
) ss on ss.source_name = z.source_name
end
--select * from @tab_Work
--- Охорони здоров'я
begin 
insert into @tab_Health (source, prev_val, cur_val) 
-- Попередній рік
select z.source_name, isnull(HealthPrev,0) HealthPrev, isnull(HealthCur,0) WorkCur
from #sources z
left join (
select source_name, count(q.Id) HealthPrev
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 10
and year(q.registration_date) = (select dateadd(year, -1, year(current_timestamp)))
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@filterTo)) 
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 10 and 
year(registration_date) = (select dateadd(year, -1, year(current_timestamp))) 
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@filterTo))) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) HealthCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 10
and year(q.registration_date) = year(current_timestamp) 
and q.registration_date between @dateFrom and @filterTo
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 10 and 
year(registration_date) = year(current_timestamp)
and q.registration_date between @dateFrom and @filterTo
) ss on ss.source_name = z.source_name
end
--select * from @tab_Health
begin
declare @result table (source nvarchar(200), prevAll nvarchar(10), curAll nvarchar(10),
                       prevAgr nvarchar(10), curAgr nvarchar(10), prevTrans nvarchar(10),
					   curTrans nvarchar(10), prevFinance nvarchar(10), curFinance nvarchar(10),
					   prevSocial nvarchar(10), curSocial nvarchar(10), prevWork nvarchar(10),
					   curWork nvarchar(10), prevHealth nvarchar(10), curHealth nvarchar(10) ) 

	              insert into @result 
				  select source_name, 
				  t_all.prev_val prevAll, t_all.cur_val curAll,
				  t_agr.prev_val prevArg, t_agr.cur_val curAgr,
				  t_trans.prev_val prevTrans, t_trans.cur_val curTrans,
				  t_fin.prev_val prevFinance, t_fin.cur_val curFinance,
				  t_soc.prev_val prevSocial, t_soc.cur_val curSocial,
				  t_work.prev_val prevWork, t_work.cur_val curWork,
				  t_heal.prev_val prevHealth, t_heal.cur_val curHealth
			from #sources s
			join @tab_All t_all on t_all.[source] = s.source_name
			join @tab_Agr t_agr on t_agr.[source] = s.source_name
			join @tab_Trans t_trans on t_trans.source = s.source_name
			join @tab_Finance t_fin on t_fin.source = s.source_name
			join @tab_Social t_soc on t_soc.source = s.source_name
			join @tab_Work t_work on t_work.source = s.source_name
			join @tab_Health t_heal on t_heal.source = s.source_name
 
end

begin

update #sources
set row# = case [source_name]
                  when 'КБУ' then '1.'
                  when 'Дзвінок в 1551' then '1.1'
				  when 'Сайт/моб. додаток' then '1.2'
				  when 'УГЛ' then '1.3'
                  when 'Телеефір' then '1.4'
end
end

     select s.row#,
	 case when [source] = 'КБУ' then 'Питання, що надійшли до КБУ «Контактний центр міста Києва»'
	 when [source] = 'Дзвінок в 1551' then 'з них, через гарячу лінію 1551'
	 when [source] = 'Сайт/моб. додаток' then 'з них, через офіційний веб-портал та додатки для мобільних пристроїв'
	 when [source] = 'УГЛ' then 'з них, через ДУ «Урядовий контактний центр»'
	 when [source] = 'Телеефір' then 'з них, у рамках проекту «Прямий зв`язок з київською міською владаю»'
	 else '' end as [source],
	 IIF(prevAll = '0', '-', prevAll) prevAll, IIF(curAll = '0', '-', curAll) curAll,
	 IIF(prevAgr = '0', '-', prevAgr) prevAgr, IIF(curAgr = '0', '-', curAgr) curAgr,
	 IIF(prevTrans = '0', '-', prevTrans) prevTrans, IIF(curTrans = '0', '-', curTrans) curTrans,
	 IIF(prevFinance = '0', '-', prevFinance) prevFinance, IIF(curFinance = '0', '-', curFinance) curFinance,
	 IIF(prevSocial = '0', '-', prevSocial) prevSocial, IIF(curSocial = '0', '-', curSocial) curSocial,
	 IIF(prevWork = '0', '-', prevWork) prevWork, IIF(curWork = '0', '-', curWork) curWork,
	 IIF(prevHealth = '0', '-', prevHealth) prevHealth, IIF(curHealth = '0', '-', curHealth) curHealth
	 from @result r
	 join #sources s on r.source = s.source_name	 
	 order by row#
