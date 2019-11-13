SELECT 1 as Id, 'Test' as name
	WHERE 
	#filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only