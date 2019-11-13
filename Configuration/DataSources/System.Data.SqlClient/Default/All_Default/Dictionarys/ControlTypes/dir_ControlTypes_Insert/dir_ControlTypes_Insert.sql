INSERT INTO [dbo].[ControlTypes]
           ([name])
          output [inserted].[Id]
     VALUES (@name)