INSERT INTO [dbo].[AnswerTypes]
           ([name])
          output [inserted].[Id]
     VALUES (@name)