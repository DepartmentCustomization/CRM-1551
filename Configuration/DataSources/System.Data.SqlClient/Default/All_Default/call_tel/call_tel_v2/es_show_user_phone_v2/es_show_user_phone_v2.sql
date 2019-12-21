SELECT [UserId]
      ,[PhoneNumber]
      ,[UserName]
      ,[FirstName]
      ,[LastName]
  FROM [#system_database_name#].[dbo].[User]
  where UserId = @Id