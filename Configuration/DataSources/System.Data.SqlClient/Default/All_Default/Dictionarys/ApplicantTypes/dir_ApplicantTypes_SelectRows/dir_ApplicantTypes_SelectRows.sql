SELECT [Id]
      ,[name]
      ,[message]
  FROM [dbo].[ApplicantTypes]
  where
    #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only