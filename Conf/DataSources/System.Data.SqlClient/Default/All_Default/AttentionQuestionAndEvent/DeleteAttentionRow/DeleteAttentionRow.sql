-- DECLARE @question_id INT = 6696109;

DECLARE @info TABLE (Id INT);

IF(@question_id IS NOT NULL)
BEGIN
DELETE FROM [dbo].[AttentionQuestionAndEvent]
	OUTPUT deleted.Id INTO @info(Id)
      WHERE question_id = @question_id;
END
ELSE IF(@assignment_id IS NOT NULL)
BEGIN
DELETE FROM [dbo].[AttentionQuestionAndEvent]
	OUTPUT deleted.Id INTO @info(Id)
      WHERE assignment_id = @assignment_id;
END
ELSE IF(@event_id IS NOT NULL)
BEGIN
DELETE FROM [dbo].[AttentionQuestionAndEvent]
	OUTPUT deleted.Id INTO @info(Id)
      WHERE event_id = @event_id;
END

IF(SELECT TOP 1 Id FROM @info) IS NOT NULL
BEGIN
	SELECT 0 AS result;
END 