

--declare @user_Id nvarchar(128)=N'45d2f527-bd52-47ef-bc6c-4e0943d8e333';

declare @organization_main table (Id int);

declare @organization_table table (Id int, n int identity(1,1));
declare @n int=1;

declare @organization_id int;
declare @Organization table(Id int, Id_n int);
declare @OrganizationId int;
declare @IdT table (Id int, Id_n int identity(1,1));

insert into @organization_table(Id)
 select distinct [organization_id]
  from [Workers]
  where worker_user_id=@user_id;

while exists(select id from @organization_table where n=@n)
begin

set @organization_id=(select id from @organization_table where n=@n);

--declare @Organization table(Id int, Id_n int);

set @OrganizationId =  @organization_id;

--declare @IdT table (Id int, Id_n int identity(1,1));

insert into @IdT(Id) select @OrganizationId

while (select [parent_organization_id] from [CRM_1551_Analitics].[dbo].[Organizations] where Id=(select top 1 Id from @IdT order by Id_n desc)) is not null

begin 
-- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
insert into @IdT(Id)
select [parent_organization_id] from [CRM_1551_Analitics].[dbo].[Organizations] 
where Id=(select top 1 Id from @IdT order by Id_n desc) --and Id not in (select Id from @IdT)



end

insert into @organization_main
select id from @IdT;

delete from @Organization;
delete from @IdT;

set @n=@n+1;
end


--select * from @organization_main
if exists
(
select [Districts].Id, [Districts].name
from @organization_main i inner join [Organizations] o on i.Id=o.Id
inner join [Districts] on (
case when o.Id=2000 then 1
when o.Id=2001 then 2
when o.Id=2002 then 3
when o.Id=2003 then 4
when o.Id=2004 then 5
when o.Id=2005 then 6
when o.Id=2006 then 7
when o.Id=2007 then 8
when o.Id=2008 then 9
when o.Id=2009 then 10
end
)=[Districts].Id
  where o.parent_organization_id=3)

begin 
	select [Districts].Id, [Districts].name
	from @organization_main i inner join [Organizations] o on i.Id=o.Id
	inner join [Districts] on (
	case when o.Id=2000 then 1
	when o.Id=2001 then 2
	when o.Id=2002 then 3
	when o.Id=2003 then 4
	when o.Id=2004 then 5
	when o.Id=2005 then 6
	when o.Id=2006 then 7
	when o.Id=2007 then 8
	when o.Id=2008 then 9
	when o.Id=2009 then 10
	end
	)=[Districts].Id
	  where o.parent_organization_id=3 and
	  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
end

else 
begin
	select Id, name
	from [Districts]
	where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
end

 --and #filter_columns#
 -- #sort_columns#
 --offset @pageOffsetRows rows fetch next @pageLimitRows rows only


  /*
SELECT TOP (1000) [Id]
      ,[name]
  FROM [CRM_1551_Analitics].[dbo].[Districts]


  select Id, name, short_name
  FROM [CRM_1551_Analitics].[dbo].[Organizations]
  where parent_organization_id=3
  */


-- SELECT [Id]
--       ,[name]
--   FROM [CRM_1551_Analitics].[dbo].[Districts]
  
--   where #filter_columns#
  
--   #sort_columns#
--   offset @pageOffsetRows rows fetch next @pageLimitRows rows only