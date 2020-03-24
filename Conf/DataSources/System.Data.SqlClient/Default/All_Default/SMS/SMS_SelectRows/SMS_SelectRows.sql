--declare @phone_number nvarchar(100) = N'0633958080'

 SELECT TOP (1) [Id]
      ,[ContactId]
      ,[FlatId]
      ,[HouseId]
      ,[Name]
      ,[Phone]
      ,[CreatedAt_Gorodok]
      ,[UpdatedAt_Gorodok]
      ,[UpdatedAt]
      ,[ContactType]
      ,[SendClaims]
      ,[ChangedBy1557Web]
      ,[ChangedBy1551Web]
      ,[UpdatedAt_1551]
  FROM [CRM_1551_SMS].[dbo].[mail_delivery_subscribers_sms_accounts]
  where [Phone] = @phone_number