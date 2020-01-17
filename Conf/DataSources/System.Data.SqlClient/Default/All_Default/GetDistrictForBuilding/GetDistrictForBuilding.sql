SELECT top 1 d.[name]
  FROM [dbo].[Buildings] as b
  left join [dbo].[Districts] as d on d.Id = b.district_id
  where b.Id = @building_id