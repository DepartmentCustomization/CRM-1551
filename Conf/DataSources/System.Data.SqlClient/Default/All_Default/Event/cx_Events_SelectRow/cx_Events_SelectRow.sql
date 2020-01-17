-- declare @Id int =27;

 declare @object_id int;
 declare @object_name nvarchar(200);

 if exists
 
 (
 SELECT distinct [EventObjects].[Id]
       ,[event_id]
       ,[EventObjects].[object_id]
   FROM [CRM_1551_Analitics].[dbo].[EventObjects]
   left join [CRM_1551_Analitics].[dbo].[ObjectsInObject] on [EventObjects].object_id=[ObjectsInObject].main_object_id
   where event_id=@Id and [ObjectsInObject].main_object_id is not null and [EventObjects].[in_form]='true')

   begin

   set @object_id = (SELECT distinct [EventObjects].[object_id]
   FROM [CRM_1551_Analitics].[dbo].[EventObjects]
   left join [CRM_1551_Analitics].[dbo].[ObjectsInObject] on [EventObjects].object_id=[ObjectsInObject].main_object_id
   where event_id=@Id and [ObjectsInObject].main_object_id is not null and [EventObjects].[in_form]='true')
    end

	else

	begin
		set @object_id = (select [object_id]
		from [CRM_1551_Analitics].[dbo].[EventObjects]
		where event_id=@Id and [EventObjects].[in_form]='true')
	end

	set @object_name=(select [name] from [Objects] where Id=@object_id)

--	select @object_id, @object_name







 SELECT distinct [Events].[Id]
       ,[Events].[registration_date]
       ,EventTypes.Id as [event_type_id]
 	  ,EventTypes.name as event_type_name
 	  --,[Events].[name] as event_name
 	  ,[Events].[event_class_id] as event_class_id
 	  ,[Event_class].[name] as event_class_name
 	  ,Objects.name as object_name
 	  ,Objects.Id as object_id
 	  ,Organizations.short_name as executor_name
 	  ,Organizations.Id as executor_id
       ,[Events].[comment]
       ,[Events].[start_date]
       ,[Events].[plan_end_date]
       ,[Events].[executor_comment] coment_executor
       ,[Events].[real_end_date]

       ,[Events].[audio_start_date]
       ,[Events].[audio_end_date]
       ,[Events].[say_liveAddress_id]
       ,[Events].[say_organization_id]
       ,[Events].[say_phone_for_information]
       ,[Events].[phone_for_information]
       ,[Events].[say_plan_end_date]
       ,[Events].[audio_on]
    
       ,[Events].[active]
       ,[Events].[Standart_audio]
       ,[Events].[user_id]
       ,[Events].[Id] as event_id
       ,[Events].[File]
 	  ,[ObjectTypes].Id ObjectTypesId
 	  ,[ObjectTypes].name ObjectTypesName
   FROM [dbo].[Events]
 	left join EventTypes on EventTypes.Id = [Events].event_type_id
--  	left join QuestionTypes on QuestionTypes.Id = [Events].question_type_id
    left join Event_Class on [Events].[event_class_id] = Event_Class.id
 	--left join EventObjects on EventObjects.event_id = [Events].Id
 	left join EventObjects on EventObjects.event_id = [Events].Id
 	left join [Objects] on [Objects].Id = @object_id--EventObjects.[object_id]
 	left join Buildings on Buildings.Id = [Objects].builbing_id
 	left join Streets on Streets.Id = Buildings.street_id
 	left join ObjectTypes on ObjectTypes.Id = [Objects].object_type_id
 	left join EventOrganizers on EventOrganizers.event_id = [Events].Id and main = 1
 	left join Executors on Executors.Id = EventOrganizers.organization_id
 	left join Organizations on Organizations.Id = EventOrganizers.organization_id
 	left join [StreetTypes] on Streets.street_type_id=StreetTypes.Id
 	where [Events].Id= @Id and [EventObjects].[in_form]='true'


