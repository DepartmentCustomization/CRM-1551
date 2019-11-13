 -- declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
 -- declare @organization_id int =2006;
declare @distribute int;



declare @Organization table(Id int, [programworker] int);



--declare @organization_id int = @organization_id


declare @IdT table (Id int, [programworker] int);

-- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
insert into @IdT(Id, [programworker])
select Id, [programworker] from [CRM_1551_Analitics].[dbo].[Organizations] 
where (/*Id=@organization_id or */[parent_organization_id]=@organization_id) /*and programworker=N'true'*/ and Id not in (select Id from @IdT)

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


select o.Id, [Organizations].short_name
from @Organization o inner join [Organizations] on o.Id=[Organizations].Id