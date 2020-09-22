--    DECLARE @applicant_id INT = null;
--    DECLARE @appeal_id INT = null;
--    DECLARE @phone_number NVARCHAR(25) = null;
--    DECLARE @object_id INT = 15754;

DECLARE @LoadServerState INT;
SET
	@LoadServerState = (
		SELECT
			TOP (1) [LoadServer].[StateId]
		FROM
			[dbo].[LoadServer]
		ORDER BY
			[LoadServer].[Id] DESC
	) ;
IF(
		OBJECT_ID('tempdb..#tempTypeQuestion') IS NOT NULL
	) 
BEGIN 
DROP TABLE #tempTypeQuestion ;
END 
CREATE TABLE #tempTypeQuestion
(
	Id INT IDENTITY(1, 1),
	[Тип] NVARCHAR(100),
	[Зареєстровано] INT,
	[В роботі] INT,
	[Просрочено] INT,
	[Виконано] INT,
	[Доопрацювання] INT
) WITH (DATA_COMPRESSION = PAGE);


IF(@applicant_id IS NOT NULL)
BEGIN
IF @LoadServerState = 1 
BEGIN
INSERT INTO
	#tempTypeQuestion
	(
		[Тип],
		[Зареєстровано],
		[В роботі],
		[Просрочено],
		[Виконано],
		[Доопрацювання]
	)
SELECT
	N'питання заявника' AS [Тип],
	0 AS [З],
	0 AS [Р],
	0 AS [П],
	0 AS [В],
	0 AS [Д]
UNION
ALL
SELECT
	N'питання заявника (old)' AS [Тип],
	0 AS [З],
	0 AS [Р],
	0 AS [П],
	0 AS [В],
	0 AS [Д]
UNION
ALL
SELECT
	N'консультації заявника' AS [Тип],
	0 AS [З],
	0 AS [Р],
	0 AS [П],
	0 AS [В],
	0 AS [Д]
UNION
ALL
SELECT
	N'питання за помешканням заявника' AS [Тип],
	0 AS [З],
	0 AS [Р],
	0 AS [П],
	0 AS [В],
	0 AS [Д]
UNION
ALL
SELECT
	N'питання з номеру телефону заявника' AS [Тип],
	0 AS [З],
	0 AS [Р],
	0 AS [П],
	0 AS [В],
	0 AS [Д]
UNION
ALL
SELECT
	N'питання по будинку' AS [Тип],
	0 AS [З],
	0 AS [Р],
	0 AS [П],
	0 AS [В],
	0 AS [Д]
UNION
ALL
SELECT
	N'заявки за Городком' AS [Тип],
	0 AS [З],
	0 AS [Р],
	0 AS [П],
	0 AS [В],
	0 AS [Д] 
	;
UPDATE
	#tempTypeQuestion SET [Зареєстровано] = (SELECT count(1)
FROM
	[dbo].[Questions] [Questions] WITH (nolock)
	LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
	LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
	LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
WHERE
	[Appeals].applicant_id = @applicant_id
	AND [QuestionStates].[name] IN (N'Зареєстровано')
),
[В роботі] = (
	SELECT
		count(1)
	FROM
		[dbo].[Questions] [Questions] WITH (nolock)
		LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
		LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
		LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	WHERE
		[Appeals].applicant_id = @applicant_id
		AND [QuestionStates].[name] IN (N'В роботі', N'На перевірці')
),
[Просрочено] = (
	SELECT
		count(1)
	FROM
		[dbo].[Questions] [Questions] WITH (nolock)
		LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
		LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
		LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	WHERE
		[Appeals].applicant_id = @applicant_id
		AND [Questions].[control_date] <= getutcdate()
		AND [QuestionStates].[name] NOT IN (N'Закрито')
),
[Виконано] = (
	SELECT
		count(1)
	FROM
		[dbo].[Questions] [Questions] WITH (nolock)
		LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
		LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
		LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	WHERE
		[Appeals].applicant_id = @applicant_id
		AND [QuestionStates].[name] IN (N'Закрито')
),
[Доопрацювання] = (
	SELECT
		count(1)
	FROM
		[dbo].[Questions] [Questions] WITH (nolock)
		LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
		LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
		LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	WHERE
		[Appeals].applicant_id = @applicant_id
		AND [QuestionStates].[name] IN (N'Не виконано')
)
WHERE
	[Тип] = N'питання заявника' ;
