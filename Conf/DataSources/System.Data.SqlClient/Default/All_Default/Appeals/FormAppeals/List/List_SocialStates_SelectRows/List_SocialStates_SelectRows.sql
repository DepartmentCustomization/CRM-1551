select [SocialStates].Id,
       [SocialStates].[name] as [Name]
from [dbo].[SocialStates]
  WHERE 
	#filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only