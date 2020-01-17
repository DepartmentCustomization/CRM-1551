INSERT INTO [dbo].[AssignmentResults]
           ([name])
          output [inserted].[Id]
     VALUES (@name)