SELECT Id, [Row], [Name]
FROM
(SELECT 1 Id, 'false' [Row], N'Неопрацьовані' [Name]
  UNION ALL
  SELECT 2 Id, 'true' [Row], N'Опрацьовані' [Name]
  -- UNION ALL
  -- SELECT 3 Id, null [Row], N'Усі' [Name]
  ) t
  WHERE #filter_columns#
  #sort_columns#
  OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY