INSERT INTO [dbo].[OrganizationTypes]
           ([name])
           output [inserted].[Id]
     VALUES
        (@name)