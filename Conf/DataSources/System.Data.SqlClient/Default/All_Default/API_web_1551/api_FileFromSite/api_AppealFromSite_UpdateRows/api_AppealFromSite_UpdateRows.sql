
if (select count(1) from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
    where [Id] = @AppealFromSiteId and [AppealFromSiteResultId] in (2,1)) > 0
begin
    update [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] set 
    	   [ReceiptDate] = GETUTCDATE()
          ,[WorkDirectionTypeId] = @WorkDirectionTypeId
          ,[ObjectId] = @ObjectId
          ,[Content] = @Content
          ,[AppealFromSiteResultId] = 1	/*Перевіряється модератором*/
          ,[EditByDate] = GETUTCDATE()
    where [Id] = @AppealFromSiteId
    and [AppealFromSiteResultId] in (2,1)
    
    select N'OK' as [Result]
end
else 
begin
    select N'Error' as [Result]
end