SELECT [Id]
      ,[name]
  FROM [Bot_Intagration].[dbo].[PollItemDirections]
    where 
  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only