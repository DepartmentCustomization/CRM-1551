INSERT INTO [dbo].[QuestionStates]
           ([name])
          output [inserted].[Id]
     VALUES (@name)