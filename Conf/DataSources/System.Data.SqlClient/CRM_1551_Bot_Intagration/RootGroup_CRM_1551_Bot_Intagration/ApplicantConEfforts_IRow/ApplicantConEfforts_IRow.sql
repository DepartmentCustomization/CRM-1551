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
      

--если такого  нету- добавить

  if not exists (select [count_communication_attempt] from [CommunicationChannelsForPhone] 
  where [phone_number]=@phone_number and [chanel_id]=@chanel_id)

  begin
	  insert into [CommunicationChannelsForPhone]
	  (
	  [phone_number]
		  ,[chanel_id]
		  ,[chat_id]
		  ,[chat_is]
		  ,[count_communication_attempt]
		  ,[count_successful_delivery]
		  ,[count_view_message]
		  ,[create_date]
		  ,[edit_date]
	  )

	  select @phone_number [phone_number]
		  ,@chanel_id [chanel_id]
		  ,@chat_id [chat_id]
		  ,case when @chat_id is not null then 'true' else 'false' end [chat_is]
		  ,case when (select [communication_attempt_is] from [Answers] where Id=@answer_id)='true' then 1 else 0 end [count_communication_attempt] --количество попыток связи
		  ,case when (select [successful_delivery_is] from [Answers] where Id=@answer_id)='true' then 1 else 0 end [count_successful_delivery] --Кол-во успешных доставок
		  ,case when (select [view_message_is] from [Answers] where Id=@answer_id)='true' then 1 else 0 end [count_view_message] --Кол-во просмотров сообщения
		  ,GETUTCDATE() [create_date]
		  ,GETUTCDATE() [edit_date]
end

--если есть- обновить
/*
  if exists (select [count_communication_attempt] from [CommunicationChannelsForPhone] 
  where [phone_number]=@phone_number and [chanel_id]=@chanel_id)
  */
      else

  begin
	update [CommunicationChannelsForPhone]
	set [count_communication_attempt]= case when (select [communication_attempt_is] from [Answers] where Id=@answer_id)='true' then isnull([count_communication_attempt],0)+1 else [count_communication_attempt] end  --количество попыток связи
		  ,[count_successful_delivery]= case when (select [successful_delivery_is] from [Answers] where Id=@answer_id)='true' then isnull([count_successful_delivery],0)+1 else [count_successful_delivery] end  --Кол-во успешных доставок
		  ,[count_view_message]= case when (select [view_message_is] from [Answers] where Id=@answer_id)='true' then isnull([count_view_message],0)+1 else [count_view_message] end  --Кол-во просмотров сообщения
		  ,[edit_date]=GETUTCDATE()
	where [phone_number]=@phone_number and [chanel_id]=@chanel_id

  end


set @ApplicantConnectionEffortId = (select top 1 [Id] from @output);
select @ApplicantConnectionEffortId as [Id]