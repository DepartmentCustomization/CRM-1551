select qtt.Id, qt.name question_type_name
  from [QuestionTypeTemplates] qtt
  inner join [QuestionTypes] qt on qtt.question_type_id=qt.Id
  where [template_id]=@template_id
  and 
  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
