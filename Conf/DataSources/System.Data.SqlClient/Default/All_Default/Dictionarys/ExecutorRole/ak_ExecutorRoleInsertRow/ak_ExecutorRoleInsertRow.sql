-- DECLARE @name NVARCHAR(100) = N'Нова роль виконавця';

DECLARE @output TABLE (Id INT) ;

INSERT INTO
  [dbo].[ExecutorRole] (name) 
OUTPUT inserted.Id INTO @output(Id) 
VALUES (@name) ;

DECLARE @newId INT ;

SET
  @newId = (
    SELECT
      TOP 1 Id
    FROM
      @output
  ) ;

SELECT
  @newId AS Id ;