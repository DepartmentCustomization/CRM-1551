
SELECT [Id]
      ,rtrim(@AssignmentResultId) as Name
  FROM [dbo].[AssignmentResolutions]
    WHERE 
	#filter_columns#
     #sort_columns#
offset @pageOffsetRows rows fetch next @pageLimitRows rows only