UPDATE
	#tempTypeQuestion SET [Зареєстровано] = (SELECT count(1)
FROM
	[Consultations] [Consultations] WITH (nolock)
	LEFT JOIN [dbo].[Questions] [Questions] WITH (nolock) ON [Consultations].question_id = [Questions].Id 
	LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
	LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
	LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
WHERE
	[Consultations].appeal_id = @appeal_id
	AND [Consultations].phone_number = @phone_number
)
WHERE
	[Тип] = N'консультації заявника' ;
UPDATE
	#tempTypeQuestion SET [Зареєстровано] = (SELECT count(1)
FROM
	[dbo].[Questions] [Questions] WITH (nolock)
	LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
	LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
	LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
WHERE
	[Appeals].phone_number IN (
		SELECT
			[ApplicantPhones].phone_number
		FROM
			[dbo].[ApplicantPhones] WITH (nolock)
		WHERE
			[ApplicantPhones].phone_number = @phone_number
	)
	AND [QuestionStates].[name] IN (N'Зареєстровано')
),
[В роботі] = (
	SELECT
		count(1)
	FROM
		[dbo].[Questions] [Questions] WITH (nolock)
		LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
		LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
		LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	WHERE
		[Appeals].phone_number IN (
			SELECT
				[ApplicantPhones].phone_number
			FROM
				[dbo].[ApplicantPhones] WITH (nolock)
			WHERE
				[ApplicantPhones].phone_number = @phone_number
		)
		AND [QuestionStates].[name] IN (N'В роботі', N'На перевірці')
),
[Просрочено] = (
	SELECT
		count(1)
	FROM
	[dbo].[Questions] [Questions] WITH (nolock)
	LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
	LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
	LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	WHERE
		[Appeals].phone_number IN (
			SELECT
				[ApplicantPhones].phone_number
			FROM
				[dbo].[ApplicantPhones] WITH (nolock)
			WHERE
				[ApplicantPhones].phone_number = @phone_number
		)
		AND [Questions].[control_date] <= getutcdate()
		AND [QuestionStates].[name] NOT IN (N'Закрито')
),
[Виконано] = (
	SELECT
		count(1)
	FROM
	[dbo].[Questions] [Questions] WITH (nolock)
	LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
	LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
	LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	WHERE
		[Appeals].phone_number IN (
			SELECT
				[ApplicantPhones].phone_number
			FROM
				[dbo].[ApplicantPhones] WITH (nolock)
			WHERE
				[ApplicantPhones].phone_number = @phone_number
		)
		AND [QuestionStates].[name] IN (N'Закрито')
),
[Доопрацювання] = (
	SELECT
		count(1)
	FROM
	[dbo].[Questions] [Questions] WITH (nolock)
	LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
	LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
	LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	WHERE
		[Appeals].phone_number IN (
			SELECT
				[ApplicantPhones].phone_number
			FROM
				[dbo].[ApplicantPhones] WITH (nolock)
			WHERE
				[ApplicantPhones].phone_number = @phone_number
		)
		AND [QuestionStates].[name] IN (N'Не виконано')
)
WHERE
	[Тип] = N'питання з номеру телефону заявника' ;
UPDATE
	#tempTypeQuestion SET [Зареєстровано] = (SELECT count(1)
