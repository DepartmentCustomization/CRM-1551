SELECT [Streets].[Id]
      ,concat(StreetTypes.shortname,' ', [Streets].[name]) as name
	  --,[Streets].[name]
  FROM [dbo].[Streets]
	left join StreetTypes on StreetTypes.Id = Streets.street_type_id
    WHERE 
    #filter_columns#
    -- #sort_columns#
    order by name desc
    offset @pageOffsetRows rows fetch next @pageLimitRows rows only