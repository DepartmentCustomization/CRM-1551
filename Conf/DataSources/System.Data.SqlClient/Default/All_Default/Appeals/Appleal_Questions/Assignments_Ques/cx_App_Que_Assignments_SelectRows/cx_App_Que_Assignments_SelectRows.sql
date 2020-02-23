SELECT
  ass.[Id],
  ass.[registration_date],
  asst.name AS ass_type_name --   ,Organizations.short_name as performer
,
  IIF (
    len([head_name]) > 5,
    concat([head_name], ' ( ', [short_name], ')'),
    [short_name]
  ) AS performer,
  ass.[main_executor],
  ast.name AS ass_state_name,
  ass.execution_date 
  -- ,Questions.control_date as execution_date
,
  N'Перегляд' AS ed
FROM
  [dbo].[Assignments] ass
  LEFT JOIN dbo.AssignmentTypes asst ON asst.Id = ass.assignment_type_id
  LEFT JOIN dbo.AssignmentStates ast ON ast.Id = ass.assignment_state_id
  LEFT JOIN dbo.Organizations org ON org.Id = ass.executor_organization_id
  LEFT JOIN dbo.Questions q ON q.Id = ass.question_id
WHERE
  ass.question_id = @question
ORDER BY
  CASE
    WHEN ast.name <> N'Закрито' THEN 1
    WHEN ast.name = N'Закрито' THEN 2
  END,
  main_executor DESC 
  OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY ;