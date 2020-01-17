SELECT [Objects].[Id]
      ,/*IIF(Objects.name is null, concat(ObjectTypes.name, ' : ',Streets.name, ' ', Buildings.number,Buildings.letter),
	   IIF(Buildings.street_id is null,Objects.name, concat(ObjectTypes.name, ' : ',Streets.name, ' ', Buildings.number,Buildings.letter,' ( ',Objects.name,' )'))
	  )  as object_name*/
	  [Objects].name as object_name
  FROM [dbo].[Objects]
-- 	left join Buildings on Buildings.Id = [Objects].builbing_id
-- 	left join Streets on Streets.Id = Buildings.street_id
-- 	left join ObjectTypes on ObjectTypes.Id = Objects.object_type_id
-- 	left join Districts on Districts.Id = Buildings.district_id
-- 	left join StreetTypes on StreetTypes.Id = Streets.street_type_id
	where [builbing_id] = @buil_id