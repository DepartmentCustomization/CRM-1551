--declare @AplicantId int = 9


SELECT  [Objects].[Id] as [ObjectId],
        [Objects].[name] as [ObjectName],
		[EventTypes].[name] as [EventName],
		[Events].[comment] as [EventComment],
		[Organizations].short_name as [OrganizationName],
		[Events].[plan_end_date] as [EventPlanEndDate]
  FROM [dbo].[EventObjects]
  left join [dbo].[Events] on [Events].Id = [EventObjects].[event_id]
  left join [dbo].[EventTypes] on [EventTypes].Id = [Events].[event_type_id]
  left join [dbo].[EventOrganizers] on [EventOrganizers].event_id = [Events].Id
  left join [dbo].[Organizations] on [Organizations].Id = [EventOrganizers].organization_id
  left join [Objects] on [Objects].Id = EventObjects.[object_id]
  where [Objects].[builbing_id] in 
        (select [LiveAddress].[building_id] from [dbo].[LiveAddress] 
         where [LiveAddress].applicant_id =  @ApplicantId)
 and #filter_columns#
     #sort_columns#
offset @pageOffsetRows rows fetch next @pageLimitRows rows only