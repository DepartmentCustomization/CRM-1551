 select [ReceiptSources].code
    FROM [dbo].[Appeals]
    left join [dbo].[ReceiptSources] on [ReceiptSources].Id = [Appeals].[receipt_source_id]
  where [Appeals].id = @AppealId