-- заглушка от дурака :) (повторное нажатие на кнопку зберегти питання) что бы нелетели полу пустые запросы
IF (
  @Question_TypeId IS NULL
  OR @Question_TypeId = ''
)
OR (
  @Question_Content IS NULL
  OR @Question_Content = ''
) -- and     (@Question_OrganizationId is null or @Question_OrganizationId = '')
BEGIN 
  RETURN;
END 

DECLARE @output TABLE (Id INT);
DECLARE @output2 TABLE (Id INT);
DECLARE @app_id INT;
DECLARE @assign INT;
DECLARE @getdate DATETIME = getutcdate();

DECLARE @event_id INT = (
  SELECT
    TOP 1 e.Id
  FROM
    [dbo].[Events] e
    INNER JOIN [dbo].[EventQuestionsTypes] eqt ON e.Id = eqt.event_id
    INNER JOIN [dbo].[EventObjects] eo ON e.Id = eo.event_id
  WHERE
    eo.object_id = @Question_Building
    AND eqt.question_type_id = @Question_TypeId
    AND e.registration_date < GETUTCDATE()
    AND e.active = 'true'
  ORDER BY
    e.registration_date DESC
);

UPDATE
  [dbo].[Appeals]
SET
  [applicant_id] = @applicant_id,
  [edit_date] = getutcdate()
WHERE
  [Id] = @AppealId ;

INSERT INTO
  [dbo].[Questions] (
    [appeal_id],
    [registration_number],
    [registration_date],
    [receipt_date],
    [question_state_id],
    [control_date],
    [object_id],
    [object_comment],
    [organization_id],
    [application_town_id],
    [event_id],
    [question_type_id],
    [question_content],
    [answer_form_id],
    [answer_phone],
    [answer_post],
    [answer_mail],
    [user_id],
    [edit_date],
    [user_edit_id],
    [last_assignment_for_execution_id],
    [entrance] -- art
    ,
    [flat]
  ) -- art
  OUTPUT [inserted].[Id] INTO @output (Id)
SELECT
  @AppealId,
  @AppealNumber + N'/' + rtrim(
    (
      SELECT
        count(1)
      FROM
        [dbo].[Questions]
      WHERE
        appeal_id = @AppealId
    ) + 1
  )
  /*[registration_number]*/
,
  getutcdate()
  /*[registration_date]*/
,
  getutcdate()
  /*[receipt_date]*/
,
  1
  /*[question_state_id]*/
,
  @Question_ControlDate,
  @Question_Building
  /*[object_id]*/
,
  NULL
  /*[object_comment]*/
,
  @Question_Organization
  /*[organization_id]*/
,
  NULL
  /*[application_town_id]*/
  --,@Question_EventId /*[event_id]*/
,
  @event_id
  /*[event_id]*/
,
  @Question_TypeId
  /*[question_type_id]*/
,
  @Question_Content
  /*[question_content]*/
,
  @Question_AnswerType
  /*[answer_form_id]*/
,
CASE
    WHEN @Question_AnswerType = 2 THEN @Applicant_Phone
  END
  /*[answer_phone]*/
,
CASE
    WHEN @Question_AnswerType IN (4, 5) THEN @Applicant_Building
  END
  /*[answer_post]*/
,
CASE
    WHEN @Question_AnswerType = 3 THEN @Applicant_Email
  END
  /*[answer_mail]*/
,
  @CreatedUser
  /*[user_id]*/
,
  getutcdate()
  /*edit_date*/
,
  @CreatedUser
  /*[user_edit_id]*/
,
  NULL
  /*last_assignment_for_execution_id*/
,
  @entrance -- art
,
  @flat -- art
  ;
SET 
  @app_id = (
    SELECT
      TOP 1 Id
    FROM
      @output
  );
  
  EXEC [dbo].[sp_CreateAssignment] @app_id,
                                  @Question_TypeId,
                                  @Question_Building,
                                  @Question_Organization,
                                  @CreatedUser,
                                  @Question_ControlDate ; 