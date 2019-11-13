SELECT [Streets].[Id]
      ,[Streets].[name] + ' ' + StreetTypes.shortname as streets
  FROM [dbo].[Streets]
  join StreetTypes on StreetTypes.Id = Streets.street_type_id
  where [Streets].Id not in (1)
--   and #filter_columns#
--   #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only