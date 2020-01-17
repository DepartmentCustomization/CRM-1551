--  declare @dateFrom datetime = '2019-07-01 00:00:00';
--  declare @dateTo datetime = '2019-12-31 00:00:00';

--declare @filterTo datetime = dateadd(second,59,(dateadd(minute,59,(dateadd(hour,23,cast(cast(dateadd(day,0,@dateTo) as date) as datetime))))));

declare @currentYear int = year(@dateFrom);
declare @previousYear int = year(@dateFrom)-1;

declare @tab_Rel table (source nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_exPow table (source nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_locMun table (source nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_locPow table (source nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_stCon table (source nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Oth table (source nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Employees table (sourse nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);

declare @tab_Rel2 table (source nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_exPow2 table (source nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_locMun2 table (source nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_locPow2 table (source nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_stCon2 table (source nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Oth2 table (source nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);

IF OBJECT_ID('tempdb..#sources') IS NOT NULL DROP TABLE #sources
CREATE TABLE #sources (
    row# nvarchar(3) null,
    source_name VARCHAR(MAX) COLLATE Ukrainian_CI_AS
);
begin
insert into #sources (source_name)
select name from ReceiptSources
where Id not in (5,6,7)
Union 
select  'КБУ'
--select * from #sources
end
--- Діяльність об'єднань громадян, релігії та міжконфесійних відносин
begin 
insert into @tab_Rel (source, prev_val, cur_val) 
-- Попередній рік
select z.source_name, isnull(RelPrev,0) ComPrev, isnull(RelCur,0) ComCur
from #sources z
left join (
select source_name, count(q.Id) RelPrev
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 18)
and year(q.registration_date) = @previousYear                       
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from Questions q
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 18) 
and year(registration_date) = @previousYear                       
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
		   ) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) RelCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 18)
and year(q.registration_date) = @currentYear                       
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 18) 
and year(registration_date) = @currentYear                       
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
		   ) ss on ss.source_name = z.source_name
end
--- Діяльність центральних органів виконавчої влади
begin 
insert into @tab_exPow (source, prev_val, cur_val) 
select z.source_name, 0, 0 
from #sources z
UNION
select 'КБУ' as source_name, 0, 0
end
--- Діяльність місцевих органів виконавчої влади
begin 
insert into @tab_locMun (source, prev_val, cur_val) 
-- Попередній рік
select z.source_name, isnull(locMunPrev,0) locMunPrev, isnull(locMunCur,0) locMunCur
from #sources z
left join (
select source_name, count(q.Id) locMunPrev
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 19)
and year(q.registration_date) = @previousYear                       
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from Questions q
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 19) 
and year(registration_date) = @previousYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
		   ) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) locMunCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 19)
and year(q.registration_date) = @currentYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 19)
and year(registration_date) = @currentYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
		   ) ss on ss.source_name = z.source_name
end
--- Забезпечення дотримання законності та охорони правопорядку, запобігання дискримінації
begin 
insert into @tab_locPow (source, prev_val, cur_val) 
select z.source_name, 0, 0
from #sources z
UNION
select 'КБУ' as source_name, 0, 0
end
--- Державного будівництва, адміністративно-територіального устрою
begin 
insert into @tab_stCon (source, prev_val, cur_val) 
-- Попередній рік
select z.source_name, isnull(stConPrev,0) stConPrev, isnull(stConCur,0) stConCur
from #sources z
left join (
select source_name, count(q.Id) stConPrev
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 13)
and year(q.registration_date) = @previousYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from Questions q
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 13) 
and year(registration_date) = @previousYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
		   ) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) stConCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 13)
and year(q.registration_date) = @currentYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 13) 
and year(registration_date) = @currentYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
		   ) ss on ss.source_name = z.source_name
end
--- Інші
begin 
insert into @tab_Oth (source, prev_val, cur_val) 
-- Попередній рік
select z.source_name, isnull(OthPrev,0) OthPrev, isnull(OthCur,0) OthCur
from #sources z
left join (
select source_name, count(q.Id) OthPrev
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id is not null 
and q.question_type_id not in (select type_question_id from QGroupIncludeQTypes where group_question_id between 5 and 19)
and year(q.registration_date) = @previousYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
where q.question_type_id is not null 
and q.question_type_id not in (select type_question_id from QGroupIncludeQTypes where group_question_id between 5 and 19)
and year(registration_date) = @previousYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
		   ) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) OthCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id is not null 
