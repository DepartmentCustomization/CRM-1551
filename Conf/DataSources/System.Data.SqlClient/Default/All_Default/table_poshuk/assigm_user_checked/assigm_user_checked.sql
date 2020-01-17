  SELECT 
	distinct
	[Workers].[Id],
	[Workers].[name] as user_checked
  FROM [CRM_1551_Analitics].[dbo].[Workers]
  
  inner Join [CRM_1551_Analitics].[dbo].[Roles]
  ON [Workers].roles_id = [Roles].Id
  where [Roles].id in (1,2 )
  and
   #filter_columns#
  #sort_columns#
  offset @pageOffsetRows rows fetch next @pageLimitRows rows only