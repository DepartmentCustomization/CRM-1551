SELECT [Id]
      ,[Name]
  FROM [dbo].[ApplicantPrivilege]
  where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only