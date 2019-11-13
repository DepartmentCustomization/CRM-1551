
SELECT [Buildings].[Id]
      ,[Buildings].[name]
      ,[Buildings].[district_id]
	  ,[Objects].geolocation_lat
	  ,[Objects].geolocation_lon
  FROM [dbo].[Buildings]
  left join [dbo].[Objects] on [Objects].builbing_id = [Buildings].Id
  where [Buildings].street_id = @street_id
	and #filter_columns#
        #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only