INSERT INTO [dbo].[Streets]
           ([name])
          output [inserted].[Id]
     VALUES (@name)