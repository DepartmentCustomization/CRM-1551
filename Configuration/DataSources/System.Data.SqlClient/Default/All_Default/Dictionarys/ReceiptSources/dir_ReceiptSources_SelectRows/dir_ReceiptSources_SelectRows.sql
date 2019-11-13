SELECT [Id]
      ,[name]
  FROM [dbo].[ReceiptSources]
  WHERE 
    #filter_columns#
    #sort_columns#
  --  offset @pageOffsetRows rows fetch next @pageLimitRows rows only