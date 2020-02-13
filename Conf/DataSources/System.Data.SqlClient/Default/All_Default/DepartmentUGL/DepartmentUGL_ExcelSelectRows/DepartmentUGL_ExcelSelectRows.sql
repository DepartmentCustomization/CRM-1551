
/*
declare @dateFrom DATE='2001-02-01';
declare @dateTo DATE='2020-12-12';
declare @user_id nvarchar(128)=N'Вася';
declare @is_worked BIT='true';
declare @uploaded NVARCHAR(MAX)=N'N''Вася'',N''Степа''';
DECLARE @processed NVARCHAR(MAX)=N'N''Вася'',N''Степа''';
*/
--SELECT convert(nvarchar(10),CONVERT(DATE, @dateFrom))

DECLARE @dateFrom_f NVARCHAR(100)=
CASE WHEN N'CONVERT(DATE, Z.[Створено]) >= '''+CONVERT(NVARCHAR(10),CONVERT(DATE, @dateFrom))+N'''' IS NULL THEN N'1=1'
ELSE N'CONVERT(DATE, Z.[Створено]) >= '''+CONVERT(NVARCHAR(10),CONVERT(DATE, @dateFrom))+N'''' END;

DECLARE @dateTo_f NVARCHAR(100)=
CASE WHEN N'CONVERT(DATE, Z.[Створено]) <= '''+CONVERT(NVARCHAR(10),CONVERT(DATE, @dateTo))+N'''' IS NULL THEN N'1=1'
ELSE N'CONVERT(DATE, Z.[Створено]) <= '''+CONVERT(NVARCHAR(10),CONVERT(DATE, @dateTo))+N'''' END;

DECLARE @is_worked_f NVARCHAR(40)=
CASE WHEN @is_worked IS NULL THEN N'1=1' 
ELSE N'Z.[Опрацьовано]='+CONVERT(NVARCHAR(10), @is_worked)  END;

/*
DECLARE @uploaded_f NVARCHAR(MAX)=
CASE WHEN @uploaded IS NULL  THEN N'1=1'
ELSE N'Z.[Завантажив] IN ('+@uploaded+N')' END;

DECLARE @processed_f NVARCHAR(MAX)=
CASE WHEN @processed IS NULL  THEN N'1=1'
ELSE N'Z.[Опрацював] IN ('+@processed+N')' END;
*/
--SELECT @dateFrom_f, @dateTo_f, @is_worked_f, @uploaded_f,
--@dateFrom_f+N' AND '+@dateTo_f+N' AND '+@is_worked_f+N' AND '+@uploaded_f

DECLARE @param NVARCHAR(MAX)=@dateFrom_f+N' AND '+@dateTo_f+N' AND '+@is_worked_f; --+N' AND '+@uploaded_f+N' AND '+@processed_f;

--SELECT @param

IF OBJECT_ID('tempdb..#temp_main') IS NOT NULL
BEGIN
	DROP TABLE #temp_main;
END;

ELSE
	BEGIN

CREATE TABLE #temp_main (Id INT, EnterNumber NVARCHAR(100), RegistrationDate DATETIME, Applicant NVARCHAR(MAX),
[ADDRESS] NVARCHAR(500), Content NVARCHAR(MAX), QuestionNumber NVARCHAR(20), [Uploaded] NVARCHAR(128), [Processed] NVARCHAR(128));
	END
-- через параметр, запрос переписую

DECLARE @exec NVARCHAR(MAX)=
N'
SELECT
		Z.Id
	   ,Z.[№ звернення] [EnterNumber]
	   ,Z.[Створено] [RegistrationDate]
	   ,Z.[Заявник] [Applicant]
	   ,Z.[Адреса] [Address]
	   ,Z.[Зміст] [Content]
	   --,Z.[Питання] QuestionNumber
	   ,q.registration_number QuestionNumber
	   ,Z.[Завантажив] [Uploaded]
	   ,Z.[Опрацював] [Processed]
	FROM [dbo].[Звернення УГЛ] z
	LEFT JOIN [dbo].[Questions] q ON Z.Appeals_id=q.appeal_id
	WHERE '+@param;

	INSERT INTO #temp_main
	(Id, EnterNumber, RegistrationDate, Applicant, [ADDRESS], Content, QuestionNumber, [Uploaded], [Processed]
	)

	EXEC(@exec); 

	SELECT Id, EnterNumber, RegistrationDate, Applicant, [ADDRESS], Content, QuestionNumber, [Uploaded], [Processed]
	FROM #temp_main
	WHERE #filter_columns#
    #sort_columns#
    offset @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS only;

	DROP TABLE #temp_main;