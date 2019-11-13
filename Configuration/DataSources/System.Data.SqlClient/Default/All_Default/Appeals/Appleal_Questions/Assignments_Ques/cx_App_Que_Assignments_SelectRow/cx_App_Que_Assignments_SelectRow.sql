--declare @Id int =2231581;

SELECT distinct top 1
	   [Assignments].[Id]
	   ,Questions.registration_number
	   ,ReceiptSources.Id as receipt_source_id
	   ,ReceiptSources.name as receipt_source_name
	   ,Questions.registration_date as que_reg_date
	   ,Applicants.full_name
	 --  ,IIF(stre.name is null, null, concat(dis.name, ' р-н., ', StreetTypes.shortname,' ', stre.name, ' ', buil.number, buil.letter, ', ',
		--IIF(LiveAddress.[entrance] is null, null, concat('п. ',LiveAddress.[entrance],',' )), ' ',
		--	IIF(LiveAddress.flat is null, null, concat('кв. ',LiveAddress.flat) )
		--)) as LiveAddress
	   ,Applicants.ApplicantAdress LiveAddress
	   ,[Objects].Id as [object_id]
	   --,IIF(st.name is null, null, concat(ObjectTypes.name,' : ',sty.shortname,' ', st.name, ' ', bl.number,bl.letter)) as [object_name0]

	   ,isnull(ObjectTypes.name+N' : ', N'')+
	   isnull(sty.shortname+' ',N'')+
	   isnull(st.name+N' ',N'')+
	   isnull(bl.name,N'') [object_name]

       --,IIF(st.name is null, null,concat(sty.shortname,' ',st.name, ' ', bl.number,bl.letter) ) as address_problem
	   ,isnull(sty.shortname+N' ', N'')+
	   isnull(st.name+N' ', N'') +
	   isnull(bl.name, N'') address_problem

	   ,Organizations.Id as organization_id
	   ,Organizations.name as organization_name
	   ,QuestionTypes.Id as obj_type_id
	   ,QuestionTypes.name as obj_type_name
	   ,Questions.question_content
	   ,Questions.control_date

      ,[Assignments].[registration_date]
      --,assC.transfer_date [registration_date]
	  ,ast.id as ass_state_id
	  ,ast.name as ass_state_name
	  ,assR.name as result_name
	  ,assR.Id as result_id
	  ,assRn.name as resolution_name
	  ,assRn.Id as resolution_id
      ,[Assignments].[execution_date]
    -- ,Questions.control_date as [execution_date]
      ,assC.short_answer
      ,Assignments.question_id
      ,aty.Id as ass_type_id
      ,aty.name as ass_type_name
      ,Assignments.main_executor
	  ,perf.Id as performer_id
-- 	  ,perf.head_name+ ' ('+perf.short_name+')' as performer_name
	  ,case when len(perf.[head_name]) > 5 then perf.[head_name] + ' ( ' + perf.[short_name] + ')'
					else perf.[short_name] end as performer_name
	  ,case when len(responsible.[head_name]) > 5 then responsible.[head_name] + ' ( ' + responsible.[short_name] + ')'
					else responsible.[short_name] end as responsible_name
	  ,responsible.Id as responsible
-- 	  ,assC.Id as assignmentConsiderations_id
	  ,(select current_assignment_consideration_id from Assignments where Id = @Id) as assignmentConsiderations_id
	  ,(select count( assg.main_executor)
			 from  [Assignments] assg 
			 where assg.question_id = Assignments.question_id and assg.main_executor = 1 and assg.close_date is null) as is_aktiv_true
--	  ,assRev.control_comment
	  , ( SELECT TOP 1 	control_comment FROM AssignmentRevisions AS ar
				JOIN AssignmentConsiderations AS ac ON ac.Id = ar.assignment_consideration_іd
					WHERE ac.assignment_id = @Id ORDER BY ar.id DESC ) as control_comment
