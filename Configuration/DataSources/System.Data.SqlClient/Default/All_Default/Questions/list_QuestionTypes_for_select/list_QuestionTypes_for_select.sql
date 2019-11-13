SELECT  [Id]
      ,[name]
  FROM [dbo].[QuestionTypes]
  	where active not in (0) 
      and has_child = 0
  	and #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only