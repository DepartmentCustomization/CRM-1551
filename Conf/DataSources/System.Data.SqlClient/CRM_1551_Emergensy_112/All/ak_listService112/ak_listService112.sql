  --DECLARE @category_Id INT = 1;

  SELECT DISTINCT s.Id, s.[service_name] [Name], CASE WHEN cis.service_id IS NOT NULL THEN 'true' ELSE 'false' END Service_is
  FROM [dbo].[CategoryInServices] cis
  RIGHT JOIN [dbo].[Services] s ON cis.service_id=s.id AND cis.category_id=@Category_Id
  WHERE #filter_columns#
  ORDER BY 1--#sort_columns#
  offset @pageOffsetRows rows fetch next @pageLimitRows rows only