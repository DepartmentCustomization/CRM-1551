--DECLARE @appeal_id INT = NULL;
--DECLARE @question_id INT = 6696046;

SELECT
  [AssignmentConsDocFiles].[Id] AS [AssignmentConsDocId],
  [AssignmentConsDocFiles].[name] AS [AssignmentConsDocName],
  [AssignmentConsDocFiles].[File] AS [AssignmentConsDocFile],
  [Questions].Id AS Question_id
FROM
  [dbo].[AssignmentConsDocFiles] [AssignmentConsDocFiles]
  LEFT JOIN [dbo].[AssignmentConsDocuments] [AssignmentConsDocuments] ON [AssignmentConsDocFiles].assignment_cons_doc_id = [AssignmentConsDocuments].Id
  LEFT JOIN [dbo].[AssignmentConsiderations] [AssignmentConsiderations] ON [AssignmentConsDocuments].assignment_сons_id = [AssignmentConsiderations].Id
  LEFT JOIN [dbo].[Assignments] [Assignments] ON [AssignmentConsiderations].assignment_id = [Assignments].Id
  LEFT JOIN [dbo].[Questions] [Questions] ON [Assignments].question_id = [Questions].Id
WHERE
  [Questions].appeal_id = @appeal_id 
  
  UNION 
  
SELECT
  [AssignmentConsDocFiles].[Id] AS [AssignmentConsDocId],
  [AssignmentConsDocFiles].[name] AS [AssignmentConsDocName],
  [AssignmentConsDocFiles].[File] AS [AssignmentConsDocFile],
  [Questions].Id AS Question_id
FROM
  [dbo].[AssignmentConsDocFiles] [AssignmentConsDocFiles]
  LEFT JOIN [dbo].[AssignmentConsDocuments] [AssignmentConsDocuments] ON [AssignmentConsDocFiles].assignment_cons_doc_id = [AssignmentConsDocuments].Id
  LEFT JOIN [dbo].[AssignmentConsiderations] [AssignmentConsiderations] ON [AssignmentConsDocuments].assignment_сons_id = [AssignmentConsiderations].Id
  LEFT JOIN [dbo].[Assignments] [Assignments] ON [AssignmentConsiderations].assignment_id = [Assignments].Id
  LEFT JOIN [dbo].[Questions] [Questions] ON [Assignments].question_id = [Questions].Id
WHERE
  [Questions].Id = @question_id;