
--  declare @applicant_id int = 10;
  --declare @addresstype_id int = 1;

  --declare @applicant_id nvarchar(300) = N'Вася';
  declare @output table (Id int);
  declare @outputId int;
  declare @Id2 int;
BEGIN TRY  
    

  insert into [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteAddresses]
	 ([ApplicantFromSiteId]
      ,[AddressTypeId])

  output [inserted].[Id] into @output (Id)
  

  select @applicant_id, @addresstype_id
  
  set @outputId=(select top 1 Id from @output )

  select @outputId as Id
  set @Id2=@outputId;
END TRY  
  BEGIN CATCH  
  
    
	set @Id2=0;
	select @Id2 as Id
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