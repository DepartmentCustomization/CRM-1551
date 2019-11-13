
SELECT [Buildings].[Id]
      ,concat(isnull(StreetTypes.shortname,N''),N' ', isnull([Streets].[name],N''),N' ', isnull(Buildings.[name],N'')) as number
  FROM Buildings 
	left join Streets on Streets.Id = Buildings.street_id
	left join Districts on Districts.Id = Buildings.district_id
	left join StreetTypes on StreetTypes.Id = Streets.street_type_id
	left join [Objects] on [Objects].builbing_id = Buildings.Id
	where [Objects].[object_type_id] = 1 
	and [Objects].[is_active] = 1
	and #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
