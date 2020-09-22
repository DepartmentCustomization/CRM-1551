select Id, [Name]
  from (
  select 0 Id, N'Усі' [Name]
  union all
  select Id, [name]
  from [dbo].[QuestionTypes] ) r
  where #filter_columns#
  #sort_columns#
--offset @pageOffsetRows rows fetch next @pageLimitRows rows only