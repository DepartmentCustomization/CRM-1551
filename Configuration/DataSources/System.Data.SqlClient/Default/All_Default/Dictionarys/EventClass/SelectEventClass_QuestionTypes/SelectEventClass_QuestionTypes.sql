SELECT eqt.id, qt.name as questionTypeName, eqt.is_hard_connection
  FROM [CRM_1551_Analitics].[dbo].[EventClass_QuestionType] eqt 
  join QuestionTypes qt on qt.Id = eqt.question_type_id 
  join Event_Class ec on ec.id = eqt.event_class_id
  where ec.id = @Id and 
 #filter_columns#
 order by 1
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only