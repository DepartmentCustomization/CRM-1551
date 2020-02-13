/*
  DECLARE @Date DATETIME='2019-12-19';
  DECLARE @Organization_Id INT =1801;*/

  /*ЗАГАЛЬНА КІЛЬКІСТЬ ПОТОЧНИЙ МІСЯЦЬ*/
  SELECT rmzk.Id, app.registration_number Appeal_number, q.registration_number Question_number, qt.[name] QuestionType,
  o.short_name AssignmentExecutorOrganization, rmzk.AssignmentRegistrationDate, [as].name AssignmentState,
  ar.name AssignmentResult, rmzk.AssigmentExecutionDate, r.name Rating, dep.short_name Department
  ,arl.name AssignmentResolution
  FROM [dbo].[Реєстр - Поточний місяць - Загальна кількість] rmzk
  LEFT JOIN [CRM_1551_Analitics].[dbo].[Appeals] app ON rmzk.AppealId=app.Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[Questions] q ON rmzk.QuestionId=q.Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[QuestionTypes] qt ON q.question_type_id=qt.Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[Organizations] o ON rmzk.AssignmentExecutorOrganizationId=o.Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[AssignmentStates] [as] ON rmzk.AssignmentStateId=[as].Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].AssignmentResults ar ON rmzk.AssignmentResultsId=ar.Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[AssignmentResolutions] arl ON rmzk.[AssignmentResolutionsId]=arl.Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].Rating r ON rmzk.RatingId=r.Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[Organizations] dep ON rmzk.DepartmentId=dep.Id
  WHERE rmzk.StateToDate=CONVERT(DATE, @Date) AND rmzk.DepartmentId=@Organization_Id;