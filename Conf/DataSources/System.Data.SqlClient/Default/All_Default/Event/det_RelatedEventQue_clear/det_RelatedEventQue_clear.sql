--  DECLARE @question_id INT = 7391987; 

UPDATE [dbo].[Questions]
	SET event_id = NULL 
WHERE
  Id = @Id ;