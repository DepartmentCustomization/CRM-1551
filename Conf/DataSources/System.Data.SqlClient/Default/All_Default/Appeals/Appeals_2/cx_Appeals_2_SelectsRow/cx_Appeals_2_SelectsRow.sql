SELECT 
	 Appeals.Id
	,Appeals.registration_number
	,Appeals.phone_number
	,Questions.receipt_date
	    ,ReceiptSources.Name as receipt_source_name
		,ReceiptSources.Id as receipt_source_id
	
	,Applicants.full_name
	,Applicants.applicant_category_id
	,Applicants.social_state_id
	
	,QuestionStates.name as question_state_name ,QuestionStates.Id  as question_state_id
	,QuestionTypes.Id as question_type_id ,QuestionTypes.name as question_type_name
    ,Questions.control_date
    ,Questions.question_content

    ,[Objects].Id as object_id
	,[Objects].name as object_name
	,ObjectTypes.name as object_type_name
	,ObjectTypes.Id as object_type_id
	,Districts.name as districts_name
	,,Districts.Id as districts_id
    ,Questions.object_comment

    ,Questions.application_town_id	

	,Organizations.Id as organization_id	,Organizations.name as organization_name

	,AnswerTypes.Id as answer_type_id	,AnswerTypes.name as answer_type_name
    ,Questions.answer_phone
    ,Questions.answer_post
    ,Questions.answer_mail

    ,[Events].Id as event_id	,[Events].name as event_name

    ,Questions.user_id
    ,Questions.edit_date
    ,Questions.user_edit_id
  FROM dbo.Appeals
    left join ReceiptSources on ReceiptSources.Id = Appeals.receipt_source_id
	left join Questions on Appeals.Id = Questions.appeal_id
	left join Applicants on Applicants.Id = Appeals.applicant_id
	left join QuestionStates on QuestionStates.Id = Questions.question_state_id
	left join QuestionTypes on QuestionTypes.Id = Questions.question_type_id
	left join AnswerTypes on AnswerTypes.Id = Questions.answer_form_id
	left join Organizations on Organizations.Id = Questions.organization_id
	left join [Events] on [Events].Id = Questions.event_id
	left join [Objects] on [Objects].Id = Questions.[object_id]
	left join ObjectTypes on ObjectTypes.Id = [Objects].object_type_id
	left join Districts on Districts.Id = [Objects].district_id
	left join Streets on Streets.Id = [Objects].street_id
