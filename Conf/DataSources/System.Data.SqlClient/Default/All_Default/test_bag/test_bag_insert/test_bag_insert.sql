DECLARE @out TABLE(Id INT);

INSERT INTO dbo.Test_Bag (SystemUserId)
OUTPUT inserted.Id INTO @out(Id)
VALUES (@SystemUserId)

DECLARE @newID INT = (SELECT TOP 1 Id FROM @out);
SELECT 
    @newID AS Id;
    RETURN;