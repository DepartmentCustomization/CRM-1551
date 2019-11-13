INSERT INTO [dbo].[ObjectTypes]
           ([name])
          output [inserted].[Id]
     VALUES (@name)