;with AssResult as(
SELECT [Id]
      ,[name]
  FROM [dbo].[AssignmentResults]
 
 except

SELECT [Id]
      ,[name]
  FROM [dbo].[AssignmentResults]
  WHERE  Id = @res_id
  )

  select Id, Name from AssResult
  where #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only