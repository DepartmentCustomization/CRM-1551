
declare @year table (Id int);
declare @y int=2010;
declare @month table (Id int);
declare @m int=1;

while @y<=(select YEAR(GETDATE()))
begin 
	insert into @year(Id)
	select @y
	set @y=@y+1
end

while @m<=12
begin 
	insert into @month(Id)
	select @m
	set @m=@m+1
end


select t1.[Id], t1.[date] as [Name]
from (
select ROW_NUMBER() over(order by yy.Id, mm.Id) as Id, ltrim(yy.Id)+N'-'+case when len(mm.Id)=1 then N'0'+ltrim(mm.Id) else LTRIM(mm.Id) end 
as [date]
from @year yy, @month mm
--order by yy.Id, mm.Id
) as t1
where #filter_columns#
 #sort_columns#
 --order by t1.[date] 
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
