  -- DECLARE @question INT = 6696013;

DECLARE @Archive NVARCHAR(400) = '['+(SELECT TOP 1 [IP]+'].['+[DatabaseName]+'].' FROM [dbo].[SetingConnetDatabase] WHERE Code = N'Archive');

DECLARE @IsHere BIT = IIF(
   (
      SELECT
         COUNT(1)
      FROM
         dbo.Assignments 
      WHERE
        question_id = @question
   ) = 0,
   0,
   1
);

IF(@IsHere = 1)
BEGIN
	SET @Archive = SPACE(0);
END
DECLARE @Query NVARCHAR(MAX) = 
N'SELECT
  ass.[Id],
  ass.[registration_date],
  asst.name AS ass_type_name,
  IIF (
    len([head_name]) > 5,
    concat([head_name], '' ( '', [short_name], '')''),
    [short_name]
  ) AS performer,
  ass.[main_executor],
  ast.name AS ass_state_name,
  ass.execution_date,
  N''Перегляд'' AS ed
FROM
  '+@Archive+N'[dbo].[Assignments] ass
  LEFT JOIN dbo.AssignmentTypes asst ON asst.Id = ass.assignment_type_id
  LEFT JOIN dbo.AssignmentStates ast ON ast.Id = ass.assignment_state_id
  LEFT JOIN dbo.Organizations org ON org.Id = ass.executor_organization_id
  LEFT JOIN '+@Archive+N'dbo.Questions q ON q.Id = ass.question_id
WHERE
  ass.question_id = @question
ORDER BY
  CASE
    WHEN ast.name <> N''Закрито'' THEN 1
    WHEN ast.name = N''Закрито'' THEN 2
  END,
  main_executor DESC 
 OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY ; ' ;
 EXEC sp_executesql @Query, N'@question INT, @pageOffsetRows BIGINT, @pageLimitRows BIGINT ', 
							@question = @question,
							@pageOffsetRows = @pageOffsetRows,
							@pageLimitRows = @pageLimitRows;