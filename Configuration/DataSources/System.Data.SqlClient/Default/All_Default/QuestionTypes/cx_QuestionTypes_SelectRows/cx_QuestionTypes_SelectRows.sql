SELECT [QuestionTypes].[Id]
      ,[QuestionTypes].[name]
      ,parent_type.name as parent_type_name
      ,[QuestionTypes].[emergency]
      ,[QuestionTypes].[active]
      ,[QuestionTypes].[Attention_term_hours]
      ,[QuestionTypes].[execution_term]
  FROM [dbo].[QuestionTypes]
  left join [QuestionTypes] as parent_type on parent_type.Id = [QuestionTypes].question_type_id
  where  #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only