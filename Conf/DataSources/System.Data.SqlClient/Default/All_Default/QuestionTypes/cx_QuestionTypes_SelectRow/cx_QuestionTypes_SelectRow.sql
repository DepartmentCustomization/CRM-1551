--declare @id int=55;

SELECT distinct [QuestionTypes].[Id]
      ,parent_type.name as question_type_name
      ,parent_type.id as question_type_id
      ,[QuestionTypes].[index]
      ,[QuestionTypes].[name]
      ,[QuestionTypes].[emergency]
      ,[QuestionTypes].[active]
      ,[QuestionTypes].[rule_id]
      ,[QuestionTypes].[comments]
      ,ltrim(convert(numeric(8,1), convert(float, [QuestionTypes].[Attention_term_hours])/24))+N' ('+ltrim([QuestionTypes].[Attention_term_hours])+N')' [Attention_term_hours]
      ,ltrim(convert(numeric(8,1), convert(float, [QuestionTypes].[execution_term])/24))+N' ('+ltrim([QuestionTypes].[execution_term])+N')' [execution_term]
      ,QuestionTypes.[user_id]
      ,QuestionTypes.[edit_date]
      ,QuestionTypes.[user_edit_id]
	  --,case when [Rating].id=1 then [Rating].id end zhkg
	  --,case when [Rating].id=2 then [Rating].id end blag
	  --,case when [Rating].id=3 then [Rating].id end zhytraion
	  ,[Rating].zhkg
	  ,[Rating].blag
	  ,[Rating].zhytraion
	  ,[QuestionTypes].Object_is
	  ,[QuestionTypes].Organization_is
	  ,ltrim(Rules.Id)+N'-'+Rules.name RuleName
	  ,[QuestionTypes].[parent_organization_is]
  FROM [dbo].[QuestionTypes]
  --left join [QuestionTypeInRating] on [QuestionTypes].Id=[QuestionTypeInRating].QuestionType_id
  left join Rules on Rules.Id = QuestionTypes.rule_id
  left join [QuestionTypes] as parent_type on parent_type.Id = [QuestionTypes].question_type_id
  left join 
  (select [QuestionType_id], [1] zhkg, [2] blag, [3] zhytraion
  from 
  (select Id, [QuestionType_id], [Rating_id] from [QuestionTypeInRating]
  where [QuestionType_id]=@id) t
  pivot
  (
  sum(Id) for [Rating_id] in ([1], [2], [3])
  ) pvt) [Rating] on [QuestionTypes].Id=[Rating].QuestionType_id
  --left join [Rating] on [QuestionTypeInRating].Rating_id=[Rating].id
  where QuestionTypes.Id = @id