select [PersonExecutorChooseQT].Id, [QuestionTypes].name QuestionType_name
  from [PersonExecutorChooseQT]
  inner join [QuestionTypes] on [PersonExecutorChooseQT].question_type_id=[QuestionTypes].Id
  where [PersonExecutorChooseQT].person_executor_choose_id=@person_executor_choose_id
and #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
