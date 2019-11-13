SELECT 
		[UserInOrganisation].[UserId] as Id
		,CONCAT( [LastName], ' ', [FirstName], ' ', [Patronymic]) as name
  FROM [CRM_1551_System_v2.0].[dbo].[UserInOrganisation]

  left join [CRM_1551_System_v2.0].[dbo].[User]
  on [UserInOrganisation].UserId = [User].UserId

  where [UserInOrganisation].OrganisationStructureId = 29
  
   and #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only