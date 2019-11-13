select eqt.Id, qt.name as eventQuestionName, eqt.is_hard_connection  
from [Events] e 
join Event_Class ec on e.event_class_id = ec.id
join EventQuestionsTypes eqt on eqt.event_id = e.Id
join QuestionTypes qt on eqt.question_type_id = qt.Id

where e.Id = @Id and
#filter_columns#
      order by 1
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only