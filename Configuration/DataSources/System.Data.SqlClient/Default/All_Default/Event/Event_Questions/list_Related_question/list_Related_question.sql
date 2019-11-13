
-- declare @Id int = 52

-- declare @start_date datetime = (select registration_date from Events where Id = @Id)

select 
	   q.Id
	  ,q.registration_number
	  ,q.registration_date
	  ,Organizations.short_name as org_name
	FROM [Events] as e
    	left join EventQuestionsTypes as eqt on eqt.event_id = e.Id 
    	left join [EventObjects] as eo on eo.event_id = e.Id
    	left join Questions as q on q.question_type_id = eqt.question_type_id and q.[object_id] = eo.[object_id]
    	left join Assignments on Assignments.Id = q.last_assignment_for_execution_id
    	left join Organizations on Organizations.Id = Assignments.executor_organization_id
	where e.Id = @Id
	and q.registration_date >= e.registration_date
	and eqt.[is_hard_connection] = 1
	AND Assignments.main_executor = 1
	AND Assignments.assignment_state_id <> 5
    and 
        #filter_columns#
        #sort_columns#
    offset @pageOffsetRows rows fetch next @pageLimitRows rows only



-- select Questions.Id
-- 	  ,Questions.registration_number
-- 	  ,Questions.registration_date
-- 	  ,Organizations.short_name as org_name
-- 	from Questions
-- 		left join Assignments on Assignments.Id = Questions.last_assignment_for_execution_id
-- 		left join Organizations on Organizations.Id = Assignments.executor_organization_id
-- 		left join EventQuestionsTypes as eqt on eqt.[question_type_id] = Questions.question_type_id
-- where Questions.registration_date >= @start_date
-- and eqt.[is_hard_connection] = 1
-- -- and Questions.question_type_id in (SELECT[question_type_id]  FROM [dbo].[EventClass_QuestionType] where event_class_id = (select event_class_id from [Events] where Id = @Id)) 
-- and Questions.question_type_id in (SELECT[question_type_id]  FROM [dbo].[EventQuestionsTypes] where [event_id] = @Id) 
-- and Questions.[object_id] in ( select [object_id] from EventObjects where event_id = @Id )