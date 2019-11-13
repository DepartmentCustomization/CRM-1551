INSERT INTO [dbo].[AssignmentResolutions]
           ([name])
          output [inserted].[Id]
     VALUES (@name)