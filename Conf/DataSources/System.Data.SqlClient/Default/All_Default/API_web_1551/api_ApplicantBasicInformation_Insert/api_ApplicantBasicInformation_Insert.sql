DECLARE @tab TABLE (Id INT);

  INSERT INTO [CRM_1551_Site_Integration].[dbo].[ApplicantsFromSite]
           ([Surname]
           ,[Firstname]
           ,[Fathername]
           ,[Birthdate]
           ,[Sex]
           ,[SocialStateId]
           ,[ApplicantPrivilegeId]
           ,[INN]
           ,[is_verified]
           ,[external_data_sources_id])
    OUTPUT inserted.Id INTO @tab(Id)       
           
     VALUES
           (@surname
           ,@firstname
           ,@fathername
           ,@birthdate
           ,@sex
           ,@socialstate_id
           ,@applicantprivilage_id
           ,@inn
           ,@is_verified
           ,@external_data_sources_id);
           
DECLARE @applicant_id INT;
SET @applicant_id = (SELECT TOP(1) Id FROM @tab);

SELECT @applicant_id AS applicant_id;
 RETURN;