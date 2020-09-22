-- declare @Id int =27;
declare @object_id int;

declare @object_name nvarchar(200);

IF EXISTS (
   SELECT
      DISTINCT [EventObjects].[Id],
      [event_id],
      [EventObjects].[object_id]
   FROM
      [CRM_1551_Analitics].[dbo].[EventObjects]
      LEFT JOIN [CRM_1551_Analitics].[dbo].[ObjectsInObject] ON [EventObjects].object_id = [ObjectsInObject].main_object_id
   WHERE
      event_id = @Id
      AND [ObjectsInObject].main_object_id IS NOT NULL
      AND [EventObjects].[in_form] = 'true'
) BEGIN
SET
   @object_id = (
      SELECT
         DISTINCT [EventObjects].[object_id]
      FROM
         [CRM_1551_Analitics].[dbo].[EventObjects]
         LEFT JOIN [CRM_1551_Analitics].[dbo].[ObjectsInObject] ON [EventObjects].object_id = [ObjectsInObject].main_object_id
      WHERE
         event_id = @Id
         AND [ObjectsInObject].main_object_id IS NOT NULL
         AND [EventObjects].[in_form] = 'true'
   )
END
ELSE BEGIN
SET
   @object_id = (
      SELECT
         [object_id]
      FROM
         [CRM_1551_Analitics].[dbo].[EventObjects]
      WHERE
         event_id = @Id
         AND [EventObjects].[in_form] = 'true'
   )
END
SET
   @object_name =(
      SELECT
         [name]
      FROM
         [Objects]
      WHERE
         Id = @object_id
   ) --	select @object_id, @object_name
SELECT
   DISTINCT [Events].[Id],
   [Events].[registration_date],
   EventTypes.Id AS [event_type_id],
   EventTypes.name AS event_type_name --,[Events].[name] as event_name
,
   [Events].[event_class_id] AS event_class_id,
   [Event_class].[name] AS event_class_name,
   Objects.name AS object_name,
   Objects.Id AS object_id,
   Organizations.short_name AS executor_name,
   Organizations.Id AS executor_id,
   [Events].[comment],
   [Events].[start_date],
   [Events].[plan_end_date],
   [Events].[executor_comment] coment_executor,
   [Events].[real_end_date],
   [Events].[audio_start_date],
   [Events].[audio_end_date],
   [Events].[say_liveAddress_id],
   [Events].[say_organization_id],
   [Events].[say_phone_for_information],
   [Events].[phone_for_information],
   [Events].[say_plan_end_date],
   [Events].[audio_on],
   [Events].[active],
   [Events].[Standart_audio],
   [Events].[user_id],
   [Events].[Id] AS event_id,
   [Events].[File],
   [ObjectTypes].Id ObjectTypesId,
   [ObjectTypes].[name] ObjectTypesName,
   IIF([AttentionQuestionAndEvent].Id IS NOT NULL, 1, 0) AS attention_val
FROM
   [dbo].[Events] [Events]
   LEFT JOIN dbo.[EventTypes] EventTypes ON EventTypes.Id = [Events].event_type_id --  	left join QuestionTypes on QuestionTypes.Id = [Events].question_type_id
   LEFT JOIN dbo.[Event_Class] Event_Class ON [Events].[event_class_id] = Event_Class.id --left join EventObjects on EventObjects.event_id = [Events].Id
   LEFT JOIN dbo.[EventObjects] EventObjects ON EventObjects.event_id = [Events].Id
   LEFT JOIN dbo.[Objects] Objects ON [Objects].Id = @object_id --EventObjects.[object_id]
   LEFT JOIN dbo.[Buildings] Buildings ON Buildings.Id = [Objects].builbing_id
   LEFT JOIN dbo.[Streets] Streets ON Streets.Id = Buildings.street_id
   LEFT JOIN dbo.[ObjectTypes] ObjectTypes ON ObjectTypes.Id = [Objects].object_type_id
   LEFT JOIN dbo.[EventOrganizers] EventOrganizers ON EventOrganizers.event_id = [Events].Id
   AND main = 1
   LEFT JOIN dbo.[Executors] Executors ON Executors.Id = EventOrganizers.organization_id
   LEFT JOIN dbo.[Organizations] Organizations ON Organizations.Id = EventOrganizers.organization_id
   LEFT JOIN dbo.[StreetTypes] StreetTypes ON Streets.street_type_id = StreetTypes.Id
   LEFT JOIN dbo.[AttentionQuestionAndEvent] [AttentionQuestionAndEvent] ON [AttentionQuestionAndEvent].event_id = [Events].Id
   AND AttentionQuestionAndEvent.user_id = @user_id 
WHERE
   [Events].Id = @Id
   AND [EventObjects].[in_form] = N'true';