FROM
	[dbo].[Questions] [Questions] WITH (nolock)
	LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
	LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
	LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	LEFT JOIN [dbo].[LiveAddress] [LiveAddress] WITH (nolock) ON [LiveAddress].applicant_id = [Applicants].Id
WHERE
	[Questions].[object_id] IN (
		SELECT
			[LiveAddress].building_id
		FROM
			[dbo].[LiveAddress] WITH (nolock)
		WHERE
			[LiveAddress].applicant_id = @applicant_id
	)
	AND [QuestionStates].[name] IN (N'Зареєстровано')
),
[В роботі] = (
	SELECT
		count(1)
	FROM
	[dbo].[Questions] [Questions] WITH (nolock)
	LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
	LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
	LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	LEFT JOIN [dbo].[LiveAddress] [LiveAddress] WITH (nolock) ON [LiveAddress].applicant_id = [Applicants].Id
	WHERE
		[Questions].[object_id] IN (
			SELECT
				[LiveAddress].building_id
			FROM
				[dbo].[LiveAddress] WITH (nolock)
			WHERE
				[LiveAddress].applicant_id = @applicant_id
		)
		AND [QuestionStates].[name] IN (N'В роботі', N'На перевірці')
),
[Просрочено] = (
	SELECT
		count(1)
	FROM
	[dbo].[Questions] [Questions] WITH (nolock)
	LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
	LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
	LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	LEFT JOIN [dbo].[LiveAddress] [LiveAddress] WITH (nolock) ON [LiveAddress].applicant_id = [Applicants].Id
	WHERE
		[Questions].[object_id] IN (
			SELECT
				[LiveAddress].building_id
			FROM
				[dbo].[LiveAddress] WITH (nolock)
			WHERE
				[LiveAddress].applicant_id = @applicant_id
		)
		AND [Questions].[control_date] <= getutcdate()
		AND [QuestionStates].[name] NOT IN (N'Закрито')
),
[Виконано] = (
	SELECT
		count(1)
	FROM
	[dbo].[Questions] [Questions] WITH (nolock)
	LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
	LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
	LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	LEFT JOIN [dbo].[LiveAddress] [LiveAddress] WITH (nolock) ON [LiveAddress].applicant_id = [Applicants].Id
	WHERE
		[Questions].[object_id] IN (
			SELECT
				[LiveAddress].building_id
			FROM
				[dbo].[LiveAddress] WITH (nolock)
			WHERE
				[LiveAddress].applicant_id = @applicant_id
		)
		AND [QuestionStates].[name] IN (N'Закрито')
),
[Доопрацювання] = (
	SELECT
		count(1)
	FROM
	[dbo].[Questions] [Questions] WITH (nolock)
	LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
	LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
	LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	LEFT JOIN [dbo].[LiveAddress] [LiveAddress] WITH (nolock) ON [LiveAddress].applicant_id = [Applicants].Id
	WHERE
		[Questions].[object_id] IN (
			SELECT
				[LiveAddress].building_id
			FROM
				[dbo].[LiveAddress] WITH (nolock)
			WHERE
				[LiveAddress].applicant_id = @applicant_id
		)
		AND [QuestionStates].[name] IN (N'Не виконано')
)
WHERE
	[Тип] = N'питання по будинку' ;
UPDATE
	#tempTypeQuestion SET [Зареєстровано] = (SELECT count(1)
FROM
	[dbo].[Questions] [Questions] WITH (nolock)
	LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
	LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
	LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	LEFT JOIN [dbo].[LiveAddress] [LiveAddress] WITH (nolock) ON [LiveAddress].applicant_id = [Applicants].Id
