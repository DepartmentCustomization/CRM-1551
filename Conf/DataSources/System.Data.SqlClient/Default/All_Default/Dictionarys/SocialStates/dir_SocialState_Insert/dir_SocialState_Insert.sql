INSERT INTO [dbo].[SocialStates]
           ([name])
          output [inserted].[Id]
     VALUES (@name)