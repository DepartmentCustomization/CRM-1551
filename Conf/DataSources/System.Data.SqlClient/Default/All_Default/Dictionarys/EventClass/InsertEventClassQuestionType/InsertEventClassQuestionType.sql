insert into EventClass_QuestionType
(event_class_id, question_type_id, is_hard_connection)
values((select id from Event_Class where name = @name),
@questionTypeId, @is_hard_connection) 