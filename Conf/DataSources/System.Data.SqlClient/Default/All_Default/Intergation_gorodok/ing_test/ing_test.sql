;with interg_streets 
as
(
select	
	ROW_NUMBER() over(order by new.id)  as id
	,case
		when new.id is null then 'DELETE'
		when old.id is null then 'INSERT'
		when new.name <>old.name then 'UPDATE'
		else 'no operation'
	end as operation
	,new.id as new_id
	,new.name as new_name
	,old.id as old_id
	,old.name as old_name
from [CRM_1551_GORODOK_Integrartion].[dbo].Gorodok_streets_old as old
full outer join [CRM_1551_GORODOK_Integrartion].[dbo].Gorodok_streets_new as new on new.id = old.id  
--order by  case 
--		case
--		when new.id is null then 'DELETE'
--		when old.id is null then 'INSERT'
--		when new.name <>old.name then 'UPDATE'
--		else 'no operation'
--	end 
--	when 'DELETE' then 1
--	when 'INSERT' then 2
--	when 'UPDATE' then 3
--	when 'no operation' then 4 end
)

select
      Id
	 ,operation
	 ,new_id
	 ,new_name
	 ,old_id
	 ,old_name
 from interg_streets
where operation not in ('no operation')




/*if OBJECT_ID ('tempdb..#old') is not null drop table #old
create table #old (Id int, Name nvarchar(200))
	insert into #old (Id, Name)
	select Id, name from [CRM_1551_GORODOK_Integrartion].[dbo].Gorodok_streets_old

--select * from #old


MERGE #old as old
USING [CRM_1551_GORODOK_Integrartion].[dbo].Gorodok_streets_new as new
on (new.Id = old.Id)
	WHEN MATCHED and old.name <> new.name THEN
		update set name = new.name
	WHEN NOT MATCHED THEN
		insert (Id, Name)
		values (new.id, new.Name)
	WHEN NOT MATCHED BY SOURCE THEN
		delete
	OUTPUT $action AS operation, 
		 Inserted.Id as new_id
		,Inserted.Name as new_name
		,Deleted.Id as old_id
		,Deleted.Name as old_name
	;

*/