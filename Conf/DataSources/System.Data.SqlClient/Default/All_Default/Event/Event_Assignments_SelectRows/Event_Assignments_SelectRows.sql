-- DECLARE @Id INT = 255;

DECLARE @Archive NVARCHAR(400) = '['+(SELECT TOP 1 [IP]+'].['+[DatabaseName]+'].' FROM [dbo].[SetingConnetDatabase] WHERE Code = N'Archive');

DECLARE @IsHere BIT = IIF(
   (
      SELECT
         COUNT(1)
      FROM
         dbo.Assignments 
      WHERE
        my_event_id = @Id
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
  INNER JOIN dbo.[Events] e ON e.Id = ass.my_event_id
  LEFT JOIN dbo.AssignmentTypes asst ON asst.Id = ass.assignment_type_id
  LEFT JOIN dbo.AssignmentStates ast ON ast.Id = ass.assignment_state_id
  LEFT JOIN dbo.Organizations org ON org.Id = ass.executor_organization_id
WHERE
  ass.my_event_id = @Id
ORDER BY
  CASE
    WHEN ast.name <> N''Закрито'' THEN 1
    WHEN ast.name = N''Закрито'' THEN 2
  END,
  main_executor DESC 
 OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY ; ' ;
 EXEC sp_executesql @Query, N'@Id INT, @pageOffsetRows BIGINT, @pageLimitRows BIGINT ', 
							@Id = @Id,
							@pageOffsetRows = @pageOffsetRows,
							@pageLimitRows = @pageLimitRows
							;