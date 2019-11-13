
SELECT  [Objects].[Id] as [Id],
		[ObjectTypes].[name] as [ObjectTypeName],
		[Objects].[name] as [name]
  FROM [dbo].[Objects]
  left join [dbo].[ObjectTypes] on ObjectTypes.Id = Objects.object_type_id
where  #filter_columns#
    #sort_columns#
offset @pageOffsetRows rows fetch next @pageLimitRows rows only
