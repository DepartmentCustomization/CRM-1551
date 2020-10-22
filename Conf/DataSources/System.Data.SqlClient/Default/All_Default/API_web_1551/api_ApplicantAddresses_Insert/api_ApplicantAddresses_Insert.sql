

if exists (select top 1 Id from [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteAddresses]
 where [ApplicantFromSiteId]=@applicant_id and [AddressTypeId]=4)

 begin
	update [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteAddresses]
	set [AddressTypeId]=@addresstype_id
           ,[Index]=@index
           ,[Country]=@country
           ,[Region]=@region
           ,[District]=@district
           ,[Cityname]=@cityname
           ,[Streetid]=@street_id
           ,[StreetName]=@street
           ,[BuildingId]=@building_id
           ,[BuildingName]=@building
           ,[flat]=@flat
	where [ApplicantFromSiteId]=@applicant_id and [AddressTypeId]=4
 end 



ELSE IF NOT EXISTS
  (SELECT Id FROM [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteAddresses]
  WHERE ISNULL([ApplicantFromSiteId],0)=ISNULL(@applicant_id,0)
            AND ISNULL([AddressTypeId],0)=ISNULL(@addresstype_id,0)
            AND ISNULL([Index],0)=ISNULL(@index,0)
            AND ISNULL([Country],N'')=ISNULL(@country,N'')
            AND ISNULL([Region],N'')=ISNULL(@region,N'')
            AND ISNULL([District],N'')=ISNULL(@district,N'')
            AND ISNULL([CityName],N'')=ISNULL(@cityname,N'')
            AND ISNULL([StreetId],0)=ISNULL(@street_id,0)
            AND ISNULL([StreetName],N'')=ISNULL(@street,N'')
            AND ISNULL([BuildingId],0)=ISNULL(@building_id,0)
            AND ISNULL([BuildingName],N'')=ISNULL(@building,N'')
            AND ISNULL([Flat],N'')=ISNULL(@flat,N'')
		   )

  BEGIN

  INSERT INTO [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteAddresses]
           ([ApplicantFromSiteId]
           ,[AddressTypeId]
           ,[Index]
           ,[Country]
           ,[Region]
           ,[District]
           ,[Cityname]
           ,[Streetid]
           ,[StreetName]
           ,[BuildingId]
           ,[BuildingName]
           ,[flat])
     VALUES
           (@applicant_id
           ,@addresstype_id
           ,@index
           ,@country
           ,@region
           ,@district
           ,@cityname
           ,@street_id
           ,@street
           ,@building_id
           ,@building
           ,@flat);

	END

