/*
declare @Id int=1319;
declare @main_position_id int=101;
declare @helper_position_id int=92;
declare @type_id int=1;
*/

declare @main_position_name nvarchar(max)=
(select name
  from [Positions]
  where Id=@main_position_id)

declare @helper_position_name nvarchar(max)=
(select [name]
  from [Positions]
  where Id=@helper_position_id);


declare @position_id int;
declare @position_id_n int;

--- ставим в ид помічника
set @position_id=case when @type_id=2 then @main_position_id
when @type_id=1 then @helper_position_id end

set @position_id_n=case when @type_id=2 then @helper_position_id
when @type_id=1 then @main_position_id end
--select @position_id

declare @Position table(Id int, Id_n int);

declare @PositionId int=@position_id;

declare @IdT table (Id int, Id_n int identity(1,1));


-- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
				insert into @IdT(Id)
				select Id from [CRM_1551_Analitics].[dbo].[Positions] 
				where (Id=@PositionId or [parent_id]=@PositionId) and Id not in (select Id from @IdT)

				--  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
				while (select count(id) from (select Id from [CRM_1551_Analitics].[dbo].[Positions]
				where [parent_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
				and Id not in (select Id from @IdT)) q)!=0
				begin

				insert into @IdT
				select Id from [CRM_1551_Analitics].[dbo].[Positions]
				where [parent_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
				and Id not in (select Id from @IdT)
				end 

				insert into @Position (Id, Id_n)
				select Id, Id_n from @IdT;



	
if exists
(select id
from @Position
where Id=@position_id_n)
	begin
		select @Id Id, N'Error' stan, [main_position_id], p_main.name main_position_name, [helper_position_id], p_help.name helper_position_name,
		  1 [type_id], N'допомогає' [type_name]
		  from [PositionsHelpers]
		  left join [Positions] p_main on [PositionsHelpers].main_position_id=p_main.Id
		  left join [Positions] p_help on [PositionsHelpers].helper_position_id=p_help.Id
		  where [PositionsHelpers].Id=@Id
	end

else
begin
select @Id Id, N'Ok' stan, @main_position_id main_position_id, @main_position_name main_position_name, 
@helper_position_id helper_position_id, @helper_position_name helper_position_name, @type_id [type_id], 
case when @type_id=1 then N'допомогає' when @type_id=2 then N'помічник' end [type_name]
end
