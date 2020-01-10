--   declare @dateFrom datetime = '2019-07-01 00:00:00';
--   declare @dateTo datetime = '2019-12-31 00:00:00';

-- declare @filterTo datetime = dateadd(second,59,(dateadd(minute,59,(dateadd(hour,23,cast(cast(dateadd(day,0,@dateTo) as date) as datetime))))));

declare @currentYear int = year(@dateFrom);
declare @previousYear int = year(@dateFrom)-1;

declare @dayNumStart int = datepart(dayofyear, @dateFrom);
declare @dayNumEnd int = datepart(dayofyear, @dateTo);

declare @tab_All table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Agr table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Trans table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Finance table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Social table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Work table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Health table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);

declare @tab_All2 table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Agr2 table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Trans2 table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Finance2 table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Social2 table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Work2 table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Health2 table (source nvarchar(200)COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);

IF OBJECT_ID('tempdb..#sources') IS NOT NULL DROP TABLE #sources
CREATE TABLE #sources (
    row# nvarchar(3) null,
    source_name VARCHAR(MAX) COLLATE Ukrainian_CI_AS
);
begin
insert into #sources (source_name)
select [name] 
from ReceiptSources
where Id not in (5,6,7)
Union 
select  'КБУ'

-- select * from #sources

end
--- По всім групам питань
begin 
insert into @tab_All ([source], prev_val, cur_val) 
-- Попередній рік
select z.source_name, isnull(AllPrev,0) AllPrev, isnull(AllCur,0) AllCur
from #sources z
left join (
select source_name, 
count(q.Id) AllPrev
from #sources 
join ReceiptSources rs on rs.name = #sources.source_name
join Appeals a on a.receipt_source_id = rs.Id
join Questions q on q.appeal_id = a.Id
where q.question_type_id is not null
		   and year(q.registration_date) = 
		   @previousYear
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
group by #sources.source_name 
UNION 
select 'КБУ' as source_name, isnull(count(Id),0)
from Questions q
where q.question_type_id is not null
		   and year(q.registration_date) = 
		   @previousYear
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
		   ) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) AllCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id is not null
		   and year(q.registration_date) = 
		                        @currentYear
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd 
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(Id),0) Val
from Questions q
where q.question_type_id is not null
		   and year(registration_date) = 
                               @currentYear
		   and datepart(dayofyear, q.registration_date) 
		   between 
		  @dayNumStart and @dayNumEnd
		  ) ss on ss.source_name = z.source_name
end

-- select * from @tab_All

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
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 5)
and year(q.registration_date) = 
		   @previousYear
           and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from Questions q
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 5) 
and year(q.registration_date) = 
		   @previousYear
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
		   ) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) AgrCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 5)
and year(q.registration_date) = 
		                        @currentYear
		   and datepart(dayofyear, q.registration_date) 
		   between 
		  @dayNumStart and @dayNumEnd
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 5) 
and year(registration_date) =  
                         @currentYear
		   and datepart(dayofyear, q.registration_date) 
		   between 
@dayNumStart and @dayNumEnd
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
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 6) 
and year(q.registration_date) = 
		   @previousYear
		   and datepart(dayofyear, q.registration_date) 
		   between 
           @dayNumStart and @dayNumEnd
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from Questions q
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 6) 
and year(q.registration_date) = 
		   @previousYear
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
		   ) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) TransCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 6) 
and year(q.registration_date) = 
                               @currentYear
		   and datepart(dayofyear, q.registration_date) 
		   between 
           @dayNumStart and @dayNumEnd
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 6) 
and year(registration_date) = 
                         @currentYear
	       and datepart(dayofyear, q.registration_date) 
		   between 
           @dayNumStart and @dayNumEnd
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
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 7) 
and year(q.registration_date) = 
		   @previousYear
           and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from Questions q
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 7)
and year(q.registration_date) = 
		   @previousYear
           and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
		   ) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) FinanceCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 7)
and year(q.registration_date) = 
                               @currentYear
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 7)
and year(registration_date) = 
                         @currentYear
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
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
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 8)
and year(q.registration_date) = 
		   @previousYear
           and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from Questions q
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 8)
and year(q.registration_date) = 
		   @previousYear
           and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
		   ) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) SocialCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 8)
and year(q.registration_date) = 
                              @currentYear
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 8)
and year(registration_date) = 
                         @currentYear
	       and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
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
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 9)
and year(q.registration_date) = 
		   @previousYear
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from Questions q
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 9) 
and year(q.registration_date) = 
		   @previousYear
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
		   ) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) WorkCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 9)
and year(q.registration_date) = 
                              @currentYear
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 9)
and year(registration_date) = 
                         @currentYear
	       and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
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
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 10) 
and year(q.registration_date) = 
		   @previousYear
           and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 10) 
and year(q.registration_date) = 
		   @previousYear
           and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
		   ) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) HealthCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 10)
and year(q.registration_date) = 
                              @currentYear
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   @dayNumStart and @dayNumEnd
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
where q.question_type_id in (select type_question_id from QGroupIncludeQTypes where group_question_id = 10) and 
year(registration_date) = 
                        @currentYear
	       and datepart(dayofyear, q.registration_date) 
		   between 
           @dayNumStart and @dayNumEnd
) ss on ss.source_name = z.source_name
end
--select * from @tab_Health

