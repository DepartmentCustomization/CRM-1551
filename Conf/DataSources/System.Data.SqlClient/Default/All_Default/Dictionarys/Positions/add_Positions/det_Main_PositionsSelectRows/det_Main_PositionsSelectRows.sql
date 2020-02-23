SELECT p2.Id, p2.position, o.short_name, 
  CASE WHEN p2.[main_position_id] IS NOT NULL THEN 'Так' ELSE 'Ні' END [additional], 
  CASE WHEN p2.active='true' THEN 'Так' ELSE 'Ні' END active
  FROM [dbo].[Positions] p1
  INNER JOIN [dbo].[Positions] p2 ON p1.main_position_id=p2.Id
  LEFT JOIN [dbo].Organizations o ON p2.organizations_id=o.Id
  WHERE p1.Id=@position_id
  AND   #filter_columns#
  ORDER BY 1
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