and q.question_type_id not in (select type_question_id from QGroupIncludeQTypes where group_question_id between 5 and 19)
and year(q.registration_date) = @currentYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id)+901,0) Val     -- difference in 2019 year
from Questions q
where q.question_type_id is not null
and q.question_type_id not in (select type_question_id from QGroupIncludeQTypes where group_question_id between 5 and 19)
and year(registration_date) = @currentYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
		   ) ss on ss.source_name = z.source_name
end
--- Штатна чисельність підрозідлу роботи зі зверненнями
begin
insert into @tab_Employees (sourse, prev_val, cur_val)
select source_name, case when source_name = 'КБУ' then 125 else 0 end,
case when source_name = 'КБУ' then 125 else 0 end 
from #sources 
end

UPDATE @tab_Rel SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
UPDATE @tab_exPow SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
UPDATE @tab_locMun SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
UPDATE @tab_locPow SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
UPDATE @tab_stCon SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
UPDATE @tab_Oth SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
DELETE from #sources WHERE source_name = 'E-mail'

begin
declare @result table (source nvarchar(200),
                       prevRel nvarchar(10), curRel nvarchar(10), prevExPow nvarchar(10),
					   curExPow nvarchar(10), prevLocMun nvarchar(10), curLocMun nvarchar(10),
					   prevLocPow nvarchar(10), curLocPow nvarchar(10), prevStCon nvarchar(10),
					   curStCon nvarchar(10), prevOth nvarchar(10), curOth nvarchar(10),
					   prevEmployees nvarchar(10), curEmployees nvarchar(10)) 
 -------------> Преобразование и обнова для верочки данных <--------------       
		-- Religy
		DECLARE 
		@prevQtyRel_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_Rel where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_Rel where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		@curQtyRel_rs2 INT = 
		(select sum(isnull(cur_val,0)) from @tab_Rel where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_Rel where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),
		-- Center Power
		@prevQtyExPow_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_exPow where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_exPow where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		@curQtyExPow_rs2 INT = 
		(select sum(isnull(cur_val,0)) from @tab_exPow where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_exPow where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),
		-- Local Municipalitet
		@prevQtyLocMun_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_locMun where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_locMun where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		@curQtyLocMun_rs2 INT = 
		(select sum(isnull(cur_val,0)) from @tab_locMun where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_locMun where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),
		-- Local Power
		@prevQtyLocPow_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_locPow where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_locPow where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		@curQtyLocPow_rs2 INT = 
		(select sum(isnull(cur_val,0)) from @tab_locPow where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_locPow where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),
		-- Construction 
		@prevQtyCon_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_stCon where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_stCon where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		@curQtyCon_rs2 INT = 
		(select sum(isnull(cur_val,0)) from @tab_stCon where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_stCon where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),
		-- Other 
		@prevQtyOth_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_Oth where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_Oth where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		@curQtyOth_rs2 INT = 
		(select sum(isnull(cur_val,0)) from @tab_Oth where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_Oth where source in ('Сайт/моб. додаток','УГЛ','Телеефір') )

			  BEGIN

              UPDATE @tab_Rel 
              set prev_val = @prevQtyRel_rs2,
                  cur_val = @curQtyRel_rs2
              where source = 'Дзвінок в 1551'
              
              UPDATE @tab_exPow 
              set prev_val = @prevQtyExPow_rs2,
                  cur_val = @curQtyExPow_rs2
              where source = 'Дзвінок в 1551'

              UPDATE @tab_locMun 
              set prev_val = @prevQtyLocMun_rs2,
                  cur_val = @curQtyLocMun_rs2
			  where source = 'Дзвінок в 1551'

			  UPDATE @tab_locPow
              set prev_val = @prevQtyLocPow_rs2,
                  cur_val = @curQtyLocPow_rs2
              where source = 'Дзвінок в 1551'

			  UPDATE @tab_stCon
              set prev_val = @prevQtyCon_rs2,
                  cur_val = @curQtyCon_rs2
              where source = 'Дзвінок в 1551'

			  UPDATE @tab_Oth
              set prev_val = @prevQtyOth_rs2,
                  cur_val = @curQtyOth_rs2
              where source = 'Дзвінок в 1551'

	         END

