--declare @ApplicantId int = 9

SELECT  [Objects].[Id] as [ObjectId],
		[ObjectTypes].[name] as [ObjectTypeName],
		[Objects].[name] as [ObjectName],
		[LiveAddress].[main] as [ObjectIsMain]
  FROM [dbo].[Objects]
  left join [dbo].[ObjectTypes] on ObjectTypes.Id = Objects.object_type_id
  left join [dbo].[LiveAddress] on LiveAddress.building_id = [Objects].[builbing_id]
where [LiveAddress].applicant_id =  @ApplicantId
and #filter_columns#
    #sort_columns#
offset @pageOffsetRows rows fetch next @pageLimitRows rows only