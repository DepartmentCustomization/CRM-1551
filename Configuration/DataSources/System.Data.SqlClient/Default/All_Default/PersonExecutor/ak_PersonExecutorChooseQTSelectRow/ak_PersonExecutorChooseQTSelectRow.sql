select [PersonExecutorChooseQT].Id, [PersonExecutorChoose].name person_executor_choose_name, 
[PersonExecutorChoose].Id person_executor_choose_id, [QuestionTypes].Id question_type_id,
[QuestionTypes].name question_type_name
  from [PersonExecutorChooseQT]
  inner join [PersonExecutorChoose] on [PersonExecutorChooseQT].person_executor_choose_id=[PersonExecutorChoose].Id
  inner join [QuestionTypes] on [PersonExecutorChooseQT].question_type_id=[QuestionTypes].Id
  where [PersonExecutorChooseQT].Id=@Id