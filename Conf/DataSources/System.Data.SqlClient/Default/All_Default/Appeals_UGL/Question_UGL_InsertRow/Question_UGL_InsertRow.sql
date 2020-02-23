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
    [entrance], -- art
    [flat]
  ) -- art
  output [inserted].[Id] INTO @output (Id)
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
  @Question_ControlDate
  ,
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
,
  @Question_EventId
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
  @answer_phone
  /*[answer_phone]*/
,
  @answer_post
  /*[answer_post]*/
,
  @answer_mail
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
  ) ;
UPDATE
  [dbo].[Appeals]
SET
  [applicant_id] = @applicant_id,
  [edit_date] = getutcdate()
WHERE
  [Id] = @AppealId ;
  
  EXEC [dbo].[sp_CreateAssignment] 
  @app_id,
  @Question_TypeId,
  @Question_Building,
  @Question_OrganizationId,
  @CreatedUser,
  @Question_ControlDate ; 