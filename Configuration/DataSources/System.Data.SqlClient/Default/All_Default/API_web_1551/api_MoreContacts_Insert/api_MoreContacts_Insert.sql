INSERT INTO [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts]
           ([ApplicantFromSiteId]
           ,[MoreContactTypeId]
           ,[PhoneNumber]
           ,[Mail])
     VALUES
           (@applicant_id
           ,@сontacttype_id
           ,@phonenumber
           ,@mail)