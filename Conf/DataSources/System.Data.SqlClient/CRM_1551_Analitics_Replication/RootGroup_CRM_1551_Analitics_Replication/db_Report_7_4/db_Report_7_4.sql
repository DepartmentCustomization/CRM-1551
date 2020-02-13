-- declare @dateFrom datetime = '2019-07-01 00:00:00';
-- declare @dateTo datetime = '2019-12-31 00:00:00';

--declare @filterTo datetime = dateadd(second,59,(dateadd(minute,59,(dateadd(hour,23,cast(cast(dateadd(day,0,@dateTo) as date) as datetime))))));

declare @currentYear int = year(@dateFrom);
declare @previousYear int = year(@dateFrom)-1;

declare @tab_Com table (source nvarchar(200) COLLATE DATABASE_DEFAULT, prev_val int, cur_val int);
declare @tab_Res table (source nvarchar(200) COLLATE DATABASE_DEFAULT, prev_val int, cur_val int);
declare @tab_Eco table (source nvarchar(200) COLLATE DATABASE_DEFAULT, prev_val int, cur_val int);
declare @tab_Law table (source nvarchar(200) COLLATE DATABASE_DEFAULT, prev_val int, cur_val int);
declare @tab_Fam table (source nvarchar(200) COLLATE DATABASE_DEFAULT, prev_val int, cur_val int);
declare @tab_Sin table (source nvarchar(200) COLLATE DATABASE_DEFAULT, prev_val int, cur_val int);

declare @tab_Com2 table (source nvarchar(200) COLLATE DATABASE_DEFAULT, prev_val int, cur_val int);
declare @tab_Res2 table (source nvarchar(200) COLLATE DATABASE_DEFAULT, prev_val int, cur_val int);
declare @tab_Eco2 table (source nvarchar(200) COLLATE DATABASE_DEFAULT, prev_val int, cur_val int);
declare @tab_Law2 table (source nvarchar(200) COLLATE DATABASE_DEFAULT, prev_val int, cur_val int);
declare @tab_Fam2 table (source nvarchar(200) COLLATE DATABASE_DEFAULT, prev_val int, cur_val int);
declare @tab_Sin2 table (source nvarchar(200) COLLATE DATABASE_DEFAULT, prev_val int, cur_val int);

IF OBJECT_ID('tempdb..#sources') IS NOT NULL DROP TABLE #sources
CREATE TABLE #sources (
    source_name VARCHAR(MAX) COLLATE Ukrainian_CI_AS,
	row# nvarchar(3) null
);
begin
insert into #sources 
(source_name)
select name 
from ReceiptSources 
where Id not in (5,6,7)
Union 
select  'КБУ'

UPDATE #sources
set row# = case [source_name]
                  when 'КБУ' then '1.'
                  when 'Дзвінок в 1551' then '1.1'
				  when 'Сайт/моб. додаток' then '1.2'
				  when 'УГЛ' then '1.3'
                  when 'Телеефір' then '1.4'
end

--select * from #sources
end

--- Комунального господарства
begin 
insert into @tab_Com (source, prev_val, cur_val) 
-- Попередній рік
select z.source_name, isnull(ComPrev,0) ComPrev, isnull(ComCur,0) ComCur
from #sources z
left join (
select source_name, count(q.Id) ComPrev
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 11 )
and year(q.registration_date) = @previousYear                       
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 11)
and year(q.registration_date) = @previousYear
		   and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo) 
		   ) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) ComCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 11 )
and year(q.registration_date) = @currentYear
           and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
 where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 11 ) 
and year(q.registration_date) = @currentYear
           and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
) ss on ss.source_name = z.source_name
end
--- Житлової політики
begin 
insert into @tab_Res (source, prev_val, cur_val) 
-- Попередній рік
select z.source_name, isnull(ResPrev,0) ResPrev, isnull(ResCur,0) ResCur
from #sources z
left join (
select source_name, count(q.Id) ResPrev
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 12)
and year(q.registration_date) = @previousYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 12)
and year(q.registration_date) = @previousYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) ResCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 12 )
and year(q.registration_date) = @currentYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 12) 
and year(q.registration_date) = @currentYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
		   ) ss on ss.source_name = z.source_name
end
--- Екології та природних ресурсів
begin 
insert into @tab_Eco (source, prev_val, cur_val) 
-- Попередній рік
select z.source_name, isnull(EcoPrev,0) EcoPrev, isnull(EcoCur,0) EcoCur
from #sources z
left join (
select source_name, count(q.Id) EcoPrev
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 14 )
and year(q.registration_date) = @previousYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 14 ) 
and year(q.registration_date) = @previousYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
		   ) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) EcoCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 14 )
