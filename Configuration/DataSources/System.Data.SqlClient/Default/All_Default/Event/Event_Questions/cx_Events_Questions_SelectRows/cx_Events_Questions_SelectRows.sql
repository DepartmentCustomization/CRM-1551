--declare @que_type int =2;
--declare @obj_id int =7;

select Questions.Id
	  ,Questions.registration_number
	  ,Questions.registration_date
	  ,Organizations.short_name as org_name
	from Questions
-- 		left join Assignments on Assignments.question_id = Questions.Id
		left join Assignments on Assignments.Id = Questions.last_assignment_for_execution_id
		left join Organizations on Organizations.Id = Assignments.executor_organization_id
		left join EventQuestionsTypes as eqt on eqt.[question_type_id] = Questions.question_type_id
where Questions.registration_date>=@start_date
and eqt.[is_hard_connection] = 1
and Questions.question_type_id = @que_type 
and Questions.[object_id]=@obj_id
and
    #filter_columns#
    #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
 

-- select Questions.Id
-- 	  ,Questions.registration_number
-- 	  ,Questions.registration_date
-- 	  ,Organizations.short_name as org_name
-- 	from Questions
-- -- 		left join Assignments on Assignments.question_id = Questions.Id
-- 		left join Assignments on Assignments.Id = Questions.last_assignment_for_execution_id
-- 		left join Organizations on Organizations.Id = Assignments.executor_organization_id
-- where Questions.question_type_id = @que_type
-- and
--     #filter_columns#
--     #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only