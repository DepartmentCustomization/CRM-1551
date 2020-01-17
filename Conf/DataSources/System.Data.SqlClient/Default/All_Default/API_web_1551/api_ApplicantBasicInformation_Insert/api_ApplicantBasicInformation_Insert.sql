declare @tab table (Id int)

  INSERT INTO [CRM_1551_Site_Integration].[dbo].[ApplicantsFromSite]
           ([Surname]
           ,[Firstname]
           ,[Fathername]
           ,[Birthdate]
           ,[Sex]
           ,[SocialStateId]
           ,[ApplicantPrivilegeId]
           ,[INN])
    output inserted.Id into @tab(Id)       
           
     VALUES
           (@surname
           ,@firstname
           ,@fathername
           ,@birthdate
           ,@sex
           ,@socialstate_id
           ,@applicantprivilage_id
           ,@inn)
           
declare @applicant_id int
set @applicant_id = (select Top(1) Id from @tab)

select @applicant_id as applicant_id
 return 