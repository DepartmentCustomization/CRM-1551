SELECT
  [Objects].[Id],
  ObjectTypes.name AS obj_type_name,
  [Objects].name AS object_name,
  Districts.name AS district_name,
  [Buildings].[street_id],
  concat(
    StreetTypes.shortname,
    ' ',
    Streets.name,
    ' ',
    Buildings.number,
    Buildings.letter
  ) AS build_name
FROM
  [dbo].[Objects]
  LEFT JOIN Buildings ON Buildings.Id = [Objects].builbing_id
  LEFT JOIN Streets ON Streets.Id = Buildings.street_id
  LEFT JOIN ObjectTypes ON ObjectTypes.Id = [Objects].object_type_id
  LEFT JOIN Districts ON Districts.Id = Objects.district_id
  LEFT JOIN StreetTypes ON StreetTypes.Id = Streets.street_type_id
WHERE
  #filter_columns#
  #sort_columns#
  OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY
