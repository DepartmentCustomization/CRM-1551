SELECT [Objects].[Id]
	  ,[Objects].[Name]
  FROM [dbo].[Objects]
where #filter_columns#
   #sort_columns#
   --order by 1
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only