declare @organization_id int
-- declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
set @organization_id = null -- (select organization_id from Assignments where Id = @ass_id)
declare @Organization table(Id int);


declare @OrganizationId int = 
case 
	when @organization_id is not null then @organization_id
	else (select Id
			from [dbo].[Organizations]
			where Id in (select organization_id
						 from [dbo].[Workers]
						 where worker_user_id=@user_id))
 end


declare @IdT table (Id int);

-- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
insert into @IdT(Id)
select Id from [dbo].[Organizations] 
where (Id=@OrganizationId or [parent_organization_id]=@OrganizationId) --and Id not in (select Id from @IdT)

--  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
while (select count(id) from (select Id from [dbo].[Organizations]
	where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
	and Id not in (select Id from @IdT)) q)!=0
begin
	insert into @IdT
	select Id from [dbo].[Organizations]
	where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
	and Id not in (select Id from @IdT)
end 

insert into @Organization (Id)
select Id from @IdT;

--select * from @Organization


 select 
		Id
 		,IIF (len([head_name]) > 5,  concat([head_name] , ' ( ' , [short_name] , ')'),  [short_name]) as full_name
  from [dbo].[Organizations]
    where programworker = 1 
	and Id in (select Id from @Organization)
	and #filter_columns#
        #sort_columns#
        offset @pageOffsetRows rows fetch next @pageLimitRows rows only