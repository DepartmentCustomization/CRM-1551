WITH cte1 -- все подчиненные 3 и 3
AS
(SELECT
		Id
	   ,[parent_organization_id] ParentId
	   ,[short_name]
	FROM [CRM_1551_Analitics].[dbo].[Organizations] t
	WHERE Id = 1761
	UNION ALL
	SELECT
		tp.Id
	   ,[parent_organization_id] ParentId
	   ,tp.short_name
	FROM [CRM_1551_Analitics].[dbo].[Organizations] tp
	INNER JOIN cte1 curr
		ON tp.[parent_organization_id] = curr.Id)

	SELECT
		Id, short_name name
	FROM cte1
	where 
  #filter_columns#
  --#sort_columns#
  order by 1
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
