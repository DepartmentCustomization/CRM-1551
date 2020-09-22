--    DECLARE @Id INT = 2967587;
--    DECLARE @question INT = (SELECT question_id FROM dbo.Assignments WHERE Id = @Id);

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
    [Assignments].[Id],
    [Assignments].[registration_date],
    at.name AS ass_type_name,
    Organizations.short_name AS performer,
    [Assignments].[main_executor],
    ast.name AS ass_state_name,
    Assignments.execution_date,
    Assignments.question_id
FROM
    '+@Archive+N'[dbo].[Assignments] [Assignments] 
    LEFT JOIN [dbo].[AssignmentTypes] [at] ON [at].Id = Assignments.assignment_type_id
    LEFT JOIN [dbo].[AssignmentStates] [ast] ON [ast].Id = Assignments.assignment_state_id
    LEFT JOIN [dbo].[Organizations] [Organizations] ON Organizations.Id = Assignments.executor_organization_id
WHERE
    Assignments.question_id = @question
    AND [Assignments].[Id] <> @Id
    AND #filter_columns#
ORDER BY
    main_executor DESC,
    ass_state_name 
OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY 
; ' ;

 EXEC sp_executesql @Query, N'@question INT, @Id INT, @pageOffsetRows BIGINT, @pageLimitRows BIGINT  ', 
							@question = @question,
							@Id = @Id,
                            @pageOffsetRows = @pageOffsetRows,
                            @pageLimitRows = @pageLimitRows;