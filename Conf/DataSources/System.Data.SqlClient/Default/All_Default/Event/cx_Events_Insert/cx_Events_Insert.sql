declare @output table (Id int)
declare @event_id int

INSERT INTO [dbo].[Events]
           ([registration_date]
        --   ,[name]
           ,[event_class_id]
           ,[event_type_id]
           ,[gorodok_id]
           ,[start_date]
           ,[plan_end_date]
           ,[real_end_date]
        --   ,[active]
           ,[comment]
           ,[area]
           ,[user_id]
           ,[audio_start_date]
           ,[audio_end_date]
           ,[Standart_audio]
           ,[say_liveAddress_id]
           ,[say_organization_id]
           ,[say_phone_for_information]
           ,[phone_for_information]
           ,[say_plan_end_date]
           ,[audio_on]
           ,[executor_comment]
		   )
	output inserted.Id into @output(Id)
     VALUES
           (GETUTCDATE()
        --   ,@event_class_id2
           ,@event_class_id
           ,@event_type_id
           ,@gorodok_id
           ,@start_date
           ,@plan_end_date
           ,@real_end_date
        --   ,@active
           ,@comment
           ,@area
           ,@user_id
           ,@audio_start_date
           ,@audio_end_date
           ,@Standart_audio
           ,@say_liveAddress_id
           ,@say_organization_id
           ,@say_phone_for_information
           ,@phone_for_information
           ,@say_plan_end_date
           ,@audio_on
           ,@coment_executor
		   )

set @event_id = (select top 1 Id from @output)

  insert into EventQuestionsTypes
	(
	event_id, 
	question_type_id, 
	is_hard_connection
	)
  select 
   @event_id,
   qt.id questionType,
   ec_qt.is_hard_connection
  from [Events] e
	join EventClass_QuestionType ec_qt on e.event_class_id = ec_qt.event_class_id
	join QuestionTypes qt on qt.Id = ec_qt.question_type_id  
  where e.Id = @event_id

	insert into EventObjects (event_id, object_id, [in_form])
	values ( @event_id, @object_id, 'true')
	
	INSERT INTO [dbo].[EventOrganizers]
          ([event_id]
          ,[organization_id]
        --   ,[executor_id]
          ,[main])
     VALUES
          (@event_id
        --   ,(select organization_id from Executors where Executors.Id = @executor_id)
        --   ,@organization_id
          ,@executor_id
          ,1)
	 insert into [dbo].[EventObjects]
	  (
		[event_id]
		,[object_id]
	  )

  select 
	@event_id, 
	[object_id]
  from [dbo].[ObjectsInObject]
  where main_object_id=@object_id

select @event_id as Id 
return;