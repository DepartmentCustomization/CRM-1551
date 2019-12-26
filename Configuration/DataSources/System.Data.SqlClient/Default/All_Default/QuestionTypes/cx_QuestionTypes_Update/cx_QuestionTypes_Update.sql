--declare @execution_term nvarchar(200)=N'23';
--declare @Attention_term_hours nvarchar(200)=N'12(123)';
--declare @question_type_id int = 13353;

DECLARE @Attention_term_hours1 INT = CASE
  WHEN CHARINDEX(N'(', @Attention_term_hours, 1) > 0 THEN left(
    right(
      @Attention_term_hours,
      len(@Attention_term_hours) - charindex(N'(', @Attention_term_hours, 1)
    ),
    LEN(
      right(
        @Attention_term_hours,
        len(@Attention_term_hours) - charindex(N'(', @Attention_term_hours, 1)
      )
    ) -1
  ) * 1
  ELSE @Attention_term_hours * 24
END;

DECLARE @execution_term1 INT = CASE
  WHEN CHARINDEX(N'(', @execution_term, 1) > 0 THEN left(
    right(
      @execution_term,
      len(@execution_term) - charindex(N'(', @execution_term, 1)
    ),
    LEN(
      right(
        @execution_term,
        len(@execution_term) - charindex(N'(', @execution_term, 1)
      )
    ) -1
  ) * 1
  ELSE @execution_term * 24
END
UPDATE
  [dbo].[QuestionTypes]
SET
  [question_type_id] = @question_type_id,
  [index] = @index,
  [name] = @name,
  [emergency] = @emergency,
  [active] = @active,
  [rule_id] = @rule_id,
  [parent_organization_is] = @parent_organization_is,
  [comments] = @comments,
  [Attention_term_hours] = --@Attention_term_hours1 	
  (
    SELECT
      CASE
        WHEN [execution_term] = @execution_term1 THEN @Attention_term_hours1
        ELSE CONVERT(numeric(8, 0), @execution_term1 * 0.75)
      END Attention_term_hours2
    FROM [CRM_1551_Analitics].[dbo].[QuestionTypes]
    WHERE Id = @Id
  ),
  [execution_term] = @execution_term1,
  [edit_date] = GETUTCDATE(),
  [user_edit_id] = @user_edit_id,
  [Object_is] = @Object_is,
  [Organization_is] = @Organization_is
WHERE Id = @Id 
  ---------------------- Проверить необходимость обновления has_child родительского типа ------------------------------
  DECLARE @parent_has_child_value bit = (
    SELECT
      has_child
    FROM QuestionTypes
    WHERE Id = @question_type_id
  );

IF(@question_type_id IS NOT NULL) 
BEGIN 
  IF(
  @parent_has_child_value IS NULL OR @parent_has_child_value = 0) 
  BEGIN
   UPDATE
   QuestionTypes SET
   has_child = 1
   WHERE Id = @question_type_id
  END
END 
---------------------- Действия с QuestionTypesInRating ----------------------
DELETE FROM
  [QuestionTypeInRating]
WHERE
  Id IN (
    SELECT
      Id
    FROM
      [QuestionTypeInRating]
    WHERE
      [QuestionType_id] = @id
      AND Rating_id IN (
        SELECT
          CASE
            WHEN @zhkg = 0 THEN 1
          END
        UNION
        SELECT
          CASE
            WHEN @blag = 0 THEN 2
          END
        UNION
        SELECT
          CASE
            WHEN @zhytraion = 0 THEN 3
          END
      )
  ) 
  -- при добавлении в таблицу
INSERT INTO
  [QuestionTypeInRating] (
    [Rating_id],
    [QuestionType_id]
  )
SELECT
  t,
  id
FROM
  (
    SELECT
      CASE
        WHEN @zhkg = 1 THEN 1
        ELSE NULL
      END t,
      @id id
    UNION ALL
    SELECT
      CASE
        WHEN @blag = 1 THEN 2
        ELSE NULL
      END t,
      @id id
    UNION
    ALL
    SELECT
      CASE
        WHEN @zhytraion = 1 THEN 3
        ELSE NULL
      END t,
      @id id
  ) q
WHERE
  t IS NOT NULL
EXCEPT
SELECT
  [Rating_id],
  [QuestionType_id]
FROM
  [QuestionTypeInRating]
WHERE
  [QuestionType_id] = @id declare @step nvarchar(50) = N'update_question_type';

EXEC [dbo].[ak_UpdateOrganizationsQuestionsTypeAndParent] @step,
@Id