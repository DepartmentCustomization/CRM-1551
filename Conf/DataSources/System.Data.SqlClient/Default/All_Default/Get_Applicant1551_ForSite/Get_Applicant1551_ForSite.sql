--  DECLARE @ApplicantId INT = 1515940;

SELECT
	(
		SELECT
			TOP 1 full_name
		FROM
			[dbo].[Applicants]
		WHERE
			Id = @ApplicantId
	) AS [1551_Applicant_PIB],
	---> заметил что если больше 1 номера то выбирает как " номер ,номер" 
	---> а также всегда идет пробел в начале строки, обработал
	ltrim(
	replace(
	stuff(
		(
			SELECT
				N' ,' + p.phone_number
			FROM
				[dbo].[ApplicantPhones] p
			WHERE
				p.applicant_id = @ApplicantId
				AND len(isnull(p.phone_number, N'')) > 0 FOR XML PATH('')
		),
		2,
		1,
		N''
	),
	' ,', ', ')
	) AS [1551_Applicant_Phone],
	stuff(
		(
			SELECT
				N' ,' +CASE
					WHEN [Buildings].[index] IS NULL THEN N''
					ELSE isnull(rtrim([Buildings].[index]), N'') + N', '
				END + isnull([StreetTypes].shortname, N'') + N' ' + isnull([Streets].name, N'') + N' ' + isnull([Buildings].name, N'') + ISNULL(N', п.' + LTRIM([LiveAddress].entrance), N'') + CASE
					WHEN len(isnull([LiveAddress].flat, N'')) = 0 THEN N''
					ELSE N', кв. ' + isnull(rtrim([LiveAddress].flat), N'')
				END
			FROM
				[dbo].[Applicants] p
				LEFT JOIN [dbo].[LiveAddress] [LiveAddress] ON [LiveAddress].applicant_id = p.Id
				LEFT JOIN [dbo].[Buildings] [Buildings] ON [Buildings].Id = [LiveAddress].building_id
				LEFT JOIN [dbo].[Streets] [Streets] ON [Streets].Id = [Buildings].street_id
				LEFT JOIN [dbo].[StreetTypes] [StreetTypes] ON [StreetTypes].Id = [Streets].street_type_id
				LEFT JOIN [dbo].[Districts] [Districts] ON [Districts].Id = [Streets].district_id
			WHERE
				p.id = @ApplicantId FOR XML PATH('')
		),
		2,
		1,
		N''
	) AS [1551_Applicant_Address] ;