select	EventObjects.Id
	  ,Districts.name as district_name
	  ,Districts.Id as district_id
	  ,ObjectTypes.name as obj_type_name
	  ,ObjectTypes.Id as obj_type_id
	  ,IIF(Objects.name is null, 
		concat(Streets.name, ' ', Buildings.number,Buildings.letter),
		IIF(Buildings.street_id is null,
			Objects.name
			,concat(Streets.name, ' ', Buildings.number,Buildings.letter,' ( ',Objects.name,' )')
		)
		 )as object_name
		 ,Objects.Id as object_id

	from EventObjects
		left join Events on Events.Id = EventObjects.event_id
		left join Objects on Objects.Id = EventObjects.object_id
		left join Buildings on Buildings.Id = Objects.builbing_id
		left join Streets on Streets.Id = Buildings.street_id
		left join StreetTypes on StreetTypes.Id = Streets.street_type_id
		left join Districts on Districts.Id = Buildings.district_id
		left join ObjectTypes on ObjectTypes.Id = Objects.object_type_id
	where EventObjects.Id = @Id