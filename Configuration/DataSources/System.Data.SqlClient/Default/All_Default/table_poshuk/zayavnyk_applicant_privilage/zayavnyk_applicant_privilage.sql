SELECT [Id]
      ,[Name]
  FROM [CRM_1551_Analitics].[dbo].[ApplicantPrivilege]
  where #filter_columns#
  #sort_columns#
  offset @pageOffsetRows rows fetch next @pageLimitRows rows only