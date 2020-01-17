   /* 
  declare @Street_Id nvarchar(max) =N'436,228';
  declare @user_Id nvarchar(128)=N'45d2f527-bd52-47ef-bc6c-4e0943d8e3334';
  declare @pageOffsetRows int=0;
  declare @pageLimitRows int=10;
*/
  --
  -- наша входная строка с айдишниками


declare @input_str nvarchar(100) = replace(@Street_Id, N' ', N'')+N','
 
-- создаем таблицу в которую будем
-- записывать наши айдишники
declare @table table (id int)
 
-- создаем переменную, хранящую разделитель
declare @delimeter nvarchar(1) = ','
 
-- определяем позицию первого разделителя
declare @pos int = charindex(@delimeter,@input_str)
 
-- создаем переменную для хранения
-- одного айдишника
declare @id nvarchar(10)
    
while (@pos != 0)
begin
    -- получаем айдишник
    set @id = SUBSTRING(@input_str, 1, @pos-1)
    -- записываем в таблицу
    insert into @table (id) values(cast(@id as int))
    -- сокращаем исходную строку на
    -- размер полученного айдишника
    -- и разделителя
    set @input_str = SUBSTRING(@input_str, @pos+1, LEN(@input_str))
    -- определяем позицию след. разделителя
    set @pos = CHARINDEX(@delimeter,@input_str)
end;

--select * from @table
  --



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
  ---

  if exists(
  		select [Id], [number] [name]
	  from 
	  (SELECT [Buildings].[Id]
		  ,[StreetTypes].shortname+[Streets].name+N', буд.'+[Buildings].[name] [number]
	  FROM [Buildings]
	  left join [Streets] on [Buildings].street_id=[Streets].Id
	  left join [StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
	  inner join (select [Districts].Id
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
	  where o.parent_organization_id=3) t on [Buildings].district_id=t.Id
	  where 
		[street_id] in (select Id from @table)) q
  )
  begin

		select [Id], [number] [name]
	  from 
	  (SELECT [Buildings].[Id]
		  ,[StreetTypes].shortname+[Streets].name+N', буд.'+[Buildings].[name] [number]
	  FROM [Buildings]
	  left join [Streets] on [Buildings].street_id=[Streets].Id
	  left join [StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
	  inner join (select [Districts].Id
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
	  where o.parent_organization_id=3) t on [Buildings].district_id=t.Id
	  where 
		[street_id] in (select Id from @table)) q
	  where #filter_columns#
	 -- #sort_columns#
	 order by name
	 offset @pageOffsetRows rows fetch next @pageLimitRows rows only

 end
 
 else
	begin

	select [Id], [number] [name]
	  from 
	  (SELECT [Buildings].[Id]
		  ,[StreetTypes].shortname+[Streets].name+N', буд.'+[Buildings].[name] [number]
	  FROM [Buildings]
	  left join [Streets] on [Buildings].street_id=[Streets].Id
	  left join [StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
	  where 
		[street_id] in (select Id from @table)) q
	  where #filter_columns#
	 -- #sort_columns#
	 order by name
	 offset @pageOffsetRows rows fetch next @pageLimitRows rows only

	end


  /* 
  declare @Street_Id nvarchar(max) =N'2,54';
  declare @pageOffsetRows int=0;
  declare @pageLimitRows int=10;

*/
  --
  -- наша входная строка с айдишниками


-- declare @input_str nvarchar(100) = replace(@Street_Id, N' ', N'')+N','
 
-- -- создаем таблицу в которую будем
-- -- записывать наши айдишники
-- declare @table table (id int)
 
-- -- создаем переменную, хранящую разделитель
-- declare @delimeter nvarchar(1) = ','
 
-- -- определяем позицию первого разделителя
-- declare @pos int = charindex(@delimeter,@input_str)
 
-- -- создаем переменную для хранения
-- -- одного айдишника
-- declare @id nvarchar(10)
    
-- while (@pos != 0)
-- begin
--     -- получаем айдишник
--     set @id = SUBSTRING(@input_str, 1, @pos-1)
--     -- записываем в таблицу
--     insert into @table (id) values(cast(@id as int))
--     -- сокращаем исходную строку на
--     -- размер полученного айдишника
--     -- и разделителя
--     set @input_str = SUBSTRING(@input_str, @pos+1, LEN(@input_str))
--     -- определяем позицию след. разделителя
--     set @pos = CHARINDEX(@delimeter,@input_str)
-- end

-- --select * from @table
--   --




-- 	select [Id], [number] [name]
--   from 
--   (SELECT [Buildings].[Id]
--       ,[StreetTypes].shortname+[Streets].name+N', буд.'+[Buildings].[name] [number]
--   FROM [Buildings]
--   left join [Streets] on [Buildings].street_id=[Streets].Id
--   left join [StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
--   where 
--     [street_id] in (select Id from @table)) q
--      where #filter_columns#
--   #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only