-- 	  ,isnull(assRev.rework_counter,0) as rework_counter
	  ,(select count(id) from AssignmentRevisions where assignment_consideration_іd in
	    (select Id from AssignmentConsiderations where assignment_id= @Id) and control_result_id = 5 )  as rework_counter
	  ,assC.[transfer_to_organization_id]

	  ,case when len(org_tr.[head_name]) > 5 then org_tr.[head_name] + ' ( ' + org_tr.[short_name] + ')'
					else org_tr.[short_name] end transfer_name

	  --,org_tr.short_name as transfer_name
	    ,ast.id as old_assignment_state_id
        ,assR.Id as old_assignment_result_id
        ,assRn.Id as old_assignment_resolution_id
        ,[Assignments].current_assignment_consideration_id as current_consid

		,stuff((select N','+[phone_number]
  from [CRM_1551_Analitics].[dbo].[ApplicantPhones] p
  where p.applicant_id=[ApplicantPhones].[applicant_id]
  for xml path('')), 1,1,N'') phones

  ,stuff((select N', '+[AnswerTypes].name+N'-'+
  case when q.[answer_phone] is not null then q.[answer_phone]
  when q.[answer_post] is not null then q.[answer_post]
  when q.[answer_mail] is not null then q.[answer_mail]
  end
  from [Assignments] a 
  left join [Questions] q on a.question_id=q.Id
  left join [AnswerTypes] on q.answer_form_id=[AnswerTypes].Id
  where a.Id=[Assignments].id
  for xml path('')
  ),1,2,N'') answer
  ,org_bal.short_name bal_name
  ,case when [ReceiptSources].code=N'UGL' then Appeals.[enter_number] end [enter_number]
  ,Assignments.edit_date as date_in_form
  FROM [dbo].[Assignments]
	left join AssignmentTypes aty on aty.Id = Assignments.assignment_type_id
	left join AssignmentStates ast on ast.Id = Assignments.assignment_state_id
	left join Questions on Questions.Id = Assignments.question_id
	left join QuestionTypes on QuestionTypes.Id = Questions.question_type_id
	left join Appeals on Appeals.Id = Questions.appeal_id
	left join ReceiptSources on ReceiptSources.Id = Appeals.receipt_source_id

	left join Applicants on Applicants.Id = Appeals.applicant_id
	left join LiveAddress on LiveAddress.applicant_id = Applicants.Id  and LiveAddress.main = 1
	left join Buildings buil on buil.Id = LiveAddress.building_id
	left join Streets stre on stre.Id = buil.street_id
	left join Districts dis on dis.Id = buil.district_id
	left join StreetTypes on StreetTypes.Id = stre.street_type_id
	
	left join Organizations on Organizations.Id = Questions.organization_id
	left join [Objects] on [Objects].Id = Questions.[object_id]
	left join Buildings bl on bl.Id = [Objects].builbing_id
	left join Streets st on st.Id = bl.street_id
	left join StreetTypes sty on sty.Id = st.street_type_id
	left join ObjectTypes on ObjectTypes.Id = [Objects].object_type_id
	--left join AssignmentConsiderations assC on assC.assignment_id = Assignments.Id
	left join AssignmentConsiderations assC on assC.Id = Assignments.current_assignment_consideration_id
    left join AssignmentResults assR on assR.Id = Assignments.AssignmentResultsId
	left join AssignmentResolutions assRn on assRn.Id = Assignments.AssignmentResolutionsId
	left join AssignmentRevisions  assRev on assRev.assignment_consideration_іd = assC.Id
	left join Organizations as perf on perf.Id = Assignments.executor_organization_id
	left join Organizations as responsible on responsible.Id = Assignments.organization_id
	left join Organizations  as org_tr on org_tr.Id = assC.transfer_to_organization_id
	left join [ApplicantPhones] on Applicants.Id=[ApplicantPhones].applicant_id
	left join (select [building_id], [executor_id]
                from [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject]
                    where [executor_role_id]=1 /*Балансоутримувач*/) balans on bl.Id=balans.building_id
    left join [Organizations] org_bal on balans.executor_id=org_bal.Id
 where Assignments.Id = @Id
 -- @que_id ???? было в параметрах