SELECT Id, name FROM Districts
WHERE id != 11
and #filter_columns#
#sort_columns#
offset @pageOffsetRows rows fetch next @pageLimitRows rows only
