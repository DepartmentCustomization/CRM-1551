SELECT
  [Streets].[Id],
  concat(StreetTypes.shortname, ' ', [Streets].[name]) AS name --,[Streets].[name]
FROM
  [dbo].[Streets]
  LEFT JOIN StreetTypes ON StreetTypes.Id = Streets.street_type_id
WHERE
  #filter_columns#
  -- #sort_columns#
ORDER BY NAME DESC
 OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY ;