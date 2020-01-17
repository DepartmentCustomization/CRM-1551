
/*
"по якому робили прозвон"- що мається на увазі?
2.2 2.3 пункт результат,резолюція така, як і в 2.1?
2.4 створюється нове доручення чи оновлюється?
2.2 first_executor_organization_id скопіював з доручення таблиці Assignments значення executor_organization_id

2975230
2975229 main

5398713 appel

declare @appeal_id int = 5398477;
declare @result int=5;
declare @user_id nvarchar(128)=N'тестт';
declare @grade int =5;
declare @grade_comment nvarchar(128)=N'тестт';
*/
--declare @Id int =@appeal_id;

-- таблица с нужными ображениями
declare @assignments_table table (Id int);

  insert into @assignments_table (Id)

  select [Assignments].Id
  from [Appeals]
  inner join [Questions] on [Appeals].Id=[Questions].appeal_id
  inner join [Assignments] on [Questions].Id=[Assignments].question_id
  where [Appeals].Id=@appeal_id

 -- select * from @assignments_table
-- таблица с нужными вопросами
declare @questions_table table (Id int);

  insert into @questions_table (Id)

  select [Questions].Id
  from [Appeals]
  inner join [Questions] on [Appeals].Id=[Questions].appeal_id
  where [Appeals].Id=@appeal_id





declare @output table ([Id] int)



if @result in (4,11)
	begin
	/**/
update [Assignments]
set [AssignmentResolutionsId]=9
,[AssignmentResultsId]=4
,[assignment_state_id]=5
,[state_change_date]=GETUTCDATE()
,[close_date]=GETUTCDATE()
,[edit_date]=GETUTCDATE()
,[user_edit_id]=@user_id
where question_id in (select Id from @questions_table)
--question_id=@question_id


update [AssignmentRevisions]
set assignment_resolution_id  = 9
,[control_result_id] = 4
,[control_date]=GETUTCDATE()
,[edit_date]=GETUTCDATE()
,[user_edit_id]=@user_id
,[grade]=@grade
,[grade_comment]=@grade_comment
where assignment_consideration_іd in 
(select [AssignmentConsiderations].Id
  from [Assignments]
  inner join [AssignmentConsiderations] on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
  inner join @questions_table qt on [Assignments].question_id=qt.Id
  --where [Assignments].question_id=@question_id
  )




  insert into [AssignmentRevisions]
  (
  [assignment_consideration_іd]
      ,[control_type_id]
      ,[assignment_resolution_id]
      ,[control_result_id]
      ,[organization_id]
      ,[control_comment]
      ,[control_date]
      ,[user_id]
      ,[grade]
      ,[grade_comment]
      ,[rework_counter]
      ,[missed_call_counter]
      ,[edit_date]
      ,[user_edit_id]
  )
  

  select [AssignmentConsiderations].Id --[assignment_consideration_іd]
      ,2--[control_type_id]
      ,9--[assignment_resolution_id]
      ,4--[control_result_id]
      ,null--[organization_id]
      ,@grade_comment--[control_comment]
      ,getutcdate() --[control_date]
      ,@user_id --[user_id]
      ,@grade--[grade] 
      ,null--[grade_comment]
      ,null--[rework_counter]
      ,null--[missed_call_counter]
      ,getutcdate() --[edit_date]
      ,@user_id--[user_edit_id]
  from [AssignmentConsiderations]
  inner join [Assignments] on [AssignmentConsiderations].Id=[Assignments].current_assignment_consideration_id
  left join [AssignmentRevisions] on [AssignmentRevisions].assignment_consideration_іd=[AssignmentConsiderations].Id
  inner join @questions_table qt on [Assignments].question_id=qt.Id
  where 
  --[Assignments].question_id=@question_id 
  [AssignmentRevisions].Id is null

	end

if @result in (5) -- на доопрацюванні

	begin

