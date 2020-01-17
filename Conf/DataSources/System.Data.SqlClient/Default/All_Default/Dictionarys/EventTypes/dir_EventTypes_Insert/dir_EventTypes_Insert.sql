INSERT INTO [dbo].[EventTypes]
           ([name])
          output [inserted].[Id]
     VALUES (@name)