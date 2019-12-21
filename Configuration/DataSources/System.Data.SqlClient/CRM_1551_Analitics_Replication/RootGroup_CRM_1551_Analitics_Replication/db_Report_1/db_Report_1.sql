declare @opers table (Id nvarchar(300), full_name nvarchar(300)); 
declare @questions_value table(qty int, oper_id nvarchar(300) );
declare @assignments_value table(qty int, oper_id nvarchar(300) );
declare @assignments_done table(qty int, oper_id nvarchar(300) );
declare @assignments_rework table(qty int, oper_id nvarchar(300) );
declare @assignments_notCall table(qty int, oper_id nvarchar(300) );

-- declare @dateFrom datetime = '2019-10-15 00:00:00';
-- declare @dateTo datetime = current_timestamp;

insert into @opers(Id, full_name)
select UserId, LastName + isnull(' ' + FirstName, N'') + isnull(' ' + Patronymic,N'')
from [#system_database_name#].[dbo].[User]

-- получить количество по Questions
insert into @questions_value (qty, oper_id)
select count(Id), user_edit_id
from Questions q
where edit_date between @dateFrom and @dateTo 
group by user_edit_id
-- получить количество по Assignments
insert into @assignments_value (qty, oper_id)
select count(Id), user_edit_id 
from Assignments 
where edit_date between @dateFrom and @dateTo     
group by user_edit_id
-- получить количество по Assignments где результат "Виконано"
insert into @assignments_done (qty, oper_id)
select count(Id), user_edit_id  
from Assignments
where edit_date  between @dateFrom and @dateTo 
and AssignmentResultsId = 4    
group by user_edit_id 
-- получить количество по Assignments где результат "На доопрацювання"
insert into @assignments_rework (qty, oper_id)
select count(Id), user_edit_id 
from Assignments
where edit_date between @dateFrom and @dateTo 
and AssignmentResultsId = 5    
group by user_edit_id
-- получить количество по недозвонах
insert into @assignments_notCall (qty, oper_id)
select count(missed_call_counter), user_edit_id
from Logging_AssignmentRevisions
where edit_date between @dateFrom and @dateTo
group by user_edit_id

 select ROW_NUMBER() OVER(ORDER BY qv.qty DESC) as Id,
            o.Id as operId,
            full_name as oper, 
	        isnull(qv.qty, 0) as questionQ,
			isnull(av.qty, 0) as assignmentQ,
			isnull(ad.qty, 0) as doneQ,
			isnull(ar.qty, 0) as reworkQ,
			isnull(anc.qty, 0) as notCallQ
	 from @opers o
	 left join @questions_value qv on qv.oper_id = o.Id 
	 left join @assignments_value av on av.oper_id = o.Id
	 left join @assignments_done ad on ad.oper_id = o.Id
	 left join @assignments_rework ar on ar.oper_id = o.Id
	 left join @assignments_notCall anc on anc.oper_id = o.Id

	 where #filter_columns#
	 order by (qv.qty + av.qty) desc
