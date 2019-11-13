
INSERT INTO [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteDocuments]
           ([ApplicantFromSiteId]
           ,[DocumentTypeId]
           ,[series]
           ,[documentnumber]
           ,[issuedate]
           ,[validity]
           ,[issued_by])
     VALUES
           (@applicant_id
           ,@documenttype_id
           ,@series
           ,@documentnumber
           ,@issuedate
           ,@validity
           ,@issued_by)