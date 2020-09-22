--  DECLARE @Id INT = 5393466;

DECLARE @Archive NVARCHAR(400) = '['+(SELECT TOP 1 [IP]+'].['+[DatabaseName]+'].' FROM [dbo].[SetingConnetDatabase] WHERE Code = N'Archive');

DECLARE @IsHere BIT = IIF(
   (
      SELECT
         COUNT(1)
      FROM
         dbo.Appeals
      WHERE
         Id = @Id
   ) = 0,
   0,
   1
);

IF(@IsHere = 1)
BEGIN
	SET @Archive = SPACE(1);
END

DECLARE @Part1 NVARCHAR(MAX) = 
N'SELECT
   [Appeals].[Id],
   [Applicants].Id AS applicant_id,
   [Applicants].[full_name],
   [Appeals].[registration_date],
   [Appeals].[registration_number],
   ReceiptSources.Name AS receipt_source_name,
   ReceiptSources.Id AS receipt_source_id,
   [Appeals].[phone_number],
   [Appeals].[mail],
   [Appeals].[enter_number],
   [Appeals].[submission_date],
   [Appeals].[receipt_date],
   [Appeals].[start_date],
   [Appeals].[end_date],
   [Appeals].[article],
   [Appeals].[sender_name],
   [Appeals].[sender_post_adrress],
   [Appeals].[city_receipt],
   Workers.name AS [user_id],
   [Appeals].[edit_date],
   w.name AS [user_edit_id],
   IIF(
      Streets.name IS NULL,
      NULL,
      concat(
         Districts.name,
         N'' р-н., '',
         StreetTypes.shortname,
         '' '',
         Streets.name,
         '' '',
         Buildings.number,
         Buildings.letter,
         '', '',
         IIF(
            LiveAddress.[entrance] IS NULL,
            NULL,
            concat(N''п. '', LiveAddress.[entrance], '','')
         ),
         '' '',
         IIF(
            LiveAddress.flat IS NULL,
            NULL,
            concat(N''кв. '', LiveAddress.flat)
         )
      )
   ) AS adress,
   ApplicantPhones.phone_number AS app_phone,
   REVERSE(
      STUFF(
         REVERSE(
            CASE
               WHEN [ApplicantPrivilege].Name IS NOT NULL THEN N''пільги- '' + [ApplicantPrivilege].Name + N'', ''
               ELSE N''''
            END + CASE
               WHEN [SocialStates].Name IS NOT NULL THEN N''соц. стан- '' + [SocialStates].Name + N'', ''
               ELSE N''''
            END + + CASE
               WHEN [CategoryType].Name IS NOT NULL THEN N''категорія- '' + [CategoryType].Name + N'', ''
               ELSE N''''
            END + CASE
               WHEN [Applicants].sex = 2 THEN N''стать- чоловіча, ''
               WHEN [Applicants].sex = 1 THEN N''стать- жіноча, ''
               ELSE N''''
            END + CASE
               WHEN [Applicants].[birth_date] IS NOT NULL 
               THEN N''дата народження- '' + CONVERT(NVARCHAR(200), [Applicants].[birth_date]) + N'', ''
               ELSE N''''
            END + 
            CASE
               WHEN [birth_date] IS NULL
               AND [birth_year] IS NULL THEN N''''
               WHEN [birth_date] IS NOT NULL THEN CASE
                  WHEN MONTH([birth_date]) > MONTH(getdate())
                  OR (
                     MONTH([birth_date]) = MONTH(getdate())
                     AND DAY([birth_date]) >= DAY(getdate())
                  ) THEN N''вік- '' + ltrim(year(GETDATE()) - YEAR([birth_date]) -1) + N'', ''
                  ELSE N''вік- '' + ltrim(year(GETDATE()) - YEAR([birth_date])) + N'', ''
               END
               ELSE N''вік- '' + ltrim(year(GETDATE()) - [birth_year]) + N'', ''
            END
         ),
         1,
         2,
         ''''
      )
   ) q ';
DECLARE @Part2 NVARCHAR(MAX) =
N'FROM
   '+@Archive+N'[dbo].[Appeals] Appeals
   LEFT JOIN [dbo].ReceiptSources ReceiptSources ON ReceiptSources.Id = Appeals.receipt_source_id
   LEFT JOIN [dbo].Applicants Applicants ON Applicants.Id = Appeals.applicant_id
   LEFT JOIN [dbo].LiveAddress LiveAddress ON LiveAddress.applicant_id = Applicants.Id 
   AND LiveAddress.main = 1
   LEFT JOIN [dbo].Buildings Buildings ON Buildings.Id = LiveAddress.building_id
   LEFT JOIN [dbo].Districts Districts ON Districts.Id = Buildings.district_id
   LEFT JOIN [dbo].Streets Streets ON Streets.Id = Buildings.street_id
   LEFT JOIN [dbo].StreetTypes StreetTypes ON StreetTypes.Id = Streets.street_type_id
   LEFT JOIN [dbo].ApplicantPhones ApplicantPhones ON ApplicantPhones.applicant_id = Applicants.Id
   LEFT JOIN [dbo].Workers Workers ON Workers.worker_user_id = Appeals.user_id
   LEFT JOIN [dbo].Workers w ON w.worker_user_id = Appeals.user_edit_id
   LEFT JOIN [dbo].[ApplicantPrivilege] ApplicantPrivilege ON [Applicants].applicant_privilage_id = [ApplicantPrivilege].Id
   LEFT JOIN [dbo].[SocialStates] SocialStates ON [Applicants].social_state_id = [SocialStates].Id
   LEFT JOIN [dbo].[CategoryType] CategoryType ON [Applicants].category_type_id = [CategoryType].Id
WHERE
   [Appeals].[Id] = @Id ; ' ;

DECLARE @Query NVARCHAR(MAX) = (SELECT @Part1 + @Part2);
EXEC sp_executesql @Query, N'@Id INT', @Id = @Id;