WHERE
	rtrim([LiveAddress].building_id) + N'/' + rtrim([LiveAddress].flat) IN (
		SELECT
			rtrim([LiveAddress].building_id) + N'/' + rtrim([LiveAddress].flat)
		FROM
			[dbo].[LiveAddress] WITH (nolock)
		WHERE
			[LiveAddress].applicant_id = @applicant_id
	)
	AND [QuestionStates].[name] IN (N'Зареєстровано')
),
[В роботі] = (
	SELECT
		count(1)
	FROM
	[dbo].[Questions] [Questions] WITH (nolock)
	LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
	LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
	LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	LEFT JOIN [dbo].[LiveAddress] [LiveAddress] WITH (nolock) ON [LiveAddress].applicant_id = [Applicants].Id
	WHERE
		rtrim([LiveAddress].building_id) + N'/' + rtrim([LiveAddress].flat) IN (
			SELECT
				rtrim([LiveAddress].building_id) + N'/' + rtrim([LiveAddress].flat)
			FROM
				[dbo].[LiveAddress] WITH (nolock)
			WHERE
				[LiveAddress].applicant_id = @applicant_id
		)
		AND [QuestionStates].[name] IN (N'В роботі', N'На перевірці')
),
[Просрочено] = (
	SELECT
		count(1)
	FROM
	[dbo].[Questions] [Questions] WITH (nolock)
	LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
	LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
	LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	LEFT JOIN [dbo].[LiveAddress] [LiveAddress] WITH (nolock) ON [LiveAddress].applicant_id = [Applicants].Id
	WHERE
		rtrim([LiveAddress].building_id) + N'/' + rtrim([LiveAddress].flat) IN (
			SELECT
				rtrim([LiveAddress].building_id) + N'/' + rtrim([LiveAddress].flat)
			FROM
				[dbo].[LiveAddress] WITH (nolock)
			WHERE
				[LiveAddress].applicant_id = @applicant_id
		)
		AND [Questions].[control_date] <= getutcdate()
		AND [QuestionStates].[name] NOT IN (N'Закрито')
),
[Виконано] = (
	SELECT
		count(1)
	FROM
	[dbo].[Questions] [Questions] WITH (nolock)
	LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
	LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
	LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	LEFT JOIN [dbo].[LiveAddress] [LiveAddress] WITH (nolock) ON [LiveAddress].applicant_id = [Applicants].Id
	WHERE
		rtrim([LiveAddress].building_id) + N'/' + rtrim([LiveAddress].flat) IN (
			SELECT
				rtrim([LiveAddress].building_id) + N'/' + rtrim([LiveAddress].flat)
			FROM
				[dbo].[LiveAddress] WITH (nolock)
			WHERE
				[LiveAddress].applicant_id = @applicant_id
		)
		AND [QuestionStates].[name] IN (N'Закрито')
),
[Доопрацювання] = (
	SELECT
		count(1)
	FROM
	[dbo].[Questions] [Questions] WITH (nolock)
	LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
	LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
	LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	LEFT JOIN [dbo].[LiveAddress] [LiveAddress] WITH (nolock) ON [LiveAddress].applicant_id = [Applicants].Id
	WHERE
		rtrim([LiveAddress].building_id) + N'/' + rtrim([LiveAddress].flat) IN (
			SELECT
				rtrim([LiveAddress].building_id) + N'/' + rtrim([LiveAddress].flat)
			FROM
				[dbo].[LiveAddress] WITH (nolock)
			WHERE
				[LiveAddress].applicant_id = @applicant_id
		)
		AND [QuestionStates].[name] IN (N'Не виконано')
)
WHERE
	[Тип] = N'питання за помешканням заявника' ;
UPDATE
	#tempTypeQuestion SET [Зареєстровано] = (SELECT count(1)
FROM
	[CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] [Gorodok_1551_houses] WITH (nolock)
	LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_claims] [Lokal_copy_gorodok_claims] WITH (nolock) ON [Lokal_copy_gorodok_claims].[object_id] = [Gorodok_1551_houses].gorodok_houses_id
	LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].Claims_states Claims_states WITH (nolock) ON Claims_states.[name] = [Lokal_copy_gorodok_claims].[status]
