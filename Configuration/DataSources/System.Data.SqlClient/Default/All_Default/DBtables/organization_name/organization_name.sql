

--  declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
--  declare @OrganizationId int =2006;
declare @distribute int;



declare @Organization table(Id int, [programworker] int);



--declare @OrganizationId int = @organization_id


declare @IdT table (Id int, [programworker] int);

-- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
insert into @IdT(Id, [programworker])
select Id, [programworker] from [CRM_1551_Analitics].[dbo].[Organizations] 
where (/*Id=@OrganizationId or */[parent_organization_id]=@OrganizationId) /*and programworker=N'true'*/ and Id not in (select Id from @IdT)

--  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ
while (select count(id) from (select Id from [CRM_1551_Analitics].[dbo].[Organizations]
where [parent_organization_id] in (select Id from @IdT) --and programworker=N'true' --or Id in (select Id from @IdT) 
and Id not in (select Id from @IdT)) q)!=0
begin

insert into @IdT (Id, [programworker])
select Id, [programworker] from [CRM_1551_Analitics].[dbo].[Organizations]
where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
and Id not in (select Id from @IdT) --and programworker=N'true'
end 

insert into @Organization (Id, [programworker])
select Id, [programworker] from @IdT where [programworker]=1;

--select * from @Organization 


if exists
(
select o.Id, [Organizations].short_name
from @Organization o left join [Organizations] on o.Id=[Organizations].Id)
begin
  set @distribute=1
end




if @organizationId is null
	begin
		select [Organizations].Id OrganizationId, [Organizations].short_name OrganizationName, @distribute Distribute
		from [CRM_1551_Analitics].[dbo].[Workers] inner join [CRM_1551_Analitics].[dbo].[Organizations] on Workers.organization_id=[Organizations].Id
		where worker_user_id=@user_id
	end
else
	begin
		select [Organizations].Id OrganizationId, [Organizations].short_name OrganizationName, @distribute Distribute
		from [CRM_1551_Analitics].[dbo].[Organizations]
		where [Organizations].Id=@organizationId
	end;








-- -- declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
-- -- declare @organizationId int =200;
-- declare @distribute int;


-- if exists
-- (
-- select id
-- from [CRM_1551_Analitics].[dbo].[Organizations]
-- where [parent_organization_id]=@organizationId and [programworker]=N'true')

-- begin
-- set @distribute=1
-- end




--if @organizationId is null
--	begin
--		select [Organizations].Id OrganizationId, [Organizations].short_name OrganizationName, @distribute Distribute
--		from [CRM_1551_Analitics].[dbo].[Workers] inner join [CRM_1551_Analitics].[dbo].[Organizations] on Workers.organization_id=[Organizations].Id
--		where worker_user_id=@user_id
--	end
--else
--	begin
--		select [Organizations].Id OrganizationId, [Organizations].short_name OrganizationName, @distribute Distribute
--		from [CRM_1551_Analitics].[dbo].[Organizations]
--		where [Organizations].Id=@organizationId
--	end;

--declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';


