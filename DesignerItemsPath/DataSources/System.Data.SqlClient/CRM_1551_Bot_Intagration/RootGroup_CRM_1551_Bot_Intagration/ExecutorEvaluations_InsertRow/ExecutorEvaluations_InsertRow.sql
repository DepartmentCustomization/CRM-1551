
declare @output table ([Id] int)
declare @ExecutorEvaluationId int

insert into [dbo].[ExecutorEvaluations] ([applicant_connection_effort_id], [bot_poll_number], [bot_poll_item_id], [grade], [answer_date]
)
output inserted.Id into @output([Id])
values (@applicant_connection_effort_id
		,@bot_poll_number
		,@bot_poll_item_id
		,@grade
		,@answer_date)

set @ExecutorEvaluationId = (select top 1 [Id] from @output);


update  [dbo].[ExecutorEvaluations]  set [question_id] = t2.[question_id],
									     [executor_id] = t2.[executor_organization_id],
										 [operator_id] = t2.[user_id]
from  [dbo].[ExecutorEvaluations] 
left join (
			SELECT TOP (1) [TasksForBot].[question_id],
						   [Assignments].[executor_organization_id],
						   [Appeals].[user_id],
						   [ExecutorEvaluations].[Id]
			FROM [dbo].[ExecutorEvaluations]
			left join [ApplicantConnectionEfforts] on [ApplicantConnectionEfforts].[Id] = [ExecutorEvaluations].[applicant_connection_effort_id]
			left join [TasksForBot] on [TasksForBot].[Id] = [ApplicantConnectionEfforts].[task_for_bot_id] 
			left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = [TasksForBot].[question_id]
			left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = [Questions].[appeal_id]
			left join [CRM_1551_Analitics].[dbo].[Assignments] on [Assignments].[Id] = [Questions].[last_assignment_for_execution_id]
			where [ExecutorEvaluations].[Id] = @ExecutorEvaluationId
			) as t2 on 1 = 1
where [ExecutorEvaluations].[Id] = @ExecutorEvaluationId

select @ExecutorEvaluationId as [Id]