INSERT INTO [dbo].[ApplicantTypes]
           ([name]
           ,[message])
           output [inserted].[Id]
     VALUES (@name, @message)