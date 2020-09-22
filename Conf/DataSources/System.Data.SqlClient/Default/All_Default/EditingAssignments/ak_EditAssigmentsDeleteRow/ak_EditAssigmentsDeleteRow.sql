-- DECLARE @Id INT = 2809572, @user_id NVARCHAR(128);

SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRANSACTION;

DECLARE @AppealId INT = (SELECT TOP 1 [Appeals].Id 
						 FROM dbo.[Assignments] [Assignments]
						 INNER JOIN dbo.[Questions] [Questions] ON [Assignments].question_id=[Questions].Id
						 INNER JOIN dbo.[Appeals] [Appeals] ON [Questions].appeal_id=[Appeals].Id
						 WHERE [Assignments].Id=@Id);

IF(@AppealId IS NOT NULL)
BEGIN
DELETE FROM [dbo].[AssignmentConsDocFiles] WHERE [assignment_cons_doc_id] IN (SELECT [Id] FROM [dbo].[AssignmentConsDocuments] WHERE [assignment_сons_id] IN (SELECT [Id] FROM [dbo].[AssignmentConsiderations] WHERE assignment_id IN (SELECT [Id] FROM [dbo].[Assignments] WHERE [question_id] IN (SELECT [Id] FROM [dbo].[Questions] WHERE [appeal_id] = @AppealId))));
DELETE FROM [dbo].[AssignmentConsDocuments] WHERE [assignment_сons_id] IN (SELECT [Id] FROM [dbo].[AssignmentConsiderations] WHERE assignment_id IN (SELECT [Id] FROM [dbo].[Assignments] WHERE [question_id] IN (SELECT [Id] FROM [dbo].[Questions] WHERE [appeal_id] = @AppealId)));
DELETE FROM [dbo].[Consultations] WHERE [appeal_id] = @AppealId;
DELETE FROM [dbo].[AssignmentRevisions] WHERE [assignment_consideration_іd] IN (SELECT [Id] FROM [dbo].[AssignmentConsiderations] WHERE assignment_id IN (SELECT [Id] FROM [dbo].[Assignments] WHERE [question_id] IN (SELECT [Id] FROM [dbo].[Questions] WHERE [appeal_id] = @AppealId)));
DELETE FROM [dbo].[AssignmentConsiderations] WHERE assignment_id IN (SELECT [Id] FROM [dbo].[Assignments] WHERE [question_id] IN (SELECT [Id] FROM [dbo].[Questions] WHERE [appeal_id] = @AppealId));
DELETE FROM [dbo].[Assignments] WHERE [question_id] IN (SELECT [Id] FROM [dbo].[Questions] WHERE [appeal_id] = @AppealId);
DELETE FROM [dbo].[Assignment_History] WHERE [assignment_id] IN (SELECT [Id] FROM [dbo].[Assignments] WHERE [question_id] IN (SELECT [Id] FROM [dbo].[Questions] WHERE [appeal_id] = @AppealId));
DELETE FROM [dbo].[AssignmentDetailHistory] WHERE [Assignment_id] IN (SELECT [Id] FROM [dbo].[Assignments] WHERE [question_id] IN (SELECT [Id] FROM [dbo].[Questions] WHERE [appeal_id] = @AppealId));
DELETE FROM [dbo].[QuestionDocFiles] WHERE [question_id] IN (SELECT [Id] FROM [dbo].[Questions] WHERE [appeal_id] = @AppealId);
DELETE FROM [dbo].[Questions] WHERE [appeal_id] = @AppealId;
DELETE FROM [dbo].[Question_History] WHERE [appeal_id] = @AppealId;
DELETE FROM [dbo].[Appeals] WHERE [Id] = @AppealId;


DELETE FROM [CRM_1551_Site_Integration].[dbo].[AppealFromSiteFiles] WHERE [AppealFromSiteId]  IN (SELECT [Id] FROM [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] WHERE [Appeal_Id] = @AppealId);
DELETE FROM [CRM_1551_Site_Integration].[dbo].[AppealsFromSite_History] WHERE [AppealsFromSiteId] IN (SELECT [Id] FROM [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] WHERE [Appeal_Id] = @AppealId);
DELETE FROM [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] WHERE [Appeal_Id] = @AppealId;

INSERT INTO dbo.[AppealsForDelete] ([appeal_id],
									[create_date],
									[user_id])

			VALUES (@AppealId,
					GETDATE(),
					@user_id);
END
COMMIT TRANSACTION;
END TRY
BEGIN CATCH 
IF (XACT_STATE()) = -1  
    BEGIN  
        DECLARE @Error NVARCHAR(MAX) = (SELECT ERROR_MESSAGE());
        ROLLBACK TRANSACTION;  
		RAISERROR (@Error, 16, 1);
    END;  
END CATCH;