WHERE
	[Gorodok_1551_houses].[1551_houses_id] IN (
		SELECT
			[LiveAddress].building_id
		FROM
			[dbo].[LiveAddress] WITH (nolock)
		WHERE
			building_id IS NOT NULL
			AND [LiveAddress].applicant_id = @applicant_id
	)
	AND Claims_states.[1551_state] IN (
		SELECT
			[QuestionStates].Id
		FROM
			[QuestionStates] WITH (nolock)
		WHERE
			[QuestionStates].[name] IN (N'Зареєстровано')
	)
),
[В роботі] = (
	SELECT
		count(1)
	FROM
		[CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] [Gorodok_1551_houses] WITH (nolock)
		LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_claims] [Lokal_copy_gorodok_claims] WITH (nolock) ON [Lokal_copy_gorodok_claims].[object_id] = [Gorodok_1551_houses].gorodok_houses_id
		LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].Claims_states Claims_states WITH (nolock) ON Claims_states.[name] = [Lokal_copy_gorodok_claims].[status]
	WHERE
		[Gorodok_1551_houses].[1551_houses_id] IN (
			SELECT
				[LiveAddress].building_id
			FROM
				[dbo].[LiveAddress] WITH (nolock)
			WHERE
				building_id IS NOT NULL
				AND [LiveAddress].applicant_id = @applicant_id
		)
		AND Claims_states.[1551_state] IN (
			SELECT
				[QuestionStates].Id
			FROM
				[QuestionStates] WITH (nolock)
			WHERE
				[QuestionStates].[name] IN (N'В роботі', N'На перевірці')
		)
),
[Просрочено] = (
	SELECT
		count(1)
	FROM
		[CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] [Gorodok_1551_houses] WITH (nolock)
		LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_claims] [Lokal_copy_gorodok_claims] WITH (nolock) ON [Lokal_copy_gorodok_claims].[object_id] = [Gorodok_1551_houses].gorodok_houses_id
		LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].Claims_states Claims_states WITH (nolock) ON Claims_states.[name] = [Lokal_copy_gorodok_claims].[status]
	WHERE
		[Gorodok_1551_houses].[1551_houses_id] IN (
			SELECT
				[LiveAddress].building_id
			FROM
				[dbo].[LiveAddress] WITH (nolock)
			WHERE
				building_id IS NOT NULL
				AND [LiveAddress].applicant_id = @applicant_id
		)
		AND Claims_states.[1551_state] IN (
			SELECT
				[QuestionStates].Id
			FROM
				[QuestionStates] WITH (nolock)
			WHERE
				[QuestionStates].[name] NOT IN (N'Закрито')
		)
		AND [Lokal_copy_gorodok_claims].[plan_finish_date] <= getutcdate()
),
[Виконано] = (
	SELECT
		count(1)
	FROM
		[CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] [Gorodok_1551_houses] WITH (nolock)
		LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_claims] [Lokal_copy_gorodok_claims] WITH (nolock) ON [Lokal_copy_gorodok_claims].[object_id] = [Gorodok_1551_houses].gorodok_houses_id
		LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].Claims_states Claims_states WITH (nolock) ON Claims_states.[name] = [Lokal_copy_gorodok_claims].[status]
	WHERE
		[Gorodok_1551_houses].[1551_houses_id] IN (
			SELECT
				[LiveAddress].building_id
			FROM
				[dbo].[LiveAddress] WITH (nolock)
			WHERE
				building_id IS NOT NULL
				AND [LiveAddress].applicant_id = @applicant_id
		)
		AND Claims_states.[1551_state] IN (
			SELECT
				[QuestionStates].Id
			FROM
				[QuestionStates] WITH (nolock)
			WHERE
				[QuestionStates].[name] IN (N'Закрито')
		)
)
WHERE
	[Тип] = N'заявки за Городком' ; 
