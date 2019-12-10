
-- declare @Id int = 52

-- declare @start_date datetime = (select registration_date from Events where Id = @Id)

SELECT
	Questions.Id
	  , Questions.registration_number
	  , Questions.registration_date
	  , Organizations.short_name AS org_name
FROM [Events] AS e
	LEFT JOIN EventClass_QuestionType AS ecqt ON ecqt.event_class_id = e.event_class_id
	LEFT JOIN EventObjects ON EventObjects.event_id = e.Id

	JOIN Questions
	ON Questions.question_type_id = ecqt.question_type_id
		AND Questions.[object_id] = EventObjects.[object_id]
	LEFT JOIN Assignments ON Assignments.Id = Questions.last_assignment_for_execution_id
	LEFT JOIN Organizations ON Organizations.Id = Assignments.executor_organization_id
	LEFT JOIN QuestionTypes ON QuestionTypes.Id = Questions.question_type_id
WHERE (e.Id = @Id
	AND Questions.registration_date >= e.registration_date
	AND ecqt.[is_hard_connection] = 1
	AND Assignments.main_executor = 1
	AND Assignments.assignment_state_id <> 5)
	OR Questions.event_id = @Id
    and 
        #filter_columns#
        #sort_columns#
    offset @pageOffsetRows rows fetch next @pageLimitRows rows only



/*
SELECT
	q.Id
	  , q.registration_number
	  , q.registration_date
	  , Organizations.short_name AS org_name
FROM [Events] AS e
	LEFT JOIN EventQuestionsTypes AS eqt ON eqt.event_id = e.Id
	LEFT JOIN [EventObjects] AS eo ON eo.event_id = e.Id
	LEFT JOIN Questions AS q ON q.question_type_id = eqt.question_type_id AND q.[object_id] = eo.[object_id]
	LEFT JOIN Assignments ON Assignments.Id = q.last_assignment_for_execution_id
	LEFT JOIN Organizations ON Organizations.Id = Assignments.executor_organization_id
WHERE (e.Id = @Id
	AND q.registration_date >= e.registration_date
	AND eqt.[is_hard_connection] = 1
	AND Assignments.main_executor = 1
	AND Assignments.assignment_state_id <> 5)
	OR q.event_id = e.Id
	AND
	#filter_columns#
#sort_columns#
    offset @pageOffsetRows rows
FETCH next @pageLimitRows rows only
*/