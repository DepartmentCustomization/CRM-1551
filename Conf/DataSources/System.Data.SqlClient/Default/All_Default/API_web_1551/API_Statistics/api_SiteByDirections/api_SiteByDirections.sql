SELECT	[Id],
		[QuestionGroup], 
		CountAssignments as [count_Assignments]
  FROM [CRM_1551_Site_Integration].[dbo].[Statistics_ByDirections]
 where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
