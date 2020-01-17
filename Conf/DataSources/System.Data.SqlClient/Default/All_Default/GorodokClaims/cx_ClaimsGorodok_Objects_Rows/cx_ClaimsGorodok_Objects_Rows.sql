select   tab.Id
		,tab.main_obj_name
		,tab.obj_name
		from
(SELECT [ObjectsInObject].[Id]
	  ,IIF(Objects.name is null, 
		concat(Streets.name, ' ', Buildings.number,Buildings.letter),
		IIF(Buildings.street_id is null,
			Objects.name
			,concat(Streets.name, ' ', Buildings.number,Buildings.letter,' ( ',Objects.name,' )')
		)
		 )  as main_obj_name
	  ,'' as obj_name
  FROM [dbo].[ObjectsInObject]
	left join Objects on Objects.Id = [ObjectsInObject].main_object_id
	left join OConnectionTypes on OConnectionTypes.Id = [ObjectsInObject].object_connection_type_id
	left join Buildings on Buildings.Id = [Objects].Id
	left join Streets on Streets.Id = Buildings.street_id
	left join ObjectTypes on ObjectTypes.Id = Objects.object_type_id
where [ObjectsInObject].object_id = @obj_id

union all 

SELECT [ObjectsInObject].[Id]
	  ,'' as main_obj_name
      ,IIF(Objects.name is null, 
		concat(Streets.name, ' ', Buildings.number,Buildings.letter),
		IIF(Buildings.street_id is null,
			Objects.name
			,concat(Streets.name, ' ', Buildings.number,Buildings.letter,' ( ',Objects.name,' )')
		)
		 )  as obj_name
  FROM [dbo].[ObjectsInObject]
	left join Objects on Objects.Id = [ObjectsInObject].object_id
	left join OConnectionTypes on OConnectionTypes.Id = [ObjectsInObject].object_connection_type_id
	left join Buildings on Buildings.Id = [Objects].Id
	left join Streets on Streets.Id = Buildings.street_id
	left join ObjectTypes on ObjectTypes.Id = Objects.object_type_id
where [ObjectsInObject].main_object_id =  @obj_id
) as tab
where #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only