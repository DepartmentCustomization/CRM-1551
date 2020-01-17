
SELECT [Id]
      ,[ApplicantFromSiteId] as [applicant_id]
      ,[AddressTypeId] as [addresstype_id]
      ,[Index] as [index]
      ,[Country] as [country]
      ,[Region] as [region]
      ,[district] as [district]
      ,[cityname] as [cityname]
      ,[StreetId] as [street_id]
      ,[StreetName] as [street]
      ,[BuildingId] as [building_id]
      ,[BuildingName] as [building]
      ,[Flat] as [flat]
  FROM [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteAddresses]
  where  #filter_columns#
        #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only