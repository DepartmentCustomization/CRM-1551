INSERT INTO [dbo].[ConnectionTypes]
           ([name])
          output [inserted].[Id]
     VALUES (@name)