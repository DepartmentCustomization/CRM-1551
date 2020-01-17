select Id,
		  --,concat(name, ' (',[Role can make complain],')') as 
		  [name]
		  --,ComplainTypes.[Role can make complain]
	from ComplainTypes
	where #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only