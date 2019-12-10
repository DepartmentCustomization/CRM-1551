--  declare @dateFrom datetime = '2019-01-01 00:00:00';
--  declare @dateTo datetime = current_timestamp;
--  declare @pos int = 8;

--declare @positions_t table (Id int, pos nvarchar(200))

if object_id('tempdb..#temp_OUT') is not null drop table #temp_OUT
create table #temp_OUT(
Id int identity(1,1),
GroupOrgId    int,
GroupOrgName nvarchar(max),
orgId     int,
orgName  nvarchar(max),
[Level] int,
Kolvo int
)

if object_id('tempdb..#temp_OUT_Child') is not null drop table #temp_OUT_Child
create table #temp_OUT_Child(
Id int identity(1,1),
GroupOrgId    int,
GrouporgName nvarchar(max),
orgId     int,
orgName  nvarchar(max),
[Level] int,
Kolvo int
)

--Generate Organization
DECLARE @OrganizationsRowId INT
DECLARE @CURSOR CURSOR
SET @CURSOR  = CURSOR SCROLL
FOR
  select distinct  organization_id from [dbo].[OrganizationInResponsibility] where position_id = @pos
OPEN @CURSOR
FETCH NEXT FROM @CURSOR INTO @OrganizationsRowId
WHILE @@FETCH_STATUS = 0
BEGIN

		;WITH  OrganizationsH (ParentId, Id, [Name], level) AS
		  (
		      SELECT parent_organization_id as ParentId, Id, short_name as [Name], 0
		      FROM [dbo].[Organizations]
		      WHERE Id = @OrganizationsRowId
		      UNION ALL
		    SELECT o.parent_organization_id as ParentId, o.Id, o.short_name as [Name], level + 1
		      FROM [dbo].Organizations o 
		      JOIN OrganizationsH h ON o.parent_organization_id = h.Id
		  )
		  insert into #temp_OUT (GroupOrgId, GroupOrgName, orgId, orgName, [Level])
		  SELECT @OrganizationsRowId, (select short_name 
		                               from Organizations 
									   where Id = @OrganizationsRowId),
									    Id, Name, level
		  FROM OrganizationsH

FETCH NEXT FROM @CURSOR INTO @OrganizationsRowId
END
CLOSE @CURSOR


if object_id('tempdb..#temp_OUT2') is not null drop table #temp_OUT2
create table #temp_OUT2(
Id int identity(1,1),
ParentId    int,
orgId     int,
orgName  nvarchar(max),
[Level] int
)

;WITH  OrganizationsH (ParentId, Id, [Name], level) AS
		  (
		      SELECT parent_organization_id as ParentId, Id, short_name as [Name], 0
		      FROM [dbo].[Organizations]
		      WHERE #filter_columns#
		      UNION ALL
		    SELECT o.parent_organization_id as ParentId, o.Id, o.short_name as [Name], level + 1
		      FROM [dbo].Organizations o 
		      JOIN OrganizationsH h ON o.parent_organization_id = h.Id
		  )
		 insert into #temp_OUT2 (ParentId, orgId, orgName, [Level])
		  SELECT ParentId, Id, [Name], level
		  FROM OrganizationsH

-----------------------------------
if object_id('tempdb..#temp_OUT_ForDelete') is not null drop table #temp_OUT_ForDelete
create table #temp_OUT_ForDelete(
Id int,
Rnk int)
insert into #temp_OUT_ForDelete (Id, Rnk)
select Id, RANK() OVER(PARTITION BY orgName ORDER BY [Level] desc) as rnk
from #temp_OUT
where orgId in (
	select orgId
	from #temp_OUT
	group by orgId
	having COUNT(1) > 1
	)

	delete from #temp_OUT where Id in (select Id from #temp_OUT_ForDelete where Rnk > 1)

/*ДЛЯ ТАБЛИЦЫ #temp_OUT (ПОЛЕ Kolvo) РАСЧИТАТЬ Questions для организаций из поля orgId*/

update #temp_OUT set Kolvo = isnull(z.questionQty,0)
from #temp_OUT
left join (
select o.Id, o.short_name as orgName, isnull(COUNT(q.Id),0) as questionQty
from Appeals a 
left join Questions q on q.appeal_id = a.Id
left join Assignments ass on ass.question_id = q.Id
left join Organizations o on o.Id = ass.executor_organization_id
where q.registration_date between @dateFrom and @dateTo
and o.Id in (select orgId from #temp_OUT)
group by o.Id, o.short_name
) z on z.Id = #temp_OUT.orgId


------------------------------------

/*FILTER
select orgId as [Id], orgName as [Name] 
from #temp_OUT
where GroupOrgId != orgId
*/

-- select * from #temp_OUT2

	insert into #temp_OUT_Child (GroupOrgId, GroupOrgName, orgId, orgName, Kolvo)
	select GroupOrgId, GroupOrgName, orgId, orgName, Kolvo
	from #temp_OUT
	where orgId in (select orgId from #temp_OUT2)

if (select COUNT(1) from #temp_OUT) != (select COUNT(1) from #temp_OUT_Child)
begin
	delete from #temp_OUT where orgId in (select orgId from #temp_OUT_Child)
	
	--insert into #temp_OUT (GroupOrgId, GrouporgName, orgId, orgName, Kolvo)
	--select orgId, orgName, orgId, orgName, Kolvo
	--from #temp_OUT_Child

	insert into #temp_OUT (GroupOrgId, GrouporgName, orgId, orgName)
	select top 1 orgId, orgName, orgId, orgName
	from #temp_OUT2 where [Level] = 0 


	update #temp_OUT set Kolvo = (select SUM(Kolvo) from #temp_OUT_Child)
	where orgId in (select top 1 orgId
					from #temp_OUT2 where [Level] = 0)

end

select GroupOrgId as orgId, GrouporgName as orgName, SUM(Kolvo) as questionQty 
from #temp_OUT
group by GroupOrgId, GrouporgName
order by questionQty desc