END 
IF @LoadServerState = 2 
BEGIN
INSERT INTO
	#tempTypeQuestion
	(
		[Тип],
		[Зареєстровано],
		[В роботі],
		[Просрочено],
		[Виконано],
		[Доопрацювання]
	)
SELECT
	N'питання заявника' AS [Тип],
	0 AS [З],
	0 AS [Р],
	0 AS [П],
	0 AS [В],
	0 AS [Д]
UNION
ALL
SELECT
	N'питання заявника (old)' AS [Тип],
	0 AS [З],
	0 AS [Р],
	0 AS [П],
	0 AS [В],
	0 AS [Д]
UNION
ALL
SELECT
	N'заявки за Городком' AS [Тип],
	0 AS [З],
	0 AS [Р],
	0 AS [П],
	0 AS [В],
	0 AS [Д]
	;
UPDATE
	#tempTypeQuestion SET [Зареєстровано] = (SELECT count(1)
FROM
	[dbo].[Questions] [Questions] WITH (nolock)
	LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
	LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
	LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
WHERE
	[Appeals].applicant_id = @applicant_id
	AND [QuestionStates].[name] IN (N'Зареєстровано')
),
[В роботі] = (
	SELECT
		count(1)
	FROM
		[dbo].[Questions] [Questions] WITH (nolock)
		LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
		LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
		LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	WHERE
		[Appeals].applicant_id = @applicant_id
		AND [QuestionStates].[name] IN (N'В роботі', N'На перевірці')
),
[Просрочено] = (
	SELECT
		count(1)
	FROM
		[dbo].[Questions] [Questions] WITH (nolock)
		LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
		LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
		LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	WHERE
		[Appeals].applicant_id = @applicant_id
		AND [Questions].[control_date] <= getutcdate()
		AND [QuestionStates].[name] NOT IN (N'Закрито')
),
[Виконано] = (
	SELECT
		count(1)
	FROM
		[dbo].[Questions] [Questions] WITH (nolock)
	 	LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
		LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
		LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	WHERE
		[Appeals].applicant_id = @applicant_id
		AND [QuestionStates].[name] IN (N'Закрито')
),
[Доопрацювання] = (
	SELECT
		count(1)
	FROM
		[dbo].[Questions] [Questions] WITH (nolock)
		LEFT JOIN [dbo].[Appeals] [Appeals] WITH (nolock) ON [Appeals].Id = [Questions].appeal_id
		LEFT JOIN [dbo].[Applicants] [Applicants] WITH (nolock) ON [Applicants].Id = [Appeals].applicant_id
		LEFT JOIN [dbo].[QuestionStates] [QuestionStates] WITH (nolock) ON [QuestionStates].Id = [Questions].question_state_id
	WHERE
		[Appeals].applicant_id = @applicant_id
		AND [QuestionStates].[name] IN (N'Не виконано')
)
WHERE
	[Тип] = N'питання заявника' ;
UPDATE
	#tempTypeQuestion SET [Зареєстровано] = (SELECT count(1)
FROM
	[CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] [Gorodok_1551_houses] WITH (nolock)
	LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_claims] [Lokal_copy_gorodok_claims] WITH (nolock) ON [Lokal_copy_gorodok_claims].[object_id] = [Gorodok_1551_houses].gorodok_houses_id
	LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].Claims_states Claims_states WITH (nolock) ON Claims_states.[name] = [Lokal_copy_gorodok_claims].[status]
