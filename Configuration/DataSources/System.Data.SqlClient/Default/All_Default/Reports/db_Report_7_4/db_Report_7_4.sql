declare @tab_Res table (source nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Eco table (source nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Com table (source nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Law table (source nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Fam table (source nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);
declare @tab_Sin table (source nvarchar(200) COLLATE Ukrainian_CI_AS, prev_val int, cur_val int);

-- declare @dateFrom date = '2019-05-05';
-- declare @dateTo date = cast(current_timestamp as date);

IF OBJECT_ID('tempdb..#sources') IS NOT NULL DROP TABLE #sources
CREATE TABLE #sources (
    row# nvarchar(3) null,
    source_name VARCHAR(MAX) COLLATE Ukrainian_CI_AS
);
begin
insert into #sources (source_name)
select name from ReceiptSources
where Id not in (4,5,6,7)
Union 
select  'КБУ'
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
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 11
and year(q.registration_date) = (select dateadd(year, -1, year(current_timestamp))) 
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@dateTo))
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 11 and 
year(registration_date) = (select dateadd(year, -1, year(current_timestamp)))
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@dateTo))) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) ComCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 11
and year(q.registration_date) = year(current_timestamp) 
and q.registration_date between @dateFrom and @dateTo
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 11 and 
year(registration_date) = year(current_timestamp)
and q.registration_date between @dateFrom and @dateTo
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
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 12
and year(q.registration_date) = (select dateadd(year, -1, year(current_timestamp))) 
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@dateTo))
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 12 and 
year(registration_date) = (select dateadd(year, -1, year(current_timestamp))) 
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@dateTo))) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) ResCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 12
and year(q.registration_date) = year(current_timestamp) 
and q.registration_date between @dateFrom and @dateTo
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 12 and 
year(registration_date) = year(current_timestamp)
and q.registration_date between @dateFrom and @dateTo) ss on ss.source_name = z.source_name
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
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 14
and year(q.registration_date) = (select dateadd(year, -1, year(current_timestamp)))
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@dateTo)) 
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 14 and 
year(registration_date) = (select dateadd(year, -1, year(current_timestamp))) 
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@dateTo))) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) EcoCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 14
and year(q.registration_date) = year(current_timestamp)
and q.registration_date between @dateFrom and @dateTo 
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 14 and 
year(registration_date) = year(current_timestamp)
and q.registration_date between @dateFrom and @dateTo) ss on ss.source_name = z.source_name
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
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 15
and year(q.registration_date) = (select dateadd(year, -1, year(current_timestamp)))
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@dateTo)) 
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 15 and 
year(registration_date) = (select dateadd(year, -1, year(current_timestamp))) 
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@dateTo))) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) LawCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 15
and year(q.registration_date) = year(current_timestamp) 
and q.registration_date between @dateFrom and @dateTo
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 15 and 
year(registration_date) = year(current_timestamp)
and q.registration_date between @dateFrom and @dateTo) ss on ss.source_name = z.source_name
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
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 16
and year(q.registration_date) = (select dateadd(year, -1, year(current_timestamp)))
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@dateTo)) 
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0)
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 16 and 
year(registration_date) = (select dateadd(year, -1, year(current_timestamp))) 
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@dateTo))) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) FamCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 16
and year(q.registration_date) = year(current_timestamp) 
and q.registration_date between @dateFrom and @dateTo
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 16 and 
year(registration_date) = year(current_timestamp)
and q.registration_date between @dateFrom and @dateTo) ss on ss.source_name = z.source_name
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
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 17
and year(q.registration_date) = (select dateadd(year, -1, year(current_timestamp)))
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@dateTo)) 
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 17 and 
year(registration_date) = (select dateadd(year, -1, year(current_timestamp))) 
and q.registration_date between dateadd(year, -1, year(@dateFrom))
and dateadd(year, -1, year(@dateTo))) s on s.source_name = z.source_name
-- Теперішній рік
left join (
select source_name, count(q.Id) SinCur
from #sources 
left join ReceiptSources rs on rs.name = #sources.source_name
left join Appeals a on a.receipt_source_id = rs.Id
left join Questions q on q.appeal_id = a.Id
				 left join QuestionTypes qt on qt.Id = q.question_type_id
				 left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = qt.Id
				 left join QuestionGroups qg on qg.Id = qgiqt.group_question_id
where group_question_id = 17
and year(q.registration_date) = year(current_timestamp)
and q.registration_date between @dateFrom and @dateTo 
group by #sources.source_name 
UNION
select 'КБУ' as source_name, isnull(count(q.Id),0) Val
from Questions q
left join QGroupIncludeQTypes qgiqt on qgiqt.type_question_id = q.question_type_id
where group_question_id = 17 and 
year(registration_date) = year(current_timestamp)
and q.registration_date between @dateFrom and @dateTo) ss on ss.source_name = z.source_name
end

