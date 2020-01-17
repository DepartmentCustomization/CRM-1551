INSERT INTO [dbo].[AssignmentStates]
           ([name])
          output [inserted].[Id]
     VALUES (@name)