UPDATE [CRM_1551_Site_Integration].[dbo].[ApplicantsFromSite]
  SET [Surname]=@surname
           ,[Firstname]=@firstname
           ,[Fathername]=@fathername
           ,[Birthdate]=@birthdate
           ,[Sex]=@sex
           ,[SocialStateId]=@socialstate_id
           ,[ApplicantPrivilegeId]=@applicantprivilage_id
           ,[INN]=@inn
           ,[is_verified]=@is_verified
  WHERE Id=@Id;