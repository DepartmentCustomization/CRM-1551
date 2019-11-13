SELECT [Id]
      ,[name]
  FROM [CRM_1551_Analitics].[dbo].[AssignmentResults]
  where   code in (N'Independently', N'WasExplained', N'Actually', N'Done', N'ClosedAutomatically', N'MissedCall', N'ForWork')
  AND #filter_columns#
  #sort_columns#