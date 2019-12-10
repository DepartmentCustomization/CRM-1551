select Id, [name]
  from [CRM_1551_Bot_Integration].[dbo].[BotPollItem]
  where 
  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