begin
insert into @tab_Rel2 (source, prev_val, cur_val) 
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_Rel z
GROUP BY source

insert into @tab_exPow2 (source, prev_val, cur_val) 
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_exPow z
GROUP BY source

insert into @tab_locMun2 (source, prev_val, cur_val) 
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_locMun z
GROUP BY source

insert into @tab_locPow2 (source, prev_val, cur_val) 
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_locPow z
GROUP BY source

insert into @tab_stCon2 (source, prev_val, cur_val) 
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_stCon z
GROUP BY source

insert into @tab_Oth2 (source, prev_val, cur_val) 
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_Oth z
GROUP BY source

end

 -------------> Получить конечный результат <--------------
	              insert into @result 
				  select source_name, 
				  t_rel.prev_val prevRel, t_rel.cur_val curRel,
				  t_expow.prev_val prevResidential, t_expow.cur_val curResidential,
				  t_locmun.prev_val prevEcology, t_locmun.cur_val curEcology,
				  t_locpow.prev_val prevLaw, t_locpow.cur_val curLaw,
				  t_stcon.prev_val prevFamily, t_stcon.cur_val curFamily,
				  t_oth.prev_val prevSince, t_oth.cur_val curSince,
				  t_empl.prev_val prevEmployees, t_empl.cur_val curEmployees
			from #sources s
			inner join @tab_Rel2 t_rel on t_rel.[source] = s.source_name
			inner join @tab_exPow2 t_expow on t_expow.source = s.source_name
			inner join @tab_locMun2 t_locmun on t_locmun.source = s.source_name
			inner join @tab_locPow2 t_locpow on t_locpow.source = s.source_name
			inner join @tab_stCon2 t_stcon on t_stcon.source = s.source_name
			inner join @tab_Oth2 t_oth on t_oth.source = s.source_name
            inner join @tab_Employees t_empl on t_empl.sourse = s.source_name

end

-- select * FROM @result

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

     select 
	  s.row#,
    case when [source] = 'КБУ' then 'Питання, що надійшли до КБУ «Контактний центр міста Києва»'
	 when [source] = 'Дзвінок в 1551' then 'з них, через гарячу лінію 1551'
	 when [source] = 'Сайт/моб. додаток' then 'з них, через офіційний веб-портал та додатки для мобільних пристроїв'
	 when [source] = 'УГЛ' then 'з них, через ДУ «Урядовий контактний центр»'
	 when [source] = 'Телеефір' then 'з них, у рамках проекту «Прямий зв`язок з київською міською владаю»'
	 else '' end as 
	 [source],
	 IIF(prevRel = '0', '-', prevRel) prevReligy, IIF(curRel = '0', '-', curRel) curReligy,
	 IIF(prevExPow = '0', '-', prevExPow) prevCentralExecutePower, IIF(curExPow = '0', '-', curExPow) curCentralExecutePower,
	 IIF(prevLocMun = '0', '-', prevLocMun) prevLocalExecutePower, IIF(curLocMun = '0', '-', curLocMun) curLocalExecutePower,
	 IIF(prevLocPow = '0', '-', prevLocPow) prevLocalMunicipalitet, IIF(curLocPow = '0', '-', curLocPow) curLocalMunicipalitet,
	 IIF(prevStCon = '0', '-', prevStCon) prevStateConstruction, IIF(curStCon = '0', '-', curStCon) curStateConstruction,
	 IIF(prevOth = '0', '-', prevOth) prevOther, IIF(curOth = '0', '-', curOth) curOther,
	 IIF(prevEmployees = '0', '-', prevEmployees) prevEmployees, IIF(curEmployees = '0', '-', curEmployees) curEmployees
	 from @result r
	 inner join #sources s on r.source = s.source_name	 
	 order by row#