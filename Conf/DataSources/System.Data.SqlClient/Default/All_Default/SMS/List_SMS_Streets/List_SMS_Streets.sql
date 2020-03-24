	select [Id], [Name] from
	OPENQUERY([193.84.77.194,11433],'select * from OPENQUERY([ODS_KIEV],''select distinct streets.id as Id, streets.name as Name 
			from streets
			where streets.name <> ""
			order by 2 asc'')')
	where #filter_columns#
    --  #sort_columns#
    order by 2
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only