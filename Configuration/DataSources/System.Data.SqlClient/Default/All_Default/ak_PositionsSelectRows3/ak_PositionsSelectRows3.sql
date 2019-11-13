
--declare @position_id int =1174;

declare @Position table(Id int);

declare @PositionId int =  @position_id;

declare @IdT table (Id int);

-- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
insert into @IdT(Id)
select Id from [Positions]
where (Id=@PositionId or [parent_id]=@PositionId) and Id not in (select Id from @IdT)

--  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
while (select count(id) from (select Id from [Positions]
where [parent_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
and Id not in (select Id from @IdT)) q)!=0
begin

insert into @IdT
select Id from [Positions]
where [parent_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
and Id not in (select Id from @IdT)
end 

insert into @Position (Id)
select Id from @IdT;


SELECT [Id]
      ,[parent_id]
      ,[position_code]
      ,[position]
      ,[phone_number]
      ,[address]
      ,[name]
      ,[active]
      ,[user_id]
      ,[edit_date]
      ,[user_edit_id]
  FROM [CRM_1551_Analitics].[dbo].[Positions]
   where Id not in (select Id from @Position o)
   and #filter_columns#
   order by id 
  --#sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only