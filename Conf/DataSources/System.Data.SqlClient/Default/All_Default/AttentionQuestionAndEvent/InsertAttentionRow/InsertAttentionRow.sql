DECLARE @info TABLE (Id INT);

INSERT INTO
      [dbo].[AttentionQuestionAndEvent] (
            [user_id],
            [question_id],
            [assignment_id],
            [event_id]
      ) OUTPUT inserted.Id INTO @info(Id)
VALUES
      (
            @user_id,
            @question_id,
            @assignment_id,
            @event_id
      );

IF(SELECT TOP 1 Id FROM @info) IS NOT NULL
BEGIN 
      SELECT 1 AS result;
END 