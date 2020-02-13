DECLARE @output TABLE (Id INT);

INSERT INTO [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
  (
		[ReceiptDate]
      ,[ApplicantFromSiteId]
      ,[WorkDirectionTypeId]
      ,[ObjectId]
      ,[Content]
      ,[AppealFromSiteResultId]
      ,[ProcessingDate]
      ,[EditByDate]
      ,[geolocation_lat]
      ,[geolocation_lon]
      ,[SystemIP]
      ,[is_verified]
  )
OUTPUT [inserted].[Id] INTO @output (Id)

  SELECT
       GETUTCDATE()
      ,@applicant_from_site_id
      ,@work_direction_type_id
      ,@object_id
      ,@appeal_content
      ,1
      ,GETUTCDATE()
      ,GETUTCDATE()
      ,@geolocation_lat
      ,@geolocation_lon
      ,@SystemIP
      ,@is_verified;
      
SELECT Id FROM @output;