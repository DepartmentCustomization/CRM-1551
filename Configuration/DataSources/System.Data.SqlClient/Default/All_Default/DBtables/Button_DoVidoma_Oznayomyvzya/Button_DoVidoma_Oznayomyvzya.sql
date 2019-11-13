
declare @exec nvarchar(max);
--   declare @user_id nvarchar(300)=N'Вася';
--   declare @Ids nvarchar(max) = N'1,2,3';

  set @exec= N'
  update [CRM_1551_Analitics].[dbo].[Assignments]
  set [user_edit_id]=N'''+@user_id+N''',
  edit_date= GETUTCDATE(),
  [assignment_state_id]=5,
  [AssignmentResultsId]=2,
  [AssignmentResolutionsId]=11,
  [LogUpdated_Query] = N''Button_DoVidoma_Oznayomyvzya_Row13''' +N'
  where id in ('+@Ids+N')'+N'


    update [AssignmentConsiderations]
  set [assignment_result_id]=2
      ,[assignment_resolution_id]=11
	  ,[edit_date]=GETUTCDATE()
	  ,[user_edit_id]='''+ @user_id+N'''
--   where [assignment_id] in ('+ @Ids+N')
   where Id in ( select current_assignment_consideration_id from Assignments where Id in ('+@Ids+N') )
  '



  --select @exec
  exec (@exec)

  
 










-- declare @exec nvarchar(max);
--   --declare @user_id nvarchar(300)=N'Вася';
--   --declare @Ids nvarchar(max) = N'1,2,3';

--   set @exec= N'
--   update [CRM_1551_Analitics].[dbo].[Assignments]
--   set [user_edit_id]=N'''+@user_id+N''',
--   edit_date= GETDATE(),
--   assignment_type_id=1
--   where id in ('+@Ids+N')'

--   exec (@exec)



    