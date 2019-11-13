  --declare @event_id int =8;

  select [EventObjects].Id, [Districts].name [district_name] , [ObjectTypes].name obj_type_name,
  [Objects].name [object_name]
  from [CRM_1551_Analitics].[dbo].[EventObjects]
  left join [CRM_1551_Analitics].[dbo].[Objects] on [EventObjects].object_id=[Objects].Id
  left join [CRM_1551_Analitics].[dbo].[ObjectTypes] on [Objects].object_type_id=[ObjectTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Buildings] on [Objects].builbing_id=[Buildings].Id
  left join [CRM_1551_Analitics].[dbo].[Districts] on [Buildings].district_id=[Districts].Id
  where [EventObjects].event_id=@event_id and [EventObjects].[in_form] is null
  and #filter_columns#
     #sort_columns#
  offset @pageOffsetRows rows fetch next @pageLimitRows rows only
  /*
  select [ObjectsInObject].[object_id] Id, [Districts].name [district_name] , [ObjectTypes].name obj_type_name,
  [Objects].name [object_name]
 -- , [Objects].Id, [ObjectsInObject].Id, [ObjectsInObject].main_object_id
  from [CRM_1551_Analitics].[dbo].[EventObjects]
  --inner join [CRM_1551_Analitics].[dbo].[Objects] on [EventObjects].[object_id]=[Objects].Id
  inner join [CRM_1551_Analitics].[dbo].[ObjectsInObject] on [EventObjects].[object_id]=[ObjectsInObject].main_object_id
  left join [CRM_1551_Analitics].[dbo].[Objects] on [ObjectsInObject].[object_id]=[Objects].Id
  left join [CRM_1551_Analitics].[dbo].[ObjectTypes] on [Objects].object_type_id=[ObjectTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Buildings] on [Objects].builbing_id=[Buildings].Id
  left join [CRM_1551_Analitics].[dbo].[Districts] on [Buildings].district_id=[Districts].Id
  where [EventObjects].event_id=@event_id
and #filter_columns#
     #sort_columns#
  offset @pageOffsetRows rows fetch next @pageLimitRows rows only
 */

-- SELECT 
-- 	Id
-- 	,district_name
-- 	,obj_type_name
-- 	,[object_name]
-- 	from(
-- select EventObjects.Id
-- 	  ,Districts.name as district_name
-- 	  ,ObjectTypes.name as obj_type_name
-- 	  ,IIF([Objects].name is null, concat(StreetTypes.shortname,' ', Streets.name, ' ', Buildings.number,Buildings.letter),
-- 	   IIF(Buildings.street_id is null,[Objects].name, concat(StreetTypes.shortname,' ',Streets.name, ' ', Buildings.number,Buildings.letter,' ( ',[Objects].name,' )'))
-- 		 )as [object_name]

-- 	from EventObjects
-- 		left join [Events] on [Events].Id = EventObjects.event_id
-- 		left join [Objects] on [Objects].Id = EventObjects.[object_id]
-- 		left join Buildings on Buildings.Id = [Objects].builbing_id
-- 		left join Streets on Streets.Id = Buildings.street_id
-- 		left join StreetTypes on StreetTypes.Id = Streets.street_type_id
-- 		left join Districts on Districts.Id = Buildings.district_id
-- 		left join ObjectTypes on ObjectTypes.Id = [Objects].object_type_id
-- 	where EventObjects.event_id = @event_id
-- 		and EventObjects.Id <> (select top 1 Id from EventObjects where event_id = @event_id)

-- union all

-- select 0 as id
-- 	  ,Districts.name as district_name
-- 	  ,ObjectTypes.name as obj_type_name
-- 	  ,IIF([Objects].name is null, concat(StreetTypes.shortname,' ',Streets.name, ' ', Buildings.number,Buildings.letter),
-- 	   IIF(Buildings.street_id is null,[Objects].name, concat(StreetTypes.shortname,' ',Streets.name, ' ', Buildings.number,Buildings.letter,' ( ',[Objects].name,' )'))
-- 		 )as [object_name]
-- 	from ObjectsInObject
-- 		left join [Objects] on [Objects].Id =  ObjectsInObject.[object_id] 
-- 		left join [Objects] obj on obj.Id = ObjectsInObject.main_object_id 
-- 		left join Buildings on Buildings.Id = [Objects].builbing_id
-- 		left join Streets on Streets.Id = Buildings.street_id
-- 		left join StreetTypes on StreetTypes.Id = Streets.street_type_id
-- 		left join Districts on Districts.Id = Buildings.district_id
-- 		left join ObjectTypes on ObjectTypes.Id = [Objects].object_type_id
-- 	where ObjectsInObject.main_object_id = ( select top 1 object_id from EventObjects where event_id = @event_id )

-- union all

-- select 0 as id
-- 	  ,Districts.name as district_name
-- 	  ,ObjectTypes.name as obj_type_name
-- 	  ,IIF([Objects].name is null, concat(Streets.name, ' ', Buildings.number,Buildings.letter),
-- 	   IIF(Buildings.street_id is null,[Objects].name, concat(Streets.name, ' ', Buildings.number,Buildings.letter,' ( ',[Objects].name,' )'))
-- 		 )as [object_name]
-- 	from ObjectsInObject
-- 		left join [Objects] on [Objects].Id = ObjectsInObject.main_object_id   
-- 		left join [Objects] obj on obj.Id = ObjectsInObject.[object_id]
-- 		left join Buildings on Buildings.Id = [Objects].builbing_id
-- 		left join Streets on Streets.Id = Buildings.street_id
-- 		left join StreetTypes on StreetTypes.Id = Streets.street_type_id
-- 		left join Districts on Districts.Id = Buildings.district_id
-- 		left join ObjectTypes on ObjectTypes.Id = [Objects].object_type_id
-- 	where ObjectsInObject.[object_id] = ( select top 1 object_id from EventObjects where event_id = @event_id )
-- 	) as tab
-- 	where #filter_columns#
--     #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only

-- /*
-- select	EventObjects.Id
-- 	  ,Districts.name as district_name
-- 	  ,ObjectTypes.name as obj_type_name
-- 	  ,IIF(Objects.name is null, 
-- 		concat(Streets.name, ' ', Buildings.number,Buildings.letter),
-- 		IIF(Buildings.street_id is null,
-- 			Objects.name
-- 			,concat(Streets.name, ' ', Buildings.number,Buildings.letter,' ( ',Objects.name,' )')
-- 		)
-- 		 )as object_name

-- 	from EventObjects
-- 		left join Events on Events.Id = EventObjects.event_id
-- 		left join Objects on Objects.Id = EventObjects.object_id
-- 		left join Buildings on Buildings.Id = Objects.builbing_id
-- 		left join Streets on Streets.Id = Buildings.street_id
-- 		left join StreetTypes on StreetTypes.Id = Streets.street_type_id
-- 		left join Districts on Districts.Id = Buildings.district_id
-- 		left join ObjectTypes on ObjectTypes.Id = Objects.object_type_id
-- 	where EventObjects.event_id = @event_id
-- 	and #filter_columns#
--     #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only
--  */