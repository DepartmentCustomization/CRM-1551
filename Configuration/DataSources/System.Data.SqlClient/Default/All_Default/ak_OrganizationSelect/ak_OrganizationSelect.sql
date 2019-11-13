
--declare @organization_id int =805;
declare @Organization table(Id int);

declare @OrganizationId int =  @organization_id;

declare @IdT table (Id int);

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

select id
, name
-- ,short_name
,concat([short_name], ' ( ' + address + ')') as [short_name]
  from [CRM_1551_Analitics].[dbo].[Organizations]
  where id not in (select Id from @Organization o)
  and #filter_columns# 
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
