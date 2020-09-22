-- DECLARE @appealNum NVARCHAR(400) = N'0-309, 0-305, 0-307';

DECLARE @NumVals NVARCHAR(max) = REPLACE(@appealNum, N', ', N',');

DECLARE @NumsTab TABLE (Num NVARCHAR(50));
INSERT INTO @NumsTab(Num)
SELECT 
	[value] 
FROM STRING_SPLIT(@NumVals, ',');

DECLARE @Archive NVARCHAR(400) = '['+(SELECT TOP 1 [IP]+'].['+[DatabaseName]+'].' FROM [dbo].[SetingConnetDatabase] WHERE Code = N'Archive');

DECLARE @IsHere BIT = IIF(
   (
      SELECT
         COUNT(1)
      FROM
         dbo.Appeals
      WHERE
         registration_number IN (SELECT Num FROM @NumsTab)
   ) = 0,
   0,
   1
);

IF(@IsHere = 1)
BEGIN
	SET @Archive = SPACE(1);
END

DECLARE @Part1 NVARCHAR(MAX) =
N'DECLARE @input_str NVARCHAR(max) = REPLACE(@appealNum, N'', '', N'','');
DECLARE @table TABLE (Num NVARCHAR(50));

INSERT INTO @table(Num)
SELECT 
	[value] 
FROM STRING_SPLIT(@input_str, '','');

SELECT
	t.*
FROM
	(
		SELECT
			[Assignments].Id,
			[ReceiptSources].name navigation,
			[Questions].registration_number,
			[QuestionTypes].name QuestionType,
			[Applicants].full_name zayavnyk,
			[StreetTypes].shortname + Streets.name + N'', '' + [Buildings].name adress,
			[Organizations].short_name vykonavets,
			[Applicants].Id zayavnykId,
			[Questions].Id QuestionId,
			[AssignmentConsiderations].short_answer,
			[Questions].question_content,
			[Applicants].[ApplicantAdress] adressZ
		FROM
			'+@Archive+N'[dbo].[Assignments] WITH (nolock)
			INNER JOIN '+@Archive+N'[dbo].[Questions] WITH (nolock) ON [Assignments].question_id = [Questions].Id
			INNER JOIN '+@Archive+N'[dbo].[Appeals] WITH (nolock) ON [Questions].appeal_id = [Appeals].Id
			INNER JOIN [ReceiptSources] WITH (nolock) ON [Appeals].receipt_source_id = [ReceiptSources].Id
			LEFT JOIN [QuestionTypes] WITH (nolock) ON [Questions].question_type_id = [QuestionTypes].Id
			LEFT JOIN [Applicants] WITH (nolock) ON [Appeals].applicant_id = [Applicants].Id
			LEFT JOIN [Objects] WITH (nolock) ON [Questions].[object_id] = [Objects].Id
			LEFT JOIN [Buildings] WITH (nolock) ON [Objects].builbing_id = [Buildings].Id
			LEFT JOIN [Streets] WITH (nolock) ON [Buildings].street_id = [Streets].Id
			LEFT JOIN [StreetTypes] WITH (nolock) ON [Streets].street_type_id = [StreetTypes].Id
			LEFT JOIN [Organizations] WITH (nolock) ON [Assignments].executor_organization_id = [Organizations].Id
			LEFT JOIN '+@Archive+N'[dbo].[AssignmentConsiderations] WITH (nolock) ON [AssignmentConsiderations].Id = Assignments.current_assignment_consideration_id
		WHERE
			(
				[Appeals].registration_number IN (
					SELECT
						Num
					FROM
						@table o
				)
			)
		UNION ' ;
DECLARE @Part2 NVARCHAR(MAX) =
	N'SELECT
			[Assignments].Id,
			[ReceiptSources].name navigation,
			[Questions].registration_number,
			[QuestionTypes].name QuestionType,
			[Applicants].full_name zayavnyk,
			[StreetTypes].shortname + Streets.name + N'', '' + [Buildings].name adress,
			[Organizations].short_name vykonavets,
			[Applicants].Id zayavnykId,
			[Questions].Id QuestionId,
			[AssignmentConsiderations].short_answer,
			[Questions].question_content,
			[Applicants].[ApplicantAdress] adressZ
		FROM
			'+@Archive+N'[dbo].[Assignments] WITH (nolock)
			INNER JOIN '+@Archive+N'[dbo].[Questions] WITH (nolock) ON [Assignments].question_id = [Questions].Id
			INNER JOIN '+@Archive+N'[dbo].[Appeals] WITH (nolock) ON [Questions].appeal_id = [Appeals].Id
			INNER JOIN [ReceiptSources] WITH (nolock) ON [Appeals].receipt_source_id = [ReceiptSources].Id
			LEFT JOIN [QuestionTypes] WITH (nolock) ON [Questions].question_type_id = [QuestionTypes].Id
			LEFT JOIN [Applicants] WITH (nolock) ON [Appeals].applicant_id = [Applicants].Id
			LEFT JOIN [Objects] WITH (nolock) ON [Questions].[object_id] = [Objects].Id
			LEFT JOIN [Buildings] WITH (nolock) ON [Objects].builbing_id = [Buildings].Id
			LEFT JOIN [Streets] WITH (nolock) ON [Buildings].street_id = [Streets].Id
			LEFT JOIN [StreetTypes] WITH (nolock) ON [Streets].street_type_id = [StreetTypes].Id
			LEFT JOIN [Organizations] WITH (nolock) ON [Assignments].executor_organization_id = [Organizations].Id
			LEFT JOIN '+@Archive+N'[dbo].[AssignmentConsiderations] WITH (nolock) ON [AssignmentConsiderations].Id = Assignments.current_assignment_consideration_id
		WHERE
			(
				[Appeals].[enter_number] IN (
					SELECT
						Num
					FROM
						@table o
				)
			)
	) t ; ' ;
  DECLARE @Query NVARCHAR(MAX) = (SELECT @Part1 + @Part2);
  EXEC sp_executesql @Query, N'@appealNum NVARCHAR(400)', 
							@appealNum = @appealNum;