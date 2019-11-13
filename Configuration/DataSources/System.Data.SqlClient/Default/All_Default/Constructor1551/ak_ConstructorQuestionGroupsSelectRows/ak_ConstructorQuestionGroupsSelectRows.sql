select [Id], [Name]
  from [QuestionGroups]
   where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
