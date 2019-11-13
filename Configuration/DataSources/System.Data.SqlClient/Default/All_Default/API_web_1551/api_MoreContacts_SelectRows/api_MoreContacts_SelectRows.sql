SELECT [Id]
      ,[ApplicantFromSiteId] as [applicant_id]
      ,[MoreContactTypeId] as [сontacttype_id]
      ,[PhoneNumber] as [phonenumber]
      ,[Mail] as [mail]
  FROM [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts]
  where   #filter_columns#
        #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only