
SELECT [Id]
      ,[name] as Name
  FROM [dbo].[AssignmentResults]
    WHERE code in (N'Done' , N'Independently', N'ForWork')
    and
	#filter_columns#
     #sort_columns#
offset @pageOffsetRows rows fetch next @pageLimitRows rows only