UPDATE @tab_All SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
--select * from @tab_All
UPDATE @tab_Agr SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
UPDATE @tab_Trans SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
--select * from @tab_Trans
UPDATE @tab_Finance SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
UPDATE @tab_Social SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
UPDATE @tab_Work SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
UPDATE @tab_Health SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
DELETE from #sources WHERE source_name = 'E-mail'

begin
declare @result table (source nvarchar(200), prevAll nvarchar(10), curAll nvarchar(10),
                       prevAgr nvarchar(10), curAgr nvarchar(10), prevTrans nvarchar(10),
					   curTrans nvarchar(10), prevFinance nvarchar(10), curFinance nvarchar(10),
					   prevSocial nvarchar(10), curSocial nvarchar(10), prevWork nvarchar(10),
					   curWork nvarchar(10), prevHealth nvarchar(10), curHealth nvarchar(10) ) 

  -------------> Преобразование и обнова для верочки данных <--------------       
		-- All
		DECLARE @prevQty_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_All where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_All where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		@curQty_rs2 INT = 
		(select sum(isnull(cur_val,0)) from @tab_All where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_All where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),
		-- Agr
		@prevQtyAgr_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_Agr where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_Agr where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		 @curQtyAgr_rs2 INT = 
		 (select sum(isnull(cur_val,0)) from @tab_Agr where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_Agr where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),
		-- Transport
		@prevQtyTran_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_Trans where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_Trans where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		 @curQtyTran_rs2 INT = 
		 (select sum(isnull(cur_val,0)) from @tab_Trans where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_Trans where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),
		-- Finance
		@prevQtyFin_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_Finance where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_Finance where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		@curQtyFin_rs2 INT = 
		 (select sum(isnull(cur_val,0)) from @tab_Finance where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_Finance where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),
		-- Social
		@prevQtySoc_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_Social where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_Social where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		@curQtySoc_rs2 INT = 
		 (select sum(isnull(cur_val,0)) from @tab_Social where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_Social where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),
		-- Work
		@prevQtyWork_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_Work where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_Work where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		@curQtyWork_rs2 INT = 
		 (select sum(isnull(cur_val,0)) from @tab_Work where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_Work where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),
		-- Health
		@prevQtyHeal_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_Health where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_Health where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		 @curQtyHeal_rs2 INT = 
		 (select sum(isnull(cur_val,0)) from @tab_Health where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_Health where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ) ;

	         BEGIN

              UPDATE @tab_All 
              set prev_val = @prevQty_rs2,
                  cur_val = @curQty_rs2
              where source = 'Дзвінок в 1551'
              
              UPDATE @tab_Agr 
              set prev_val = @prevQtyAgr_rs2,
                  cur_val = @curQtyAgr_rs2
              where source = 'Дзвінок в 1551'

              UPDATE @tab_Trans
              set prev_val = @prevQtyTran_rs2,
                  cur_val = @curQtyTran_rs2
			  where source = 'Дзвінок в 1551'

			  UPDATE @tab_Finance
              set prev_val = @prevQtyFin_rs2,
                  cur_val = @curQtyFin_rs2
              where source = 'Дзвінок в 1551'

			  UPDATE @tab_Social
              set prev_val = @prevQtySoc_rs2,
                  cur_val = @curQtySoc_rs2
              where source = 'Дзвінок в 1551'

			  UPDATE @tab_Work 
			  set prev_val = @prevQtyWork_rs2,
                  cur_val = @curQtyWork_rs2
              where source = 'Дзвінок в 1551'

			  UPDATE @tab_Health 
			  set prev_val = @prevQtyHeal_rs2,
                  cur_val = @curQtyHeal_rs2
              where source = 'Дзвінок в 1551'
	         END

begin
insert into @tab_All2 (source, prev_val, cur_val) 
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_All z
GROUP BY source
--select * from @tab_All2

insert into @tab_Agr2 (source, prev_val, cur_val) 
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_Agr z
GROUP BY source

insert into @tab_Trans2 (source, prev_val, cur_val) 
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_Trans z
GROUP BY source
--select * from @tab_Trans2

insert into @tab_Finance2 (source, prev_val, cur_val) 
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_Finance z
GROUP BY source

insert into @tab_Social2 (source, prev_val, cur_val) 
-- Попередній рік
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_Social z
GROUP BY source

--select * from @tab_Social2

insert into @tab_Work2 (source, prev_val, cur_val) 
-- Попередній рік
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_Work z
GROUP BY source
--select * from @tab_Work2

insert into @tab_Health2 (source, prev_val, cur_val) 
-- Попередній рік
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_Health z
GROUP BY source
--select * from @tab_Health2

end
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
			join @tab_All2 t_all on t_all.[source] = s.source_name
			join @tab_Agr2 t_agr on t_agr.[source] = s.source_name
			join @tab_Trans2 t_trans on t_trans.source = s.source_name
			join @tab_Finance2 t_fin on t_fin.source = s.source_name
			join @tab_Social2 t_soc on t_soc.source = s.source_name
			join @tab_Work2 t_work on t_work.source = s.source_name
			join @tab_Health2 t_heal on t_heal.source = s.source_name
 
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
	 else '' end as
	 [source],
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