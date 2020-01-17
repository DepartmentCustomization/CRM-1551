 -- declare @param1 nvarchar(max)=N'1=1'--N'zayavnyk_full_name like ''%Волосянко Надя Богданівна%'''
 -- declare @pageOffsetRows int =0;
 -- declare @pageLimitRows int =10;

declare @query nvarchar(max)=N'

 select 

   [Id]
  ,[appeals_receipt_source_name] [appeals_receipt_source]
  ,[appeals_user_name] [appeals_user]
  ,[appeals_district_name] [appeals_district] 
  ,[appeals_files_check]
  ,[zayavnyk_full_name]
  ,[zayavnyk_phone_number]
  ,[zayavnyk_building_street_name] [zayavnyk_building_street]

  ,isnull([shortname],N'''')+N'' ''+[zayavnyk_building_street_name]+N'', ''+[zayavnyk_building_number_name] [zayavnyk_building_number]


  --,[zayavnyk_building_number_name] [zayavnyk_building_number]
  ,[zayavnyk_entrance]
  ,[zayavnyk_flat]
  ,[zayavnyk_applicant_privilage_name] [zayavnyk_applicant_privilage]
  ,[zayavnyk_social_state_name] [zayavnyk_social_state]
  ,[zayavnyk_sex_name] [zayavnyk_sex]
  ,[zayavnyk_applicant_type_name] [zayavnyk_applicant_type]
  ,[zayavnyk_age]
  ,[zayavnyk_email]
  ,[question_registration_number]
  ,[question_ObjectTypes_name] [question_ObjectTypes]
  ,[question_object_name] [question_object]
  ,[question_organization_name] [question_organization]
  ,[question_question_type_name] [question_question_type]
  ,[question_question_state_name] [question_question_state]
  ,[question_list_state_name] [question_list_state]
  ,[assigm_executor_organization_name] [assigm_executor_organization]
  ,[assigm_main_executor]
  ,[assigm_question_content]
  ,[assigm_accountable] 
  ,[assigm_assignment_state_name] [assigm_assignment_state]  
  ,[assigm_assignment_result_name] [assigm_assignment_result] 
  ,[assigm_assignment_resolution_name] [assigm_assignment_resolution]
  ,[assigm_user_reviewed_name] [assigm_user_reviewed] 
  ,[assigm_user_checked_name] [assigm_user_checked]
  ,[registration_date] 
  ,[transfer_date] 
  ,[state_changed_date]
  ,[state_changed_date_done]
  ,[execution_term] 
 from
 (
  select top 8 [Assignments].Id,
  [Appeals].receipt_source_id [appeals_receipt_source]
  ,[ReceiptSources].name [appeals_receipt_source_name]
  ,[Appeals].user_id [appeals_user]
  --,[Workers].Id [appeals_user_Id]
  ,[Workers].name [appeals_user_name]
  ,[Districts].Id [appeals_district] 
  ,[Districts].name [appeals_district_name] 
  ,case when [AssignmentConsDocFiles].[File] is not null then convert(bit, N''true'') else convert(bit, N''false'') end appeals_files_check
  ,[Applicants].full_name zayavnyk_full_name
  ,[ApplicantPhones].phone_number zayavnyk_phone_number 
  ,[Streets].Id [zayavnyk_building_street]
  ,[Streets].name [zayavnyk_building_street_name]
  ,[Buildings].Id [zayavnyk_building_number]
  ,[Buildings].name [zayavnyk_building_number_name]
  ,[LiveAddress].entrance [zayavnyk_entrance]
  ,[LiveAddress].flat [zayavnyk_flat]
  ,[ApplicantPrivilege].Id [zayavnyk_applicant_privilage]
  ,[ApplicantPrivilege].Name [zayavnyk_applicant_privilage_name]
  ,[SocialStates].Id [zayavnyk_social_state]
  ,[SocialStates].name [zayavnyk_social_state_name]
  ,[Applicants].sex [zayavnyk_sex]
  ,case when [Applicants].sex=1 then N''жіноча'' when [Applicants].sex=2 then N''чоловіча'' end [zayavnyk_sex_name]
  ,[ApplicantTypes].Id [zayavnyk_applicant_type]
  ,[ApplicantTypes].name [zayavnyk_applicant_type_name]
  ,case 
when [Applicants].[birth_date] is null then year(getdate())-[Applicants].birth_year
  when month([Applicants].[birth_date])<=month(getdate())
  and day([Applicants].[birth_date])<=day(getdate())
  then DATEDIFF(yy, [Applicants].[birth_date], getdate())
  else DATEDIFF(yy, [Applicants].[birth_date], getdate())-1 end zayavnyk_age,
  [Applicants].mail zayavnyk_email
  
  ,[Questions].registration_number [question_registration_number]
  ,[ObjectTypes].Id [question_ObjectTypes]
  ,[ObjectTypes].name [question_ObjectTypes_name]
  ,[Objects].Id [question_object]
  ,[Objects].name [question_object_name]
  ,[Organizations].Id [question_organization]
  ,[Organizations].short_name [question_organization_name]
  ,[QuestionTypes].Id [question_question_type]
  ,[QuestionTypes].name [question_question_type_name]
  ,[QuestionStates].Id [question_question_state]
  ,[QuestionStates].name [question_question_state_name]
  ,[Rating].Id [question_list_state]
  ,[Rating].name [question_list_state_name]

  ,[Assignments].executor_organization_id [assigm_executor_organization] -- good
  ,[Organizations2].short_name [assigm_executor_organization_name] -- good
  ,[Assignments].main_executor [assigm_main_executor] -- good
  ,[Questions].question_content [assigm_question_content] -- good
   ,null [assigm_accountable] -- good

  ,[AssignmentStates].Id [assigm_assignment_state] -- good
  ,[AssignmentStates].name [assigm_assignment_state_name] -- good
         
  ,[AssignmentResults].Id [assigm_assignment_result] -- good
  ,[AssignmentResults].name [assigm_assignment_result_name] -- good
        
  ,[AssignmentResolutions].Id [assigm_assignment_resolution] -- good
  ,[AssignmentResolutions].name [assigm_assignment_resolution_name] -- good

  ,[AssignmentConsiderations].user_id [assigm_user_reviewed] -- good
  ,[Workers2].name [assigm_user_reviewed_name] -- good
   
  ,[AssignmentRevisions].user_id [assigm_user_checked] 

  ,[Workers3].name [assigm_user_checked_name]


  ,format([Appeals].registration_date, ''dd.MM.yyyy HH:mm'') [registration_date] -- good
  --,[AssignmentConsiderations].transfer_date [transfer_date] -- good
  ,format([AssignmentConsiderations].transfer_date, ''dd.MM.yyyy HH:mm'') [transfer_date]
  --,case when [Assignments].assignment_state_id=3
  --then [Assignments].state_change_date end [state_changed_date] -- good
  ,case when [Assignments].assignment_state_id=3
  then format([Assignments].state_change_date, ''dd.MM.yyyy HH:mm'') end [state_changed_date] -- good

  --,case when [Assignments].assignment_state_id=3 and [AssignmentConsiderations].assignment_result_id=4
  --then [Assignments].state_change_date end [state_changed_date_done] -- good

  ,case when [Assignments].assignment_state_id=3 and [AssignmentConsiderations].assignment_result_id=4
  then format([Assignments].state_change_date, ''dd.MM.yyyy HH:mm'') end [state_changed_date_done] -- good

  ,[QuestionTypes].execution_term [execution_term] --good
 
 , [StreetTypes].[shortname]
  from 

  [CRM_1551_Analitics].[dbo].[Assignments] 
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Questions].[appeal_id]=[Appeals].Id
  left join [CRM_1551_Analitics].[dbo].[Applicants] on [Applicants].Id=[Appeals].applicant_id

  


--   left join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [AssignmentConsiderations].assignment_id=[Assignments].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [AssignmentConsiderations].Id = Assignments.current_assignment_consideration_id
  left join [CRM_1551_Analitics].[dbo].[AssignmentConsDocuments] on [AssignmentConsiderations].Id=[AssignmentConsDocuments].assignment_сons_id
  left join [CRM_1551_Analitics].[dbo].[AssignmentConsDocFiles] on [AssignmentConsDocuments].Id=[AssignmentConsDocFiles].assignment_cons_doc_id
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentConsiderations].assignment_result_id=[AssignmentResults].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentConsiderations].assignment_resolution_id=[AssignmentResolutions].id
  left join [CRM_1551_Analitics].[dbo].[AssignmentRevisions] on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
  left join [CRM_1551_Analitics].[dbo].[Organizations] [Organizations2] on [Assignments].executor_organization_id=[Organizations2].Id
  left join [CRM_1551_Analitics].[dbo].[Workers] [Workers2] on [AssignmentConsiderations].user_id=[Workers2].worker_user_id
  left join [CRM_1551_Analitics].[dbo].[Workers] [Workers3] on [AssignmentRevisions].user_id=[Workers3].worker_user_id

  

  
  left join [CRM_1551_Analitics].[dbo].[ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
  left join [CRM_1551_Analitics].[dbo].[Workers] on [Appeals].user_id=[Workers].worker_user_id

  
  left join [CRM_1551_Analitics].[dbo].[ApplicantPhones] on [ApplicantPhones].applicant_id=[Applicants].id
  left join [CRM_1551_Analitics].[dbo].[LiveAddress] on [LiveAddress].applicant_id=[Applicants].Id
  left join [CRM_1551_Analitics].[dbo].[Buildings] on [LiveAddress].building_id=[Buildings].Id
  left join [CRM_1551_Analitics].[dbo].[Districts] on [Buildings].district_id=[Districts].Id
  left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=[Streets].Id

  left join [CRM_1551_Analitics].[dbo].[StreetTypes] on [Streets].[street_type_id]=[StreetTypes].Id

  left join [CRM_1551_Analitics].[dbo].[ApplicantPrivilege] on [Applicants].applicant_privilage_id=[ApplicantPrivilege].Id
  left join [CRM_1551_Analitics].[dbo].[SocialStates] on [Applicants].social_state_id=[SocialStates].Id
  left join [CRM_1551_Analitics].[dbo].[ApplicantTypes] on [Applicants].applicant_type_id=[ApplicantTypes].Id

  
  left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].object_id=[Objects].Id
  left join [CRM_1551_Analitics].[dbo].[ObjectTypes] on [Objects].object_type_id=[ObjectTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Questions].organization_id=[Organizations].Id
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
  left join [CRM_1551_Analitics].[dbo].[QuestionStates] on [Questions].question_state_id=[QuestionStates].Id
  left join [CRM_1551_Analitics].[dbo].[QuestionTypeInRating] on [QuestionTypeInRating].QuestionType_id=[QuestionTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Rating] on [QuestionTypeInRating].Rating_id=[Rating].Id
  

  
  ) a
  where '+@param1+ N' 
'

  --and #filter_columns#
  --#sort_columns#
 --offset ' + (select ltrim(@pageOffsetRows))+N' rows fetch next '+ (select ltrim(@pageLimitRows))+N' rows only
 
 
  exec(@query)