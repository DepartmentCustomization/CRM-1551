------------
declare @output table ([Id] int)
declare @ApplicantConnectionEffortId int

insert into [dbo].[ApplicantConnectionEfforts] ([task_for_bot_id]
      ,[phone_number]
      ,[chat_id]
      ,[chanel_id]
      ,[sent_date]
      ,[answer_id]
      ,[answer_date]
      ,[is_finish_cycle])
output inserted.Id into @output([Id])
values (@task_for_bot_id
      ,@phone_number
      ,@chat_id
      ,@chanel_id
      ,@sent_date
      ,@answer_id
      ,@answer_date
      ,@is_finish_cycle)
      
set @ApplicantConnectionEffortId = (select top 1 [Id] from @output);
select @ApplicantConnectionEffortId as [Id]