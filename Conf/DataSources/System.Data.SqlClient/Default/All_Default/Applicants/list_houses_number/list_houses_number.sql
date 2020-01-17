select Id
-- 	,concat(number,letter) as number
	,name as number
	from Buildings
	where street_id = @street
and 
	 #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only


-- SELECT [Buildings].[Id]
--       ,concat(isnull(StreetTypes.shortname,N''),N' ', isnull([Streets].[name],N''),N' ', isnull(Buildings.[name],N'')) as number
--   FROM Buildings 
-- 	left join Streets on Streets.Id = Buildings.street_id
-- 	left join Districts on Districts.Id = Buildings.district_id
-- 	left join StreetTypes on StreetTypes.Id = Streets.street_type_id
-- 	where Districts.Id = @street
-- and 
-- 	 #filter_columns#
--      #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only
