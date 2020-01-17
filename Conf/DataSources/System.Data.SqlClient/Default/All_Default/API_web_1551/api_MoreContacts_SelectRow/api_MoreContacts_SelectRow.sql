SELECT [Id]
      ,[ApplicantFromSiteId] as [applicant_id]
      ,[MoreContactTypeId] as [сontacttype_id]
      ,[PhoneNumber] as [phonenumber]
      ,[Mail] as [mail]
  FROM [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts]
  where [ApplicantFromSiteId] = @applicant_id
