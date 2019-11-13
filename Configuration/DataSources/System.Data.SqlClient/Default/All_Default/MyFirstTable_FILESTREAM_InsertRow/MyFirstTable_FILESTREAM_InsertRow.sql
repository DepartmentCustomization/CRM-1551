INSERT INTO MyFirstTable_FILESTREAM([GUID], [File], [Name])
output [inserted].[Id]
SELECT NEWID(), @File, @Name