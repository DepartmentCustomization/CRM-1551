--declare @applicant_id nvarchar(300) = N'Вася';

  --declare @applicant_id int =10;
 -- declare @object_id int =11;

  declare @Id_t nvarchar(500);
  declare @Id table (Id int)

  declare @Id_result nvarchar(500);
  

  BEGIN TRY  
   

  delete 
  from [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteAddresses]
  where Id in (select Id
  from [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteAddresses]
  where ApplicantFromSiteId = @applicant_id and [ObjectId] = @object_id)
  
  set @Id_result=(
  select stuff((
  select N', '+ltrim(Id)
  from [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteAddresses]
  where ApplicantFromSiteId = @applicant_id and [ObjectId] = @object_id
  for xml path('')), 1,2,N''))
  --select @Id2 as Id
  
END TRY  
  BEGIN CATCH  
  
    --select '0' as Id
	set @Id_result=N'0';
    /*
    PRINT 'ERROR '+rtrim(@YEAR);
    SELECT  
      ERROR_NUMBER() AS ErrorNumber  
      ,ERROR_SEVERITY() AS ErrorSeverity  
      ,ERROR_STATE() AS ErrorState  
      ,ERROR_PROCEDURE() AS ErrorProcedure  
      ,ERROR_LINE() AS ErrorLine  
      ,ERROR_MESSAGE() AS ErrorMessage;  
      */
  END CATCH;

  select case when @Id_result=N'0' then N'Error' else N'OK' end result
  --select @Id_result