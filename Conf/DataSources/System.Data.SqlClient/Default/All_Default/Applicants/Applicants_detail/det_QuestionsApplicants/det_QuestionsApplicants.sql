SELECT
  [Questions].Id,
  Questions.registration_number,
  [Questions].[registration_date],
  [QuestionStates].name AS QuestionStates,
  [QuestionTypes].name AS QuestionType,
  [Questions].control_date,
  Organizations.short_name
FROM
  [dbo].[Questions]
  LEFT JOIN [dbo].[Appeals] ON [Questions].appeal_id = [Appeals].Id
  LEFT JOIN [dbo].[Applicants] ON [Applicants].Id = [Appeals].applicant_id
  LEFT JOIN [dbo].[QuestionStates] ON [Questions].question_state_id = [QuestionStates].Id
  LEFT JOIN [dbo].[QuestionTypes] ON [Questions].question_type_id = [QuestionTypes].Id
  LEFT JOIN Assignments ON Assignments.Id = Questions.last_assignment_for_execution_id
  LEFT JOIN Organizations ON Organizations.Id = Assignments.executor_organization_id
WHERE
  [Applicants].Id = @ApplicantsId
  AND #filter_columns#
ORDER BY
  [Questions].[registration_date] --#sort_columns#
  OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY ;