-- DECLARE @phone NVARCHAR(400) = '0634587456, 0442545698, 0672674525';

SET @phone = REPLACE(@phone, ', ', ',');

DECLARE @phonesTab TABLE (Num NVARCHAR(10));
INSERT INTO @phonesTab(Num)
SELECT 
	[value] 
FROM string_split(@phone, ',');

SELECT
DISTINCT
    [Applicants].Id,
    [Applicants].full_name,
    concat(
        'р-н. ' + [Districts].name,
        ', ' + StreetTypes.shortname + ' ' + [Streets].name,
        ', буд.' + [Buildings].name,
        ', під.' + rtrim([LiveAddress].entrance),
        ', кв.' + [LiveAddress].flat
    ) AS Building,
    [ApplicantPrivilege].Name Privilege,
    [SocialStates].name [SocialStates]
FROM
    [CRM_1551_Analitics].[dbo].[Applicants]
    LEFT JOIN [dbo].[ApplicantPhones] ON [Applicants].Id = [ApplicantPhones].applicant_id
    LEFT JOIN [dbo].[PhoneTypes] ON [ApplicantPhones].phone_type_id = [PhoneTypes].Id
    LEFT JOIN [dbo].[LiveAddress] ON [Applicants].Id = [LiveAddress].[applicant_id]
	AND LiveAddress.main = 1
    LEFT JOIN [dbo].[Buildings] ON [LiveAddress].building_id = [Buildings].Id
    LEFT JOIN [dbo].[Districts] ON [Buildings].district_id = Districts.Id
    LEFT JOIN [dbo].[Streets] ON [Buildings].street_id = [Streets].Id
    LEFT JOIN StreetTypes ON StreetTypes.Id = Streets.street_type_id
    LEFT JOIN [dbo].[ApplicantTypes] ON [Applicants].applicant_type_id = [ApplicantTypes].Id
    LEFT JOIN [dbo].[CategoryType] ON [Applicants].category_type_id = [CategoryType].Id
    LEFT JOIN [dbo].[ApplicantPrivilege] ON [Applicants].applicant_privilage_id = [ApplicantPrivilege].Id
    LEFT JOIN [dbo].[SocialStates] ON [Applicants].social_state_id = [SocialStates].Id
WHERE
    ApplicantPhones.phone_number IN (SELECT 
										 [Num]
									 FROM @phonesTab);