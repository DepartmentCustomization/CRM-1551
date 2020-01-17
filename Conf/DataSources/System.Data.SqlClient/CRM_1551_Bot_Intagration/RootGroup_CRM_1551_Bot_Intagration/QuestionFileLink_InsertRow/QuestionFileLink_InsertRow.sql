 declare @output table ([Id] int)
  declare @QuestionDocFileId int
  insert into [CRM_1551_Analitics].[dbo].[QuestionDocFiles] ([question_id]
															,[link]
															,[create_date]
															,[user_id]
															,[edit_date]
															,[edit_user_id])
output inserted.Id into @output([Id])
values ( @question_id
		,@link
		,getutcdate()
		,@user_id
		,getutcdate()
		,@user_id)

set @QuestionDocFileId = (select top 1 [Id] from @output);

select @QuestionDocFileId