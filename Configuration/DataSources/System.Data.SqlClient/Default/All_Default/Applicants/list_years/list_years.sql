

declare @t table (id_year int)
declare @yy int=1900;

while @yy<=YEAR(getdate())

begin

insert into @t(id_year)
select @yy

set @yy=@yy+1


end

select id_year id, id_year from @t
 where #filter_columns#
 order by id_year desc
  --#sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only