and year(q.registration_date) = @currentYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 14 ) 
and year(q.registration_date) = @currentYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo) 
		   ) ss on ss.source_name = z.source_name
end
--- Забезпечення дотримання законності та охорони правопорядку, запобігання дискримінації
begin 
insert into @tab_Law (source, prev_val, cur_val) 
-- Попередній рік
select z.source_name, isnull(LawPrev,0) LawPrev, isnull(LawCur,0) LawCur
from #sources z
left join (
select source_name, count(q.Id) LawPrev
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 15 )
and year(q.registration_date) = @previousYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 15 ) and 
year(q.registration_date) = @previousYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
		   ) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) LawCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 15 )
and year(q.registration_date) = @currentYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 15 ) 
and year(q.registration_date) = @currentYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
		   ) ss on ss.source_name = z.source_name
end
--- Сімейної та гендерної політики, захисту прав дітей
begin 
insert into @tab_Fam (source, prev_val, cur_val) 
-- Попередній рік
select z.source_name, isnull(FamPrev,0) FamPrev, isnull(FamCur,0) FamCur
from #sources z
left join (
select source_name, count(q.Id) FamPrev
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 16 )
and year(q.registration_date) = @previousYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 16 ) 
and year(q.registration_date) = @previousYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
		   ) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) FamCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 16 )
and year(q.registration_date) = @currentYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 16 ) and 
year(q.registration_date) = @currentYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
		   ) ss on ss.source_name = z.source_name
end
--- Освіти, наукової, науково-технічної, інноваційної діяльності та інтелектуальної власності
begin 
insert into @tab_Sin (source, prev_val, cur_val) 
-- Попередній рік
select z.source_name, isnull(SinPrev,0) SinPrev, isnull(SinCur,0) SinCur
from #sources z
left join (
select source_name, count(q.Id) SinPrev
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 17 )
and year(q.registration_date) = @previousYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 17 ) 
and year(q.registration_date) = @previousYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) SinCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 17 )
and year(q.registration_date) = @currentYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
where q.question_type_id in ( select type_question_id from QGroupIncludeQTypes where group_question_id = 17 ) 
and year(q.registration_date) = @currentYear
and datepart(dayofyear, q.registration_date) 
		   between 
		   datepart(dayofyear, @dateFrom) 
		   and datepart(dayofyear, @dateTo)
		   ) ss on ss.source_name = z.source_name
end

UPDATE @tab_Com SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
UPDATE @tab_Res SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
UPDATE @tab_Eco SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
UPDATE @tab_Law SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
UPDATE @tab_Fam SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
UPDATE @tab_Sin SET source = 'Сайт/моб. додаток' WHERE source = 'E-mail'
DELETE from #sources WHERE source_name = 'E-mail'

begin
declare @result table (source nvarchar(200), row# nvarchar(3),
                       prevCommunal nvarchar(10), curCommunal nvarchar(10), prevResidential nvarchar(10),
					   curResidential nvarchar(10), prevEcology nvarchar(10), curEcology nvarchar(10),
					   prevLaw nvarchar(10), curLaw nvarchar(10), prevFamily nvarchar(10),
					   curFamily nvarchar(10), prevSince nvarchar(10), curSince nvarchar(10) ) 
-------------> Преобразование и обнова для верочки данных <--------------     
     -- Communal
		DECLARE
		@prevQtyCom_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_Com where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_Com where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		 @curQtyCom_rs2 INT = 
		 (select sum(isnull(cur_val,0)) from @tab_Com where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_Com where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),
	 -- Residential
	     @prevQtyRes_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_Res where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_Res where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		 @curQtyRes_rs2 INT = 
		 (select sum(isnull(cur_val,0)) from @tab_Res where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_Res where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),
     -- Ecology
	     @prevQtyEco_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_Eco where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_Eco where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		 @curQtyEco_rs2 INT = 
		 (select sum(isnull(cur_val,0)) from @tab_Eco where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_Eco where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ), 
     -- Law
	    @prevQtyLaw_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_Law where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_Law where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		 @curQtyLaw_rs2 INT = 
		 (select sum(isnull(cur_val,0)) from @tab_Law where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_Law where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ), 
	 -- Family
	    @prevQtyFam_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_Fam where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_Fam where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		 @curQtyFam_rs2 INT =  
		 (select sum(isnull(cur_val,0)) from @tab_Fam where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_Fam where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ), 
     -- Science
	     @prevQtySin_rs2 INT = 
		(select sum(isnull(prev_val,0)) from @tab_Sin where source in ('КБУ') )
		- (select sum(isnull(prev_val,0)) from @tab_Sin where source in ('Сайт/моб. додаток','УГЛ','Телеефір') ),

		 @curQtySin_rs2 INT =  
		 (select sum(isnull(cur_val,0)) from @tab_Sin where source in ('КБУ') )
		- (select sum(isnull(cur_val,0)) from @tab_Sin where source in ('Сайт/моб. додаток','УГЛ','Телеефір') )

		BEGIN

              UPDATE @tab_Com 
              set prev_val = @prevQtyCom_rs2,
                  cur_val = @curQtyCom_rs2
              where source = 'Дзвінок в 1551'
              
              UPDATE @tab_Res 
              set prev_val = @prevQtyRes_rs2,
                  cur_val = @curQtyRes_rs2
              where source = 'Дзвінок в 1551'

              UPDATE @tab_Eco
              set prev_val = @prevQtyEco_rs2,
                  cur_val = @curQtyEco_rs2
			  where source = 'Дзвінок в 1551'

			  UPDATE @tab_Law
              set prev_val = @prevQtyLaw_rs2,
                  cur_val = @curQtyLaw_rs2
              where source = 'Дзвінок в 1551'

			  UPDATE @tab_Fam
              set prev_val = @prevQtyFam_rs2,
                  cur_val = @curQtyFam_rs2
              where source = 'Дзвінок в 1551'

			  UPDATE @tab_Sin 
			  set prev_val = @prevQtySin_rs2,
                  cur_val = @curQtySin_rs2
              where source = 'Дзвінок в 1551'
	         END

