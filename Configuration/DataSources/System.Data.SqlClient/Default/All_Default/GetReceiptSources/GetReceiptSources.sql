SELECT  [Id]
      ,[name]
      ,[code]
  FROM [dbo].[ReceiptSources]
  where [code] not in (N'Call1551', N'Website_mob.addition')