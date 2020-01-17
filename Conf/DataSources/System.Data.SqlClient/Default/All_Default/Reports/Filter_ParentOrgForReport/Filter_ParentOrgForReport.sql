 --declare @dateFrom datetime = '2019-01-01 00:00:00';
 --declare @dateTo datetime = current_timestamp;
 --declare @pos int = 28;

--declare @positions_t table (Id int, pos nvarchar(200))

if object_id('tempdb..#temp_OUT') is not null drop table #temp_OUT
create table #temp_OUT(
Id int identity(1,1),
GroupOrgId    int,
GroupOrgName nvarchar(max),
OrgId     int,
OrgName  nvarchar(max),
[Level] int,
Kolvo int
)

if object_id('tempdb..#temp_OUT_Child') is not null drop table #temp_OUT_Child
create table #temp_OUT_Child(
Id int identity(1,1),
GroupOrgId    int,
GroupOrgName nvarchar(max),
OrgId     int,
OrgName  nvarchar(max),
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
		  insert into #temp_OUT (GroupOrgId, GroupOrgName, OrgId, OrgName, [Level])
		  SELECT @OrganizationsRowId, (select short_name 
		                               from Organizations 
									   where Id = @OrganizationsRowId),
									    Id, Name, level
		  FROM OrganizationsH

FETCH NEXT FROM @CURSOR INTO @OrganizationsRowId
END
CLOSE @CURSOR

-----------------------------------
if object_id('tempdb..#temp_OUT_ForDelete') is not null drop table #temp_OUT_ForDelete
create table #temp_OUT_ForDelete(
Id int,
Rnk int)
insert into #temp_OUT_ForDelete (Id, Rnk)
select Id, RANK() OVER(PARTITION BY OrgName ORDER BY [Level] desc) as rnk
from #temp_OUT
where OrgId in (
	select OrgId
	from #temp_OUT
	group by OrgId
	having COUNT(1) > 1
	)

	delete from #temp_OUT where Id in (select Id from #temp_OUT_ForDelete where Rnk > 1)

/*ДЛЯ ТАБЛИЦЫ #temp_OUT (ПОЛЕ Kolvo) РАСЧИТАТЬ Questions для организаций из поля OrgId*/



------------------------------------

select distinct OrgId as [Id], OrgName as [Name] 
from #temp_OUT
where GroupOrgId != OrgId
and	 #filter_columns#
  /*   #sort_columns#*/
  order by 2
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
