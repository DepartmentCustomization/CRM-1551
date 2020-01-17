INSERT INTO [dbo].[ConsultationTypes]
           ([name])
          output [inserted].[Id]
     VALUES (@name)