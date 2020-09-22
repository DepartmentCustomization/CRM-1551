DECLARE @info TABLE (Id INT);
 
INSERT INTO
      [dbo].[DocumentTypes] ([name]) 
OUTPUT [inserted].[Id] INTO @info(Id)
VALUES (@name);

SELECT TOP 1 
      Id
FROM @info AS Id;
RETURN; 