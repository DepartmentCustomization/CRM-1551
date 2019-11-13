--declare @Id int = 6690178;

SELECT [Questions].[Id]
	,[Questions].[registration_number]
	,[Questions].[Id] as ques_id
	,Appeals.registration_number as app_registration_number
	,Questions.appeal_id
	,Applicants.full_name
	,Applicants.Id as appl_id
	
	,QuestionStates.name as question_state_name 
	,QuestionStates.Id  as question_state_id
	,QuestionTypes.Id as question_type_id 
	,QuestionTypes.name as question_type_name
    ,[Questions].[control_date]
    ,[Questions].[question_content]

    ,[Objects].Id as [object_id]
    , isnull(ObjectTypes.name+N' : ', N'')+
	   isnull([Objects].Name+' ',N'') [object_name]
	--,concat(Districts.name + ' р-н., ',StreetTypes.shortname,' ',Streets.name, ' ', Buildings.number,Buildings.letter) as address_problem0
	,isnull(Districts.name + N' р-н., ', N'')+
	isnull(StreetTypes.shortname+N' ', N'')+
	   isnull(Streets.name+N' ', N'') +
	   isnull(Buildings.name, N'') address_problem

	,ObjectTypes.name as object_type_name
	,Districts.name as districts_name
	,Districts.Id as districts_id
    ,[Questions].[object_comment]

    ,[Questions].[application_town_id]	

	,Organizations.Id as organization_id	
	,Organizations.[short_name] as organization_name

	,AnswerTypes.Id as answer_type_id	
	,AnswerTypes.name as answer_type_name
    ,[Questions].[answer_phone]
    ,[Questions].[answer_post]
    ,[Questions].[answer_mail]
    ,Questions.event_id

	,[Questions].[registration_date]
    ,[Questions].[user_id]
    ,[Questions].[edit_date]
    ,[Questions].[user_edit_id]
    
    ,perfom.Id as perfom_id
    -- ,perfom.short_name as perfom_name
    ,IIF (len(perfom.[head_name]) > 5,  concat(perfom.[head_name] , ' ( ' , perfom.[short_name] , ')'),  perfom.[short_name]) as perfom_name
    
    ,assR.Id as ass_result_id
	,assR.name as ass_result_name
	,assRn.Id as ass_resolution_id
	,assRn.name as ass_resolution_name
	,Questions.Id as question_id
	,isnull([User].[FirstName], N'')+N' '+isnull([User].[LastName], N' ') [user_name]
	,(select top 1
			case
				when assignment_state_id = 1 then 1
				else 0
				-- when assignment_state_id <> 1 then 2
				end 
		from Assignments where question_id = @Id and main_executor = 1
	  )as flag_is_state
  FROM [dbo].[Questions]
	left join Appeals on Appeals.Id = Questions.appeal_id
	left join Applicants on Applicants.Id = Appeals.applicant_id
	left join QuestionStates on QuestionStates.Id = Questions.question_state_id
	left join QuestionTypes on QuestionTypes.Id = Questions.question_type_id
	left join AnswerTypes on AnswerTypes.Id = Questions.answer_form_id
	left join Organizations on Organizations.Id = Questions.organization_id
	left join [Objects] on [Objects].Id = Questions.[object_id]
	
	left join Buildings on Buildings.Id = [Objects].builbing_id
	left join Streets on Streets.Id = Buildings.street_id
	left join StreetTypes on StreetTypes.Id = Streets.street_type_id
	
	left join ObjectTypes on ObjectTypes.Id = [Objects].object_type_id
	left join Districts on Districts.Id = [Buildings].district_id
	left join Assignments on Assignments.question_id = Questions.Id and Assignments.main_executor = 1 --and Assignments.close_date is null
-- 	left join AssignmentConsiderations assC on assC.assignment_id = Assignments.Id
	left join AssignmentConsiderations assC on assC.Id = Assignments.current_assignment_consideration_id
	left join AssignmentResults assR on assR.Id = Assignments.AssignmentResultsId
	left join AssignmentResolutions assRn on assRn.Id = Assignments.AssignmentResolutionsId
	left join Organizations perfom on perfom.Id = Assignments.[executor_organization_id]
	left join [CRM_1551_System].[dbo].[User] on [Questions].[user_id]=[User].UserId

WHERE [Questions].[Id] = @Id