update [AssignmentRevisions]
set assignment_resolution_id  = 8
,[control_result_id] = 5
,[control_date]=GETUTCDATE()
,[rework_counter]=case when [rework_counter] is null then 1 else [rework_counter]+1 end
,[edit_date]=GETUTCDATE()
,[user_edit_id]=@user_id
,[grade]=@grade
,[grade_comment]=@grade_comment
where assignment_consideration_іd in 
(select [AssignmentConsiderations].Id
  from [Assignments]
  inner join [AssignmentConsiderations] on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
  inner join @assignments_table ast on [Assignments].Id=ast.Id
  --where [Assignments].Id=@Id
  )

  -- тут стоп, возможно цикл

insert into [AssignmentConsiderations]
  (
  [assignment_id] 
  ,[consideration_date] 
  ,[assignment_result_id] 
  ,[first_executor_organization_id] 
  ,[user_id] 
  ,[edit_date] 
  ,[user_edit_id])

  output inserted.Id into @output([Id])

  select [Assignments].Id--[assignment_id] 
  ,getdate()--[consideration_date] 
  ,5--[assignment_result_id] 
  ,[executor_organization_id]--[first_executor_organization_id] узнать
  ,@user_id--[user_id] 
  ,getutcdate() --[edit_date] 
  ,@user_id--[user_edit_id]

  from [Assignments]
  inner join @assignments_table ast on [Assignments].Id=ast.Id

  


update [Assignments]
set [AssignmentResolutionsId]=8
,[AssignmentResultsId]=5
,[assignment_state_id]=(select distinct new_assignment_state_id from [TransitionAssignmentStates] where new_assignment_resolution_id=8 and new_assignment_result_id=5)
,[state_change_date]=GETUTCDATE()
,[edit_date]=GETUTCDATE()
,[user_edit_id]=@user_id
,[current_assignment_consideration_id]=(select top 1 Id from @output)
from [Assignments]
--inner join @output o on [Assignments].Id=o.Id
inner join @assignments_table ast on [Assignments].Id=ast.Id
where [Assignments].main_executor='true'


	end


select N'Ok' as [Result]

--  if (select count(1) from [CRM_1551_Analitics].[dbo].[AssignmentRevisions]
--    where [assignment_consideration_іd] in (select [AssignmentConsiderations].Id
--  										 from [CRM_1551_Analitics].[dbo].[Questions]
--  										 inner join [CRM_1551_Analitics].[dbo].[Assignments] on [Questions].last_assignment_for_execution_id=[Assignments].Id
--  										 inner join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [AssignmentConsiderations].assignment_id=[Assignments].Id
--  										 where [Questions].appeal_id=@appeal_id
--  										 and [Assignments].assignment_state_id = 3)
--  	) > 0
--  begin
--  	update [CRM_1551_Analitics].[dbo].[AssignmentRevisions]
--  	  set [edit_date]=GETUTCDATE()
--  	  ,[grade]=@grade
--  	  ,[grade_comment]=@grade_comment
--  	  ,[control_result_id]=@result
-- 	  ,[control_date] = GETUTCDATE()
--  	  ,[assignment_resolution_id]=case when @result=4 then 9 when @result=5 then 8 when @result=11 then 10 end
--  	  where [assignment_consideration_іd] in (select [AssignmentConsiderations].Id
--  											 from [CRM_1551_Analitics].[dbo].[Questions]
--  											 inner join [CRM_1551_Analitics].[dbo].[Assignments] on [Questions].last_assignment_for_execution_id=[Assignments].Id
--  											 inner join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [AssignmentConsiderations].assignment_id=[Assignments].Id
--  											 where [Questions].appeal_id=@appeal_id
--  											 and [Assignments].assignment_state_id = 3)
	
--  	select N'Ok' as [Result]

--  end
--  else
--  begin
-- 	select N'Error' as [Result]
--  end

-- --offset @pageOffsetRows rows fetch next @pageLimitRows rows only