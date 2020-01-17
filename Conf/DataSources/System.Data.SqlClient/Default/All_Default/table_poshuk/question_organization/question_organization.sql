--declare @user_Id nvarchar(128)=N'29796543-b903-48a6-9399-4840f6eac396';

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
	set @organization_id =(select id from @organization_table where n=@n);--2006;
	--declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';


	 --declare @Organization table(Id int);

	 set @OrganizationId = @organization_id;


	 -- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
	 insert into @IdT(Id)
	 select Id from [CRM_1551_Analitics].[dbo].[Organizations] 
	 where (Id=@OrganizationId or [parent_organization_id]=@OrganizationId) and Id not in (select Id from @IdT)

	 --  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
	 while (select count(id) from (select Id from [CRM_1551_Analitics].[dbo].[Organizations]
	 where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
	 and Id not in (select Id from @IdT)) q)!=0
	 begin

	 insert into @IdT
	 select Id from [CRM_1551_Analitics].[dbo].[Organizations]
	 where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
	 and Id not in (select Id from @IdT)
	 end 

	 insert into @Organization (Id)
	 select Id from @IdT;

	-- delete from @Organization;
    delete from @IdT;

set @n=@n+1;
end;

-- показать всех, кто в 1761 и роль администратора 7
-- подорганизации 1761 начало

declare @organization_id1761 int =1761;

declare @Organization1761 table(Id int);

declare @OrganizationId1761 int = @organization_id1761;


 declare @IdT1761 table (Id int);

 -- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
 insert into @IdT1761 (Id)
 select Id from [CRM_1551_Analitics].[dbo].[Organizations] 
 where (Id=@OrganizationId1761 or [parent_organization_id]=@OrganizationId1761) and Id not in (select Id from @IdT1761)

 --  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
 while (select count(id) from (select Id from [CRM_1551_Analitics].[dbo].[Organizations]
 where [parent_organization_id] in (select Id from @IdT1761) --or Id in (select Id from @IdT)
 and Id not in (select Id from @IdT1761)) q)!=0
 begin

 insert into @IdT1761 (Id)
 select Id from [CRM_1551_Analitics].[dbo].[Organizations]
 where [parent_organization_id] in (select Id from @IdT1761) --or Id in (select Id from @IdT)
 and Id not in (select Id from @IdT1761)
 end 

 insert into @Organization1761 (Id)
 select Id from @IdT1761;

 --select * from @Organization1761

-- 1761 конец
-- 7 начало
declare @ad int=
(select distinct d
  from
  (select case when [roles_id]=7 then 7 else null end d
  from [Workers]
  where [worker_user_id]=@user_id) t
  where d is not null)
-- 7 конец

if @ad=7 or exists(select Id from @Organization1761 where id in (select distinct organization_id
  from [Workers]
  where [worker_user_id]=@user_id))

	begin
		select Id, short_name
		from [Organizations]
		/**/where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only 
	end

else
	begin
		select [Organizations].Id, [Organizations].short_name
		from @Organization o inner join [Organizations] on o.Id=[Organizations].Id
	

/**/where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only 
end


-- --declare @user_Id nvarchar(128)=N'eb6d56d2-e217-45e4-800b-c851666ce795';

-- declare @organization_main table (Id int);

-- declare @organization_table table (Id int, n int identity(1,1));
-- declare @n int=1;

-- declare @organization_id int;
-- declare @Organization table(Id int, Id_n int);
-- declare @OrganizationId int;
-- declare @IdT table (Id int, Id_n int identity(1,1));

-- insert into @organization_table(Id)
--  select distinct [organization_id]
--   from [Workers]
--   where worker_user_id=@user_id;
 

-- while exists(select id from @organization_table where n=@n)
-- begin
-- 	set @organization_id =(select id from @organization_table where n=@n);--2006;
-- 	--declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';


-- 	 --declare @Organization table(Id int);

-- 	 set @OrganizationId = @organization_id;


-- 	 -- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
-- 	 insert into @IdT(Id)
-- 	 select Id from [CRM_1551_Analitics].[dbo].[Organizations] 
-- 	 where (Id=@OrganizationId or [parent_organization_id]=@OrganizationId) and Id not in (select Id from @IdT)

-- 	 --  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
-- 	 while (select count(id) from (select Id from [CRM_1551_Analitics].[dbo].[Organizations]
-- 	 where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
-- 	 and Id not in (select Id from @IdT)) q)!=0
-- 	 begin

-- 	 insert into @IdT
-- 	 select Id from [CRM_1551_Analitics].[dbo].[Organizations]
-- 	 where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
-- 	 and Id not in (select Id from @IdT)
-- 	 end 

-- 	 insert into @Organization (Id)
-- 	 select Id from @IdT;

-- 	-- delete from @Organization;
--     delete from @IdT;

-- set @n=@n+1;
-- end

-- select [Organizations].Id, [Organizations].short_name
-- from @Organization o inner join [Organizations] on o.Id=[Organizations].Id
-- where #filter_columns#
--   #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only


--declare @user_id nvarchar(128)=N'eb6d56d2-e217-45e4-800b-c851666ce795'


-- declare @organization_id int =(select top 1 organization_id
--   from [Workers]
--   where [worker_user_id]=@user_id);--2006;
-- --declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';


--  declare @Organization table(Id int);

--  declare @OrganizationId int = @organization_id;


--  declare @IdT table (Id int);

--  -- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
--  insert into @IdT(Id)
--  select Id from [CRM_1551_Analitics].[dbo].[Organizations] 
--  where (Id=@OrganizationId or [parent_organization_id]=@OrganizationId) and Id not in (select Id from @IdT)

--  --  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
--  while (select count(id) from (select Id from [CRM_1551_Analitics].[dbo].[Organizations]
--  where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
--  and Id not in (select Id from @IdT)) q)!=0
--  begin

--  insert into @IdT
--  select Id from [CRM_1551_Analitics].[dbo].[Organizations]
--  where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
--  and Id not in (select Id from @IdT)
--  end 

--  insert into @Organization (Id)
--  select Id from @IdT;

--  select [Organizations].Id, [Organizations].short_name
--  from @Organization o inner join [Organizations] on o.Id=[Organizations].Id
--   where #filter_columns#
--   #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only


-- --   SELECT [Id]
-- --       ,[short_name]
-- --   FROM [CRM_1551_Analitics].[dbo].[Organizations]
  
-- --     where 
-- --     #filter_columns#
-- --     #sort_columns#
-- --     offset @pageOffsetRows rows fetch next @pageLimitRows rows only