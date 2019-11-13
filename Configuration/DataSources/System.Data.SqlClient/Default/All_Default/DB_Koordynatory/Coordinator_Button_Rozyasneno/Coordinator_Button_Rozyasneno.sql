--declare @ids nvarchar(200)=N'1,2,3';
  declare @t nvarchar(max)=N'

  update [dbo].[Assignments]
  set
    assignment_state_id = 5
    ,close_date = GETUTCDATE()
    ,AssignmentResultsId = 7
    ,AssignmentResolutionsId = 6
    ,edit_date = GETUTCDATE()
    ,LogUpdated_Query = N''Coordinator_Button_Rozyasneno_Row9''' +N'
    ,user_edit_id = N'''+ @user + N'''
  where Id in ( '+ @ids+N')'+ N'
  
  update [CRM_1551_Analitics].[dbo].[AssignmentConsiderations]
  set 
   [assignment_result_id] = 7 
  ,[assignment_resolution_id] = 6 
  ,edit_date = GETUTCDATE()
  ,user_edit_id = N'''+ @user + N'''
  where Id in ( select current_assignment_consideration_id from Assignments where Id in ('+@Ids+N') )

  
  UPDATE dbo.AssignmentRevisions
      SET
      assignment_resolution_id = 6
      ,control_result_id = 7
      ,control_type_id = 2
      ,control_date = GETUTCDATE()
      ,edit_date = GETUTCDATE()
      ,user_edit_id = N'''+ @user + N'''
    WHERE assignment_consideration_іd IN (SELECT current_assignment_consideration_id  FROM dbo.Assignments  WHERE Id IN ('+@Ids+N') )


  '

  exec (@t)