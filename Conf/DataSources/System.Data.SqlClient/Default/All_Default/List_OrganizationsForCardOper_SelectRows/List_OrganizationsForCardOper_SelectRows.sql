  select [Id],
  [address] as [address],
  [short_name] as [Name]
  from [dbo].[Organizations]
  where active = 1 and #filter_columns#
 -- order by 1
#sort_columns#
offset @pageOffsetRows rows fetch next @pageLimitRows rows only