SELECT  [Appeals].[Id]
      ,[Appeals].[registration_number]
      ,[Applicants].[full_name]
      ,ReceiptSources.Name as receipt_source_name
      ,[Appeals].[phone_number]
      ,[Appeals].[mail]
      ,[Appeals].[enter_number]
      ,[Appeals].[receipt_date]
      ,Workers.name as user_name
  FROM [dbo].[Appeals]
	left join ReceiptSources on ReceiptSources.Id = Appeals.receipt_source_id
	left join Applicants on Applicants.Id = Appeals.applicant_id
	left join Workers on Workers.worker_user_id = Appeals.user_id
	WHERE 
	#filter_columns#
    --  #sort_columns#
    order by Appeals.Id desc
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only