begin
insert into @tab_Com2 (source, prev_val, cur_val) 
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_Com z
GROUP BY source

insert into @tab_Res2 (source, prev_val, cur_val) 
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_Res z
GROUP BY source

insert into @tab_Eco2 (source, prev_val, cur_val) 
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_Eco z
GROUP BY source

insert into @tab_Law2 (source, prev_val, cur_val) 
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_Law z
GROUP BY source

insert into @tab_Fam2 (source, prev_val, cur_val) 
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_Fam z
GROUP BY source

insert into @tab_Sin2 (source, prev_val, cur_val) 
select source, sum(prev_val) prev_val, sum(cur_val) cur_val
from @tab_Sin z
GROUP BY source

end

 -------------> Получить конечный результат <--------------
	              insert into @result 
				  select 
				  source_name,    
				  row#,
				  t_com.prev_val prevCommunal, t_com.cur_val curCommunal,
				  t_res.prev_val prevResidential, t_res.cur_val curResidential,
				  t_eco.prev_val prevEcology, t_eco.cur_val curEcology,
				  t_law.prev_val prevLaw, t_law.cur_val curLaw,
				  t_fam.prev_val prevFamily, t_fam.cur_val curFamily,
				  t_sin.prev_val prevSince, t_sin.cur_val curSince
			from #sources s
			join @tab_Com2 t_com on t_com.[source] = s.source_name
			join @tab_Res2 t_res on t_res.source = s.source_name
			join @tab_Eco2 t_eco on t_eco.source = s.source_name
			join @tab_law2 t_law on t_law.source = s.source_name
			join @tab_Fam2 t_fam on t_fam.source = s.source_name
			join @tab_Sin2 t_sin on t_sin.source = s.source_name
 
end

     select 
     row#,
     case when [source] = 'КБУ' then 'Питання, що надійшли до КБУ «Контактний центр міста Києва»'
	 when [source] = 'Дзвінок в 1551' then 'з них, через гарячу лінію 1551'
	 when [source] = 'Сайт/моб. додаток' then 'з них, через офіційний веб-портал та додатки для мобільних пристроїв'
	 when [source] = 'УГЛ' then 'з них, через ДУ «Урядовий контактний центр»'
	 when [source] = 'Телеефір' then 'з них, у рамках проекту «Прямий зв`язок з київською міською владаю»'
	 else '' end as
	 [source],
	 IIF(prevCommunal = '0', '-', prevCommunal) prevCommunal, IIF(curCommunal = '0', '-', curCommunal) curCommunal,
	 IIF(prevResidential = '0', '-', prevResidential) prevResidential, IIF(curResidential = '0', '-', curResidential) curResidential,
	 IIF(prevEcology = '0', '-', prevEcology) prevEcology, IIF(curEcology = '0', '-', curEcology) curEcology,
	 IIF(prevLaw = '0', '-', prevLaw) prevLaw, IIF(curLaw = '0', '-', curLaw) curLaw,
	 IIF(prevFamily = '0', '-', prevFamily) prevFamily, IIF(curFamily = '0', '-', curFamily) curFamily,
	 IIF(prevSince = '0', '-', prevSince) prevHealth, IIF(curSince = '0', '-', curSince) curSince
	 from @result	 
	 order by row#