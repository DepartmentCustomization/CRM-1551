select [Buildings].Id,
isnull([StreetTypes].shortname,N'')+N' '+isnull([Streets].name,N'')+N' '+isnull([Buildings].name,N'') as [Name]

from [dbo].[Buildings]
  left join [dbo].[Streets] on [Streets].Id = [Buildings].street_id
  left join [dbo].[StreetTypes] on [StreetTypes].Id = [Streets].street_type_id
  WHERE 
	#filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only