SELECT Questions.[Id]
	  , Questions.registration_number AS question_number
      , Questions.[registration_date] AS question_reg_date
	  , QuestionTypes.name AS question_types_name
	  , [Objects].name AS question_objects_name
	  , Organizations.short_name AS performer_name
FROM [dbo].[Events] AS e
	LEFT JOIN EventClass_QuestionType ON EventClass_QuestionType.event_class_id = e.event_class_id
	LEFT JOIN EventObjects ON EventObjects.event_id = e.Id

	JOIN Questions
		ON Questions.question_type_id = EventClass_QuestionType.question_type_id
		AND Questions.[object_id] = EventObjects.[object_id]
		and Questions.event_id is NULL
	LEFT JOIN Assignments ON Assignments.Id = Questions.last_assignment_for_execution_id
	LEFT JOIN Organizations ON Organizations.Id = Assignments.executor_organization_id
	LEFT JOIN QuestionTypes ON QuestionTypes.Id = Questions.question_type_id
	LEFT JOIN [Objects] ON [Objects].Id = Questions.[object_id]
	where  e.Id = @Id
	and
        #filter_columns#
        #sort_columns#
    offset @pageOffsetRows rows fetch next @pageLimitRows rows only