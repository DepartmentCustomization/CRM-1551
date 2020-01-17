SELECT [Id]
      ,[name]
  FROM [dbo].[OrganizationTypes]
  where 
    #filter_columns#
     #sort_columns#
-- offset @pageOffsetRows rows fetch next @pageLimitRows rows only