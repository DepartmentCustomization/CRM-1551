insert into EventQuestionsTypes 
    (
    event_id,
    question_type_id, 
    is_hard_connection
    )
values
    (
    @event_id, 
    @question_type_id,
    @is_hard_connection
    )