WHERE
	[Gorodok_1551_houses].[1551_houses_id] IN (
		SELECT
			[LiveAddress].building_id
		FROM
			[dbo].[LiveAddress] WITH (nolock)
		WHERE
			building_id IS NOT NULL
			AND [LiveAddress].applicant_id = @applicant_id
	)
	AND Claims_states.[1551_state] IN (
		SELECT
			[QuestionStates].Id
		FROM
			[QuestionStates] WITH (nolock)
		WHERE
			[QuestionStates].[name] IN (N'Зареєстровано')
	)
),
[В роботі] = (
	SELECT
		count(1)
	FROM
		[CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] [Gorodok_1551_houses] WITH (nolock)
		LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_claims] [Lokal_copy_gorodok_claims] WITH (nolock) ON [Lokal_copy_gorodok_claims].[object_id] = [Gorodok_1551_houses].gorodok_houses_id
		LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].Claims_states Claims_states WITH (nolock) ON Claims_states.[name] = [Lokal_copy_gorodok_claims].[status]
	WHERE
		[Gorodok_1551_houses].[1551_houses_id] IN (
			SELECT
				[LiveAddress].building_id
			FROM
				[dbo].[LiveAddress] WITH (nolock)
			WHERE
				building_id IS NOT NULL
				AND [LiveAddress].applicant_id = @applicant_id
		)
		AND Claims_states.[1551_state] IN (
			SELECT
				[QuestionStates].Id
			FROM
				[QuestionStates] WITH (nolock)
			WHERE
				[QuestionStates].[name] IN (N'В роботі', N'На перевірці')
		)
),
[Просрочено] = (
	SELECT
		count(1)
	FROM
		[CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] [Gorodok_1551_houses] WITH (nolock)
		LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_claims] [Lokal_copy_gorodok_claims] WITH (nolock) ON [Lokal_copy_gorodok_claims].[object_id] = [Gorodok_1551_houses].gorodok_houses_id
		LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].Claims_states Claims_states WITH (nolock) ON Claims_states.[name] = [Lokal_copy_gorodok_claims].[status]
	WHERE
		[Gorodok_1551_houses].[1551_houses_id] IN (
			SELECT
				[LiveAddress].building_id
			FROM
				[dbo].[LiveAddress] WITH (nolock)
			WHERE
				building_id IS NOT NULL
				AND [LiveAddress].applicant_id = @applicant_id
		)
		AND Claims_states.[1551_state] IN (
			SELECT
				[QuestionStates].Id
			FROM
				[QuestionStates] WITH (nolock)
			WHERE
				[QuestionStates].[name] NOT IN (N'Закрито')
		)
		AND [Lokal_copy_gorodok_claims].[plan_finish_date] <= getutcdate()
),
[Виконано] = (
	SELECT
		count(1)
	FROM
		[CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] [Gorodok_1551_houses] WITH (nolock)
		LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_claims] [Lokal_copy_gorodok_claims] WITH (nolock) ON [Lokal_copy_gorodok_claims].[object_id] = [Gorodok_1551_houses].gorodok_houses_id
		LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].Claims_states Claims_states WITH (nolock) ON Claims_states.[name] = [Lokal_copy_gorodok_claims].[status]
	WHERE
		[Gorodok_1551_houses].[1551_houses_id] IN (
			SELECT
				[LiveAddress].building_id
			FROM
				[dbo].[LiveAddress] WITH (nolock)
			WHERE
				building_id IS NOT NULL
				AND [LiveAddress].applicant_id = @applicant_id
		)
		AND Claims_states.[1551_state] IN (
			SELECT
				[QuestionStates].Id
			FROM
				[QuestionStates] WITH (nolock)
			WHERE
				[QuestionStates].[name] IN (N'Закрито')
		)
)
WHERE
	[Тип] = N'заявки за Городком' ; 
END
END
---> Для отбора только заявок из городка при выборе объекта (дом заявителя)
ELSE IF(@applicant_id IS NULL)
BEGIN
INSERT INTO
	#tempTypeQuestion
	(
		[Тип],
		[Зареєстровано],
		[В роботі],
		[Просрочено],
		[Виконано],
		[Доопрацювання]
	)
SELECT
	N'заявки за Городком' AS [Тип],
	0 AS [З],
	0 AS [Р],
	0 AS [П],
	0 AS [В],
	0 AS [Д] 
	;
