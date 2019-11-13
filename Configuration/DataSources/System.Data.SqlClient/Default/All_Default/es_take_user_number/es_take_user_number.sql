  SELECT [UserId]
      ,[PhoneNumber]
      ,[UserName]
      ,[FirstName]
      ,[LastName]
  FROM [CRM_1551_System].[dbo].[User]
  where UserId = @Id
