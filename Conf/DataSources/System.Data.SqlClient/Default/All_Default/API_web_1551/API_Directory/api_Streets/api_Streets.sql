SELECT [Streets].[Id]
      ,[Streets].[street_type_id]
      ,[Streets].[name] + ' ' + StreetTypes.shortname as name
      ,[Streets].[district_id]
  FROM [dbo].[Streets]
	join StreetTypes on StreetTypes.Id = [Streets].street_type_id 
  WHERE [Streets].Id <> 1 
	--and [Streets].[district_id] = @district_id
	and #filter_columns#
        #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
