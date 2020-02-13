SELECT
    [Id]
    ,[name]
    ,[code]
FROM [dbo].[ReceiptSources]
WHERE [code] NOT IN ( N'Call1551', N'Website_mob.addition', N'UGL', N'Media', N'Nonresident' );
