SELECT bu.[Id]
      ,st.name + ' ' + sty.shortname +' буд.'+ bu.name as name
    --   ,bu.[district_id] as dis_id
      ,bu.[district_id]
  FROM [dbo].[Buildings] as bu
  join Streets as st on st.Id = bu.street_id
  join StreetTypes as sty on sty.Id = st.street_type_id
  order by name
--   where bu.[district_id] = @dis
  --   and #filter_columns#
--   #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only