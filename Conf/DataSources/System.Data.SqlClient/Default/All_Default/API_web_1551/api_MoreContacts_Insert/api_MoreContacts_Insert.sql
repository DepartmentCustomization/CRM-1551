IF NOT EXISTS(SELECT Id
	FROM [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts]
	WHERE [ApplicantFromSiteId]=@applicant_id AND ISNULL([PhoneNumber],N'')=ISNULL(@phonenumber,N'')
	AND ISNULL([Mail],N'')=ISNULL(@mail,N''))

	BEGIN


INSERT INTO [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts]
           ([ApplicantFromSiteId]
           ,[MoreContactTypeId]
           ,[PhoneNumber]
           ,[Mail])
     VALUES
           (@applicant_id
           ,@сontacttype_id
           ,@phonenumber
           ,@mail);
		   

	END