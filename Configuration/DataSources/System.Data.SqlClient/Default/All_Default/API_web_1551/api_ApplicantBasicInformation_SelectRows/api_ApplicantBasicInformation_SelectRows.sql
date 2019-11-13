SELECT [Id]
      ,[Surname]
      ,[Firstname]
      ,[Fathername]
      ,[Birthdate]
      ,[Sex]
      ,[SocialStateId]
      ,[ApplicantPrivilegeId]
      ,[INN]
  FROM [CRM_1551_Site_Integration].[dbo].[ApplicantsFromSite]
--where   #filter_columns#
 --       #sort_columns#
-- offset @pageOffsetRows rows fetch next @pageLimitRows rows only 