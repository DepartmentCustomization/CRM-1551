SELECT [Id]
      ,[ApplicantFromSiteId] as [applicant_id]
      ,[DocumentTypeId] as [documenttype_id]
      ,[series]
      ,[documentnumber]
      ,[issuedate]
      ,[validity]
      ,[issued_by]
  FROM [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteDocuments]
  where   #filter_columns#
        #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only