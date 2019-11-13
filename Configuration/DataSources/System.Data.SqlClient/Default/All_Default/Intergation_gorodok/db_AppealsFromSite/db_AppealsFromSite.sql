-- declare @result_t table (res int)
-- if @result = null
-- begin  
--  insert into @result_t (res)
--  SELECT top 1 [Id] from SiteAppealsResults
--  end
--  else 
--  begin insert into @result_t (res) 
-- select @result
-- end
select	afs.Id as Id, 
		ReceiptDate as receiptDate, 
		wdt.[name] as workDirection,
		obj.[name] as appealObject, 
		afs.Content as content, 
		sar.[name] as result,
		CommentModerator as moderComment 
from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] afs
left join [CRM_1551_Site_Integration].[dbo].WorkDirectionTypes wdt on afs.WorkDirectionTypeId = wdt.id
left join CRM_1551_Analitics.[dbo].[Objects] obj on obj.Id = afs.[ObjectId]
left join SiteAppealsResults sar on sar.id = afs.AppealFromSiteResultId

where Appeal_Id is null --and sar.id in ( @result ) 
and #filter_columns#
    #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only