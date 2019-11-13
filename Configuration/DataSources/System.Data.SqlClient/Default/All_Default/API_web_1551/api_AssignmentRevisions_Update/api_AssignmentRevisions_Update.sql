--declare @appeal_id int = 5392227


 if (select count(1) from [CRM_1551_Analitics].[dbo].[AssignmentRevisions]
   where [assignment_consideration_іd] in (select [AssignmentConsiderations].Id
 										 from [CRM_1551_Analitics].[dbo].[Questions]
 										 inner join [CRM_1551_Analitics].[dbo].[Assignments] on [Questions].last_assignment_for_execution_id=[Assignments].Id
 										 inner join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [AssignmentConsiderations].assignment_id=[Assignments].Id
 										 where [Questions].appeal_id=@appeal_id
 										 and [Assignments].assignment_state_id = 3)
 	) > 0
 begin
 	update [CRM_1551_Analitics].[dbo].[AssignmentRevisions]
 	  set [edit_date]=GETUTCDATE()
 	  ,[grade]=@grade
 	  ,[grade_comment]=@grade_comment
 	  ,[control_result_id]=@result
	  ,[control_date] = GETUTCDATE()
 	  ,[assignment_resolution_id]=case when @result=4 then 9 when @result=5 then 8 when @result=11 then 10 end
 	  where [assignment_consideration_іd] in (select [AssignmentConsiderations].Id
 											 from [CRM_1551_Analitics].[dbo].[Questions]
 											 inner join [CRM_1551_Analitics].[dbo].[Assignments] on [Questions].last_assignment_for_execution_id=[Assignments].Id
 											 inner join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [AssignmentConsiderations].assignment_id=[Assignments].Id
 											 where [Questions].appeal_id=@appeal_id
 											 and [Assignments].assignment_state_id = 3)
	
 	select N'Ok' as [Result]

 end
 else
 begin
	select N'Error' as [Result]
 end

--offset @pageOffsetRows rows fetch next @pageLimitRows rows only