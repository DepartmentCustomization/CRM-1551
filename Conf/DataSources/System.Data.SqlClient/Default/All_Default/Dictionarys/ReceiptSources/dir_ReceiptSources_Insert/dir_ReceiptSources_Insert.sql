INSERT INTO [dbo].[ReceiptSources]
           ([name])
          output [inserted].[Id]
     VALUES (@name)