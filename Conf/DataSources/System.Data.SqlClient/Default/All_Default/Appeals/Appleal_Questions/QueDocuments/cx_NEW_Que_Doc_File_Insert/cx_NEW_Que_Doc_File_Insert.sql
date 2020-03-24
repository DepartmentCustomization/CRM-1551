-- DECLARE @question_id INT = 6690742;
DECLARE @FilesVal TINYINT = (SELECT COUNT(1) FROM [dbo].[QuestionDocFiles] WHERE question_id = @question_id);

IF(@FilesVal = 6)
BEGIN
	RAISERROR(N'Кількість файлів максимальна.',16,1);
	RETURN;
END

ELSE IF(@FilesVal < 6)
BEGIN
INSERT INTO
      [dbo].[QuestionDocFiles] (
            [name],
            [File],
            [create_date],
            [user_id],
            [edit_date],
            [edit_user_id],
            [question_id]
      ) 
OUTPUT [inserted].[Id]
VALUES
      (
            @Name,
            @File,
            getutcdate(),
            @user_id,
            getutcdate(),
            @user_id,
            @question_id
      );
END