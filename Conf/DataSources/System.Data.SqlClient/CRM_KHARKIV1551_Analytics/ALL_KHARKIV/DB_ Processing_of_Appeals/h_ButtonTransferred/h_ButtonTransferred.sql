-- declare @Id int=1234;
-- declare @comment nvarchar(500)=N'Вася';
-- declare @user_id nvarchar(128)=N'Федя';

-- статус- В роботі, результат - Прийнято в роботу

update [CRM_1551_Analitics].[dbo].[Assignments]
set [assignment_state_id]=2, /*В роботі*/
[AssignmentResultsId]=9,/*Прийнято в роботу*/
[edit_date]=getutcdate(),
[user_edit_id]=@user_id
where Id=@Id


update [CRM_1551_Analitics].[dbo].[AssignmentConsiderations]
set [short_answer]=@comment,
[assignment_result_id]=9,
[edit_date]=getutcdate(),
[user_edit_id]=@user_id
from [CRM_1551_Analitics].[dbo].[AssignmentConsiderations]
inner join [CRM_1551_Analitics].[dbo].[Assignments] on [AssignmentConsiderations].Id=[Assignments].current_assignment_consideration_id
where [Assignments].Id=@Id