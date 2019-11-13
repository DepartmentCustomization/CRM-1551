SELECT 
	distinct
	[Workers].[Id],
	[Workers].[name] as name_user_reviewed
  FROM [CRM_1551_Analitics].[dbo].[Workers]
  
  inner Join [CRM_1551_Analitics].[dbo].[Roles]
  ON [Workers].roles_id = [Roles].Id
  where [Roles].id in (3,4 )
  and #filter_columns#
  #sort_columns#
  offset @pageOffsetRows rows fetch next @pageLimitRows rows only     