SELECT [Events].[Id]
	  ,EventTypes.name as event_type_name
	  ,Event_Class.name as event_class_name
	  ,Events.event_class_id as event_class_id
        ,(select top 1 [Objects].name [object_name]
        		 from EventObjects 
        			left join [Objects] on [Objects].Id = EventObjects.[object_id]
        			left join Buildings on Buildings.Id = [Objects].builbing_id
        			left join Streets on Streets.Id = Buildings.street_id
					left join StreetTypes on StreetTypes.Id = Streets.street_type_id
        			left join ObjectTypes on ObjectTypes.Id = Objects.object_type_id 
        		where EventObjects.event_id = Events.Id and EventObjects.[in_form]='true'
        	) as [object_name]
	  ,Organizations.short_name as executor_name
      ,[Events].[start_date]
      ,[Events].[real_end_date]
      ,[Events].[active]
      ,[Events].[audio_on]
  FROM [dbo].[Events] 
	left join EventTypes on EventTypes.Id = Events.event_type_id
	left join EventOrganizers on EventOrganizers.event_id = Events.Id and main = 1
	left join Executors on Executors.Id = EventOrganizers.organization_id
	left join Organizations on Organizations.Id = EventOrganizers.organization_id
	left join Event_Class on Event_Class.id = [Events].event_class_id
	where #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only