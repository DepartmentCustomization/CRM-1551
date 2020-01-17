INSERT INTO [dbo].[PhoneTypes]
           ([name])
           output [inserted].[Id]
     VALUES 
        @name