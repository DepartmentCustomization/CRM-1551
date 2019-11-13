-- declare @question_type int;
--   declare @object int;
--   declare @registration_date datetime2;


  select [Events].Id, [Events].start_date, [EventTypes].name EventType,  [Events].plan_end_date
  from [dbo].[Events]
  left join EventQuestionsTypes as eqt on eqt.event_id = [Events].Id 
  inner join [dbo].[EventObjects] on [Events].Id=[EventObjects].event_id
  left join [dbo].[EventTypes] on [Events].event_type_id=[EventTypes].Id
  where eqt.question_type_id = @question_type_id and [EventObjects].[object_id]= @object_id
  and @registration_date>[Events].registration_date
 and #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only


-- SELECT 
-- 	   [Events].[Id]
--       ,[Events].[start_date]
--       ,EventTypes.name as e_type_name
--       ,[Events].[name] as event_name
--       ,[Events].[plan_end_date]
--     --   ,[Events].[active]
--  FROM [dbo].[Events]
-- 	left join EventTypes on EventTypes.Id = Events.event_type_id
-- 	left join EventObjects on EventObjects.event_id = Events.Id
-- where Events.active = 1
-- and EventObjects.object_id = @obj_id  
-- or Events.event_type_id = @type_id
-- 	and #filter_columns#
--     #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only