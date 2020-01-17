
SELECT 
	   [Assignments].[Id]
	   ,Assignments.question_id

      ,[Assignments].[registration_date]
	  ,ast.id as ass_state_id
	  ,ast.name as ass_state_name
	  ,assR.name as result_name
	  ,assR.Id as result_id
	  ,assRn.name as resolution_name
	  ,assRn.Id as resolution_id
      ,[Assignments].[execution_date]
      ,assC.short_answer
      ,aty.Id as ass_type_id
      ,aty.name as ass_type_name
      ,Assignments.main_executor
	  ,perf.Id as performer_id
	  ,case when len(perf.[head_name]) > 5 then perf.[head_name] + ' ( ' + perf.[short_name] + ')'
					else perf.[short_name] end as performer_name
	  ,case when len(responsible.[head_name]) > 5 then responsible.[head_name] + ' ( ' + responsible.[short_name] + ')'
					else responsible.[short_name] end as responsible_name
	  ,responsible.Id as responsible
	  ,(select Id from AssignmentConsiderations where Id = 
					(select current_assignment_consideration_id from Assignments where Id = @Id)) as assignmentConsiderations_id
	  ,(select count( assg.main_executor)
			 from  [Assignments] assg 
			 where assg.question_id = Assignments.question_id and assg.main_executor = 1 and assg.close_date is null) as is_aktiv_true
	  ,assRev.control_comment
	  ,isnull(assRev.rework_counter,0) as rework_counter
	  ,assC.[transfer_to_organization_id]
	  ,org_tr.short_name as transfer_name
	  ,'1' as is_view
  FROM [dbo].[Assignments]
	left join AssignmentTypes aty on aty.Id = Assignments.assignment_type_id
	left join AssignmentStates ast on ast.Id = Assignments.assignment_state_id

-- 	left join AssignmentConsiderations assC on assC.assignment_id = Assignments.Id
	left join AssignmentConsiderations assC on assC.Id = Assignments.current_assignment_consideration_id
    left join AssignmentResults assR on assR.Id = Assignments.AssignmentResultsId
	left join AssignmentResolutions assRn on assRn.Id = Assignments.AssignmentResolutionsId
	left join AssignmentRevisions  assRev on assRev.assignment_consideration_іd = assC.Id
	left join Organizations as perf on perf.Id = Assignments.executor_organization_id
	left join Organizations as responsible on responsible.Id = Assignments.organization_id
	left join Organizations  as org_tr on org_tr.Id = assC.transfer_to_organization_id
 where Assignments.Id = @Id