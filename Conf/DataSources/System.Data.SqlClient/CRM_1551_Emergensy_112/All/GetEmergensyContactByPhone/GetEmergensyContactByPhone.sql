
--DECLARE @Phone NVARCHAR(200) = N'0666666666';

SELECT TOP (1)     
	   [last_name]
      ,[first_name]
      ,[middle_name]
      ,[person_phone]
      ,[birth_date]
      ,[building_id]
      ,[entrance]
      ,[entercode]
      ,[storeysnumber]
      ,[floor]
      ,[flat]
      ,[exit]
      ,[moreinformation]
      ,[longitude]
      ,[latitude]
	  ,ISNULL(st.shortname, N'')+ISNULL(s.name, N'')+ISNULL(N' '+b.name, N'')+
  ISNULL(N', кв.'+LTRIM(p.floor), N'')+ISNULL(N', під`їзд '+LTRIM(p.entrance), N'')+
  ISNULL(N' (код '+p.entercode+N')', N'')+ISNULL(N', поверх: '+LTRIM(p.floor), N'')+ISNULL(N'/'+LTRIM(p.storeysnumber),N'')+ISNULL(N' ,'+p.[exit], N'') event_address

  ,
  (SELECT STUFF
  ((SELECT N', '+LTRIM(class_id)
  FROM [dbo].[PersonClasses] pc0
  WHERE pc0.[person_id]=p.id
  FOR XML PATH('')),1,2,N'')) applicant_classes_ids
  
  FROM [CRM_1551_Emergensy_112].[dbo].[Persons] p
  LEFT JOIN [CRM_1551_Analitics].[dbo].[Buildings] b ON p.building_id=b.id
  LEFT JOIN [CRM_1551_Analitics].[dbo].Streets s ON b.street_id=s.id
  LEFT JOIN [CRM_1551_Analitics].[dbo].StreetTypes st ON s.street_type_id=st.Id
  WHERE person_phone = @Phone;