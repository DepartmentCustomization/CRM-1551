SELECT [Objects].[Id]
	  ,[Objects].name as object_name
  FROM [dbo].[Objects]
where [Objects].[Id] = @Id
-- order by 1 
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only