declare @exec nvarchar(max);
  --declare @user_id nvarchar(300)=N'Вася';
  --declare @Ids nvarchar(max) = N'1,2,3';

  set @exec= N'
  update [CRM_1551_Analitics].[dbo].[Assignments]
  set [user_edit_id]=N'''+@user_id+N''',
  edit_date= GETUTCDATE(),
  assignment_state_id=2,
  [AssignmentResultsId]=9,
  [AssignmentResolutionsId]=null,
  [LogUpdated_Query] = N''Button_Nadiishlo_VzyatyVRobotu_Row12'''+N'
  where id in ('+@Ids+N')
  
  
  update [CRM_1551_Analitics].[dbo].[AssignmentConsiderations]
  set [assignment_result_id]=9,
  [assignment_resolution_id]=null,
  [user_edit_id]=N'''+@user_id+N''',
  edit_date= GETUTCDATE()
--   where [assignment_id] in ('+@Ids+N')
 where Id in ( select current_assignment_consideration_id from Assignments where Id in ('+@Ids+N') )

  '

  exec (@exec)