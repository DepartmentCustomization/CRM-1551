 select Id,
  [name] 
  from [dbo].[QuestionTypes] 
  where active <> 0
  and 
  #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only