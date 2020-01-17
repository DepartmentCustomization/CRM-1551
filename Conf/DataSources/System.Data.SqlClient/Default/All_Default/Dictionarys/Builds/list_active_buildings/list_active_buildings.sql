SELECT 
     [Buildings].Id,
	concat(StreetTypes.shortname, N' ', Streets.name, N' ', 
	Buildings.number,isnull(Buildings.letter, null)) as name

  FROM [dbo].[Buildings]
	 left join Streets on Streets.Id = Buildings.street_id
	 left join StreetTypes on StreetTypes.Id = Streets.street_type_id
	 where [Buildings].is_active = 1 and
	 #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only