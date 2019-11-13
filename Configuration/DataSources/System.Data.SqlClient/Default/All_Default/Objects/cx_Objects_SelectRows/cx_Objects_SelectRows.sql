SELECT [Objects].[Id]
      ,ObjectTypes.name as obj_type_name
      ,[Objects].name  as object_name
      ,Districts.name as district_name
      ,[Buildings].[street_id]
      ,concat(StreetTypes.shortname, ' ', Streets.name, ' ', Buildings.number,Buildings.letter) as build_name
  FROM [dbo].[Objects]
	left join Buildings on Buildings.Id = [Objects].builbing_id
	left join Streets on Streets.Id = Buildings.street_id
	left join ObjectTypes on ObjectTypes.Id = [Objects].object_type_id
	left join Districts on Districts.Id = Buildings.district_id
	left join StreetTypes on StreetTypes.Id = Streets.street_type_id
where #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only