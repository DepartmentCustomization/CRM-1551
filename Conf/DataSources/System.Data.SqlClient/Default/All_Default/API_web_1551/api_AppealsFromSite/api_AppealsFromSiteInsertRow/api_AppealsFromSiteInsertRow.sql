DECLARE @output TABLE (Id INT);
DECLARE @AppealsFromSite_Id INT;
if not exists(
  select Id
  from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
  where external_id=@external_id)

  begin

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
      ,[external_data_sources_id]
      ,[external_id]
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
      ,@external_data_sources_id
      ,@external_id;

set @AppealsFromSite_Id = (SELECT TOP 1 Id FROM @output);

EXEC [dbo].[AutomaticQuestionFromSite] @applicant_from_site_id,
@work_direction_type_id,
@object_id,
@appeal_content,
@geolocation_lat, 
@geolocation_lon,
@SystemIP,
@external_data_sources_id,
@AppealsFromSite_Id,
@user_id;

end

else 

  BEGIN
    set @AppealsFromSite_Id = (select Id
  from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
  where external_id=@external_id);
  END

SELECT @AppealsFromSite_Id Id;