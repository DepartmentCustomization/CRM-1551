--declare @Question_BuildingId int = 6

SELECT top 1 ObjectTypes.Id
  FROM [dbo].[Objects]
	left join Buildings on Buildings.Id = [Objects].builbing_id
	left join ObjectTypes on ObjectTypes.Id = Objects.object_type_id
	where Buildings.Id = @Question_BuildingId