begin
declare @result table (source nvarchar(200),
                       prevCommunal nvarchar(10), curCommunal nvarchar(10), prevResidential nvarchar(10),
					   curResidential nvarchar(10), prevEcology nvarchar(10), curEcology nvarchar(10),
					   prevLaw nvarchar(10), curLaw nvarchar(10), prevFamily nvarchar(10),
					   curFamily nvarchar(10), prevSince nvarchar(10), curSince nvarchar(10) ) 

	              insert into @result 
				  select source_name, 
				  t_com.prev_val prevCommunal, t_com.cur_val curCommunal,
				  t_res.prev_val prevResidential, t_res.cur_val curResidential,
				  t_eco.prev_val prevEcology, t_eco.cur_val curEcology,
				  t_law.prev_val prevLaw, t_law.cur_val curLaw,
				  t_fam.prev_val prevFamily, t_fam.cur_val curFamily,
				  t_sin.prev_val prevSince, t_sin.cur_val curSince
			from #sources s
			join @tab_Com t_com on t_com.[source] = s.source_name
			join @tab_Res t_res on t_res.source = s.source_name
			join @tab_Eco t_eco on t_eco.source = s.source_name
			join @tab_law t_law on t_law.source = s.source_name
			join @tab_Fam t_fam on t_fam.source = s.source_name
			join @tab_Sin t_sin on t_sin.source = s.source_name
 
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
 
     select
	 s.row#, case when [source] = 'КБУ' then 'Питання, що надійшли до КБУ «Контактний центр міста Києва»'
	 when [source] = 'Дзвінок в 1551' then 'з них, через гарячу лінію 1551'
	 when [source] = 'Сайт/моб. додаток' then 'з них, через офіційний веб-портал та додатки для мобільних пристроїв'
	 when [source] = 'УГЛ' then 'з них, через ДУ «Урядовий контактний центр»'
	 when [source] = 'Телеефір' then 'з них, у рамках проекту «Прямий зв`язок зкиївською міськоювладаю»'
	 else '' end as [source],
	 IIF(prevCommunal = '0', '-', prevCommunal) prevCommunal, IIF(curCommunal = '0', '-', curCommunal) curCommunal,
	 IIF(prevResidential = '0', '-', prevResidential) prevResidential, IIF(curResidential = '0', '-', curResidential) curResidential,
	 IIF(prevEcology = '0', '-', prevEcology) prevEcology, IIF(curEcology = '0', '-', curEcology) curEcology,
	 IIF(prevLaw = '0', '-', prevLaw) prevLaw, IIF(curLaw = '0', '-', curLaw) curLaw,
	 IIF(prevFamily = '0', '-', prevFamily) prevFamily, IIF(curFamily = '0', '-', curFamily) curFamily,
	 IIF(prevSince = '0', '-', prevSince) prevHealth, IIF(curSince = '0', '-', curSince) curSince
	 from @result r
	 join #sources s on r.source = s.source_name	 
	 order by row#