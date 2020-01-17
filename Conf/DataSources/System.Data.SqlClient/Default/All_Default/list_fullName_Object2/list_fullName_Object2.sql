SELECT [Objects].[Id]
	  ,[Objects].name as object_name
  FROM [dbo].[Objects]
	left join Buildings on Buildings.Id = [Objects].builbing_id
	left join Streets on Streets.Id = Buildings.street_id
	left join ObjectTypes on ObjectTypes.Id = Objects.object_type_id
	left join Districts on Districts.Id = Buildings.district_id
	left join StreetTypes on StreetTypes.Id = Streets.street_type_id
where ObjectTypes.Id not in (17 /*Зовнішні інженерні об"єкти*/, 21 /*Інші*/)
and [Objects].is_active = 1
and  #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only