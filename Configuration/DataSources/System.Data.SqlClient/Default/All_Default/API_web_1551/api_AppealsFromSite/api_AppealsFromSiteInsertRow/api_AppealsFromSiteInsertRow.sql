declare @output table (Id int);

insert into [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
  (
		[ReceiptDate]
      ,[ApplicantFromSiteId]
      ,[WorkDirectionTypeId]
      ,[ObjectId]
      ,[Content]
      ,[AppealFromSiteResultId]
      ,[ProcessingDate]
      ,[EditByDate]
  )
output [inserted].[Id] into @output (Id)

  select
       GETUTCDATE()
      ,@applicant_from_site_id
      ,@work_direction_type_id
      ,@object_id
      ,@appeal_content
      ,1
      ,GETUTCDATE()
      ,GETUTCDATE()
      
select Id from @output