UPDATE
	#tempTypeQuestion SET [Зареєстровано] = (SELECT count(1)
FROM
	[CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] [Gorodok_1551_houses] WITH (nolock)
	LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_claims] [Lokal_copy_gorodok_claims] WITH (nolock) ON [Lokal_copy_gorodok_claims].[object_id] = [Gorodok_1551_houses].gorodok_houses_id
	LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].Claims_states Claims_states WITH (nolock) ON Claims_states.[name] = [Lokal_copy_gorodok_claims].[status]
WHERE [Gorodok_1551_houses].[1551_houses_id] = @object_id
	AND Claims_states.[1551_state] IN (
		SELECT
			[QuestionStates].Id
		FROM
			[QuestionStates] WITH (nolock)
		WHERE
			[QuestionStates].[name] IN (N'Зареєстровано')
	)
),
[В роботі] = (
	SELECT
		count(1)
	FROM
		[CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] [Gorodok_1551_houses] WITH (nolock)
		LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_claims] [Lokal_copy_gorodok_claims] WITH (nolock) ON [Lokal_copy_gorodok_claims].[object_id] = [Gorodok_1551_houses].gorodok_houses_id
		LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].Claims_states Claims_states WITH (nolock) ON Claims_states.[name] = [Lokal_copy_gorodok_claims].[status]
	WHERE [Gorodok_1551_houses].[1551_houses_id] = @object_id
		AND Claims_states.[1551_state] IN (
			SELECT
				[QuestionStates].Id
			FROM
				[QuestionStates] WITH (nolock)
			WHERE
				[QuestionStates].[name] IN (N'В роботі', N'На перевірці')
		)
),
[Просрочено] = (
	SELECT
		count(1)
	FROM
		[CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] [Gorodok_1551_houses] WITH (nolock)
		LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_claims] [Lokal_copy_gorodok_claims] WITH (nolock) ON [Lokal_copy_gorodok_claims].[object_id] = [Gorodok_1551_houses].gorodok_houses_id
		LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].Claims_states Claims_states WITH (nolock) ON Claims_states.[name] = [Lokal_copy_gorodok_claims].[status]
	WHERE [Gorodok_1551_houses].[1551_houses_id] = @object_id
		AND Claims_states.[1551_state] IN (
			SELECT
				[QuestionStates].Id
			FROM
				[QuestionStates] WITH (nolock)
			WHERE
				[QuestionStates].[name] NOT IN (N'Закрито')
		)
		AND [Lokal_copy_gorodok_claims].[plan_finish_date] <= getutcdate()
),
[Виконано] = (
	SELECT
		count(1)
	FROM
		[CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] [Gorodok_1551_houses] WITH (nolock)
		LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_claims] [Lokal_copy_gorodok_claims] WITH (nolock) ON [Lokal_copy_gorodok_claims].[object_id] = [Gorodok_1551_houses].gorodok_houses_id
		LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].Claims_states Claims_states WITH (nolock) ON Claims_states.[name] = [Lokal_copy_gorodok_claims].[status]
	WHERE [Gorodok_1551_houses].[1551_houses_id] = @object_id
		AND Claims_states.[1551_state] IN (
			SELECT
				[QuestionStates].Id
			FROM
				[QuestionStates] WITH (nolock)
			WHERE
				[QuestionStates].[name] IN (N'Закрито')
		)
)
WHERE
	[Тип] = N'заявки за Городком' ; 
END
/*
 Id	name
 1	Зареєстровано
 2	В роботі
 3	На перевірці
 4	Не виконано
 5	Закрито
 */
SELECT
	Id,
	[Тип],
	[Зареєстровано],
	[В роботі],
	[Просрочено],
	[Виконано],
	[Доопрацювання]
FROM
	#tempTypeQuestion 
WHERE
	#filter_columns#
	#sort_columns#
OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY
 ;