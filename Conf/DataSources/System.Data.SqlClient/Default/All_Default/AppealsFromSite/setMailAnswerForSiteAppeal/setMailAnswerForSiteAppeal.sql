-- DECLARE @Id INT = 6695889;

DECLARE @AppealID INT = (SELECT appeal_id FROM CRM_1551_Analitics.dbo.Questions WHERE Id = @Id);

DECLARE @ApplicantID INT = (SELECT applicant_id FROM CRM_1551_Analitics.dbo.Appeals WHERE Id = @AppealID);

DECLARE @Mail NVARCHAR(100) = (SELECT mail FROM CRM_1551_Analitics.dbo.Applicants WHERE Id = @ApplicantID);

SELECT @Mail AS applicantMail;