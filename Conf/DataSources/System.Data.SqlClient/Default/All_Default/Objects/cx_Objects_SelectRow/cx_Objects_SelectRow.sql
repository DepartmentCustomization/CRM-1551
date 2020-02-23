-- DECLARE @Id INT = 125350 ;
SELECT
  obj.[Id],
  objt.name AS obj_type_name,
  objt.Id AS obj_type_id,
  obj.name AS object_name,
  d.name AS district_name,
  obj.district_id AS district_id,
  b.street_id,
  IIF(
    concat(
      st.shortname,
      N' ',
      s.name,
      N' ',
      b.number,
      isnull(b.letter, NULL)
    ) = '  ',
    NULL,
    concat(
      st.shortname,
      N' ',
      s.name,
      N' ',
      b.number,
      isnull(b.letter, NULL)
    )
  ) AS build_name,
  b.Id AS builbing_id,
  obj.is_active
FROM
  [dbo].[Objects] obj
  LEFT JOIN dbo.Buildings b ON b.Id = obj.[builbing_id]
  LEFT JOIN dbo.Streets s ON s.Id = b.street_id
  LEFT JOIN dbo.ObjectTypes objt ON objt.Id = obj.object_type_id
  LEFT JOIN dbo.Districts d ON d.Id = obj.district_id
  LEFT JOIN dbo.[StreetTypes] st ON s.street_type_id = st.Id
WHERE
  obj.Id = @Id ;