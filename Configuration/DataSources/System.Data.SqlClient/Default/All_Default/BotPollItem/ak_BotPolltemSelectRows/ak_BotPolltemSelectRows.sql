select Id, [name]
  from [Bot_Intagration].[dbo].[BotPollItem]
  where 
  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
