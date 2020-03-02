SELECT
  [Objects].[Id],
  [Objects].name AS object_name
FROM
  [dbo].[Objects]
WHERE
  [Objects].[Id] = @Id;
   -- order by 1 
  --  offset @pageOffsetRows rows fetch next @pageLimitRows rows only