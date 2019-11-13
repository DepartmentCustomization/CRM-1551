INSERT INTO [dbo].[DocumentTypes]
           ([name])
           output [inserted].[Id]
     VALUES
        @name