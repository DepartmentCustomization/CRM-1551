SELECT p.Id, p.[position], o.short_name, 
  CASE WHEN p.[main_position_id] IS NOT NULL THEN 'Так' ELSE 'Ні' END [additional], 
  CASE WHEN p.active='true' THEN 'Так' ELSE 'Ні' END active
  FROM [dbo].[Positions] p
  LEFT JOIN [dbo].[Organizations] o ON p.organizations_id=o.Id
  WHERE [main_position_id]=@position_id AND  #filter_columns#
  ORDER BY p.active DESC
  offset @pageOffsetRows rows fetch next @pageLimitRows rows only