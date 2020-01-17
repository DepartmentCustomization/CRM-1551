select Id, short_name from Organizations
 where Id <> 1 and
	 #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only