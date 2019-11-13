update EventClass_QuestionType 
set event_class_id = (select id from Event_Class where name = @name),
    question_type_id = @question_type_id,
    is_hard_connection = @is_hard_connection
where id = @Id;