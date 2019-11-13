select	[Id] as [AppealFromSiteId], 
		[WorkDirectionTypeId] as [work_direction_type_id], 
		[ObjectId] as [object_id], 
		[Content] as [appeal_content]
  from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
  where [Id]=@AppealFromSiteId