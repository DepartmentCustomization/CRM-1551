 --DECLARE @column nvarchar(200)=N'count_arrived';
 --DECLARE @sector_id INT=2;
 --DECLARE @user_id nvarchar(200)=N'8cbd0469-56f1-474b-8ea6-904d783a0941';



  IF @column=N'count_arrived' --2
	BEGIN
		SELECT [Assignments].Id, [Questions].[registration_number], [Assignments].registration_date, [QuestionTypes].name questionType, 
		[Applicants].full_name applicant, [Objects].name [place_problem], [Questions].control_date,

		-- (SELECT TOP 1 ISNULL([Districts].name+N' р-н, ',N' ')+ISNULL([StreetTypes].shortname+N' ', N'')+ ISNULL([Streets].name, N'')+ISNULL(N', '+[Buildings].name, N'')+ISNULL(N', кв '+[LiveAddress].flat,N'')
		-- FROM [dbo].[LiveAddress] 
		--  LEFT JOIN [dbo].[Buildings] ON [LiveAddress].building_id=[Buildings].Id
		--  LEFT JOIN [dbo].[Districts] ON [Buildings].district_id=[Districts].Id
		--  LEFT JOIN [dbo].[Streets] ON [Buildings].street_id=[Streets].Id
		--  LEFT JOIN [dbo].[StreetTypes] ON [Streets].street_type_id=[StreetTypes].Id
		--  WHERE [LiveAddress].applicant_id=[Applicants].Id) applicantAdress,
		 [Applicants].ApplicantAdress applicantAdress, [Questions].question_content content,

		 (SELECT TOP 1 [Organizations].short_name FROM [dbo].[ExecutorInRoleForObject]
		 INNER JOIN [dbo].[Organizations] ON [ExecutorInRoleForObject].executor_id=[Organizations].Id
		 WHERE [executor_role_id]=1 AND [ExecutorInRoleForObject].object_id=[Questions].object_id) balancer
		 ,[Organizations].short_name executor
		FROM [dbo].[QuestionsInTerritory]
	    INNER JOIN [dbo].[Questions] ON [QuestionsInTerritory].question_id=[Questions].Id
	    INNER JOIN [dbo].[Assignments] ON [Questions].Id=[Assignments].question_id
		LEFT JOIN [dbo].[Organizations] ON [Assignments].executor_organization_id=[Organizations].Id
		--INNER JOIN @person_executor_choose_table p_tab ON [Assignments].[executor_person_id]=p_tab.Id
		--INNER JOIN @sector_org_table st ON [Assignments].executor_organization_id=st.organization_id
		INNER JOIN [dbo].[Appeals] ON [Questions].appeal_id=[Appeals].Id
		LEFT JOIN [dbo].[Applicants] ON [Appeals].applicant_id=[Applicants].Id
		LEFT JOIN [dbo].[QuestionTypes] ON [Questions].question_type_id=[QuestionTypes].Id
		LEFT JOIN [dbo].[Objects] ON [Questions].object_id=[Objects].Id
		WHERE [QuestionsInTerritory].territory_id =@sector_id AND
		 [Assignments].assignment_state_id=1 /*зареєстровано*/ AND [Questions].control_date>=GETUTCDATE()
		AND #filter_columns#
		--#sort_columns#
		ORDER BY 1
		offset @pageOffsetRows rows fetch next @pageLimitRows rows only
	END

	IF @column=N'count_in_work' --3
	BEGIN
		SELECT [Assignments].Id, [Questions].[registration_number], [Assignments].registration_date, [QuestionTypes].name questionType, 
		[Applicants].full_name applicant, [Objects].name [place_problem], [Questions].control_date,

		-- (SELECT TOP 1 ISNULL([Districts].name+N' р-н, ',N' ')+ISNULL([StreetTypes].shortname+N' ', N'')+ ISNULL([Streets].name, N'')+ISNULL(N', '+[Buildings].name, N'')+ISNULL(N', кв '+[LiveAddress].flat,N'')
		-- FROM [dbo].[LiveAddress] 
		--  LEFT JOIN [dbo].[Buildings] ON [LiveAddress].building_id=[Buildings].Id
		--  LEFT JOIN [dbo].[Districts] ON [Buildings].district_id=[Districts].Id
		--  LEFT JOIN [dbo].[Streets] ON [Buildings].street_id=[Streets].Id
		--  LEFT JOIN [dbo].[StreetTypes] ON [Streets].street_type_id=[StreetTypes].Id
		--  WHERE [LiveAddress].applicant_id=[Applicants].Id) applicantAdress,
		 [Applicants].ApplicantAdress applicantAdress, [Questions].question_content content,

		 (SELECT TOP 1 [Organizations].short_name FROM [dbo].[ExecutorInRoleForObject]
		 INNER JOIN [dbo].[Organizations] ON [ExecutorInRoleForObject].executor_id=[Organizations].Id
		 WHERE [executor_role_id]=1 AND [ExecutorInRoleForObject].object_id=[Questions].object_id) balancer
		 ,[Organizations].short_name executor
		FROM [dbo].[QuestionsInTerritory]
	    INNER JOIN [dbo].[Questions] ON [QuestionsInTerritory].question_id=[Questions].Id
	    INNER JOIN [dbo].[Assignments] ON [Questions].Id=[Assignments].question_id
		LEFT JOIN [dbo].[Organizations] ON [Assignments].executor_organization_id=[Organizations].Id
		--INNER JOIN @person_executor_choose_table p_tab ON [Assignments].[executor_person_id]=p_tab.Id
		--INNER JOIN @sector_org_table st ON [Assignments].executor_organization_id=st.organization_id
		INNER JOIN [dbo].[Appeals] ON [Questions].appeal_id=[Appeals].Id
		LEFT JOIN [dbo].[Applicants] ON [Appeals].applicant_id=[Applicants].Id
		LEFT JOIN [dbo].[QuestionTypes] ON [Questions].question_type_id=[QuestionTypes].Id
		LEFT JOIN [dbo].[Objects] ON [Questions].object_id=[Objects].Id
		WHERE [QuestionsInTerritory].territory_id =@sector_id AND [Assignments].assignment_state_id=2 /*в роботі*/ AND [Questions].control_date>=GETUTCDATE()
		
		AND #filter_columns#
		--#sort_columns#
		ORDER BY 1
		offset @pageOffsetRows rows fetch next @pageLimitRows rows only
	END

	IF @column=N'count_overdue' --4
	BEGIN
		SELECT [Assignments].Id, [Questions].[registration_number], [Assignments].registration_date, [QuestionTypes].name questionType, 
		[Applicants].full_name applicant, [Objects].name [place_problem], [Questions].control_date,

		-- (SELECT TOP 1 ISNULL([Districts].name+N' р-н, ',N' ')+ISNULL([StreetTypes].shortname+N' ', N'')+ ISNULL([Streets].name, N'')+ISNULL(N', '+[Buildings].name, N'')+ISNULL(N', кв '+[LiveAddress].flat,N'')
		-- FROM [dbo].[LiveAddress] 
		--  LEFT JOIN [dbo].[Buildings] ON [LiveAddress].building_id=[Buildings].Id
		--  LEFT JOIN [dbo].[Districts] ON [Buildings].district_id=[Districts].Id
		--  LEFT JOIN [dbo].[Streets] ON [Buildings].street_id=[Streets].Id
		--  LEFT JOIN [dbo].[StreetTypes] ON [Streets].street_type_id=[StreetTypes].Id
		--  WHERE [LiveAddress].applicant_id=[Applicants].Id) applicantAdress,
		 [Applicants].ApplicantAdress applicantAdress, [Questions].question_content content,

		 (SELECT TOP 1 [Organizations].short_name FROM [dbo].[ExecutorInRoleForObject]
		 INNER JOIN [dbo].[Organizations] ON [ExecutorInRoleForObject].executor_id=[Organizations].Id
		 WHERE [executor_role_id]=1 AND [ExecutorInRoleForObject].object_id=[Questions].object_id) balancer
		 ,[Organizations].short_name executor
		FROM [dbo].[QuestionsInTerritory]
	    INNER JOIN [dbo].[Questions] ON [QuestionsInTerritory].question_id=[Questions].Id
	    INNER JOIN [dbo].[Assignments] ON [Questions].Id=[Assignments].question_id
		LEFT JOIN [dbo].[Organizations] ON [Assignments].executor_organization_id=[Organizations].Id
		--INNER JOIN @person_executor_choose_table p_tab ON [Assignments].[executor_person_id]=p_tab.Id
		--INNER JOIN @sector_org_table st ON [Assignments].executor_organization_id=st.organization_id
		INNER JOIN [dbo].[Appeals] ON [Questions].appeal_id=[Appeals].Id
		LEFT JOIN [dbo].[Applicants] ON [Appeals].applicant_id=[Applicants].Id
		LEFT JOIN [dbo].[QuestionTypes] ON [Questions].question_type_id=[QuestionTypes].Id
		LEFT JOIN [dbo].[Objects] ON [Questions].object_id=[Objects].Id
		WHERE [QuestionsInTerritory].territory_id =@sector_id AND [Assignments].assignment_state_id IN (1,2) /*зареєстровано в роботі*/ AND [Questions].control_date<GETUTCDATE()
		
		AND #filter_columns#
		--#sort_columns#
		ORDER BY 1
		offset @pageOffsetRows rows fetch next @pageLimitRows rows only
	END

	IF @column=N'count_clarified' --5
	BEGIN
		SELECT [Assignments].Id, [Questions].[registration_number], [Assignments].registration_date, [QuestionTypes].name questionType, 
		[Applicants].full_name applicant, [Objects].name [place_problem], [Questions].control_date,

		-- (SELECT TOP 1 ISNULL([Districts].name+N' р-н, ',N' ')+ISNULL([StreetTypes].shortname+N' ', N'')+ ISNULL([Streets].name, N'')+ISNULL(N', '+[Buildings].name, N'')+ISNULL(N', кв '+[LiveAddress].flat,N'')
		-- FROM [dbo].[LiveAddress] 
		--  LEFT JOIN [dbo].[Buildings] ON [LiveAddress].building_id=[Buildings].Id
		--  LEFT JOIN [dbo].[Districts] ON [Buildings].district_id=[Districts].Id
		--  LEFT JOIN [dbo].[Streets] ON [Buildings].street_id=[Streets].Id
		--  LEFT JOIN [dbo].[StreetTypes] ON [Streets].street_type_id=[StreetTypes].Id
		--  WHERE [LiveAddress].applicant_id=[Applicants].Id) applicantAdress,
		 [Applicants].ApplicantAdress applicantAdress, [Questions].question_content content,

		 (SELECT TOP 1 [Organizations].short_name FROM [dbo].[ExecutorInRoleForObject]
		 INNER JOIN [dbo].[Organizations] ON [ExecutorInRoleForObject].executor_id=[Organizations].Id
		 WHERE [executor_role_id]=1 AND [ExecutorInRoleForObject].object_id=[Questions].object_id) balancer
		 ,[Organizations].short_name executor
		FROM [dbo].[QuestionsInTerritory]
	    INNER JOIN [dbo].[Questions] ON [QuestionsInTerritory].question_id=[Questions].Id
	    INNER JOIN [dbo].[Assignments] ON [Questions].Id=[Assignments].question_id
		LEFT JOIN [dbo].[Organizations] ON [Assignments].executor_organization_id=[Organizations].Id
		--INNER JOIN @person_executor_choose_table p_tab ON [Assignments].[executor_person_id]=p_tab.Id
		--INNER JOIN @sector_org_table st ON [Assignments].executor_organization_id=st.organization_id
		INNER JOIN [dbo].[Appeals] ON [Questions].appeal_id=[Appeals].Id
		LEFT JOIN [dbo].[Applicants] ON [Appeals].applicant_id=[Applicants].Id
		LEFT JOIN [dbo].[QuestionTypes] ON [Questions].question_type_id=[QuestionTypes].Id
		LEFT JOIN [dbo].[Objects] ON [Questions].object_id=[Objects].Id
		WHERE [QuestionsInTerritory].territory_id =@sector_id AND [Assignments].assignment_state_id=3 /*на перевірці*/ AND [Assignments].AssignmentResultsId=7 /*роз.яснено*/
		
		AND #filter_columns#
		--#sort_columns#
		ORDER BY 1
		offset @pageOffsetRows rows fetch next @pageLimitRows rows only
	END


	IF @column=N'count_done' --6
	BEGIN
		SELECT [Assignments].Id, [Questions].[registration_number], [Assignments].registration_date, [QuestionTypes].name questionType, 
		[Applicants].full_name applicant, [Objects].name [place_problem], [Questions].control_date,

		-- (SELECT TOP 1 ISNULL([Districts].name+N' р-н, ',N' ')+ISNULL([StreetTypes].shortname+N' ', N'')+ ISNULL([Streets].name, N'')+ISNULL(N', '+[Buildings].name, N'')+ISNULL(N', кв '+[LiveAddress].flat,N'')
		-- FROM [dbo].[LiveAddress] 
		--  LEFT JOIN [dbo].[Buildings] ON [LiveAddress].building_id=[Buildings].Id
		--  LEFT JOIN [dbo].[Districts] ON [Buildings].district_id=[Districts].Id
		--  LEFT JOIN [dbo].[Streets] ON [Buildings].street_id=[Streets].Id
		--  LEFT JOIN [dbo].[StreetTypes] ON [Streets].street_type_id=[StreetTypes].Id
		--  WHERE [LiveAddress].applicant_id=[Applicants].Id) applicantAdress,
		 [Applicants].ApplicantAdress applicantAdress, [Questions].question_content content,

		 (SELECT TOP 1 [Organizations].short_name FROM [dbo].[ExecutorInRoleForObject]
		 INNER JOIN [dbo].[Organizations] ON [ExecutorInRoleForObject].executor_id=[Organizations].Id
		 WHERE [executor_role_id]=1 AND [ExecutorInRoleForObject].object_id=[Questions].object_id) balancer
		 ,[Organizations].short_name executor
		FROM [dbo].[QuestionsInTerritory]
	    INNER JOIN [dbo].[Questions] ON [QuestionsInTerritory].question_id=[Questions].Id
	    INNER JOIN [dbo].[Assignments] ON [Questions].Id=[Assignments].question_id
		LEFT JOIN [dbo].[Organizations] ON [Assignments].executor_organization_id=[Organizations].Id
		--INNER JOIN @person_executor_choose_table p_tab ON [Assignments].[executor_person_id]=p_tab.Id
		--INNER JOIN @sector_org_table st ON [Assignments].executor_organization_id=st.organization_id
		INNER JOIN [dbo].[Appeals] ON [Questions].appeal_id=[Appeals].Id
		LEFT JOIN [dbo].[Applicants] ON [Appeals].applicant_id=[Applicants].Id
		LEFT JOIN [dbo].[QuestionTypes] ON [Questions].question_type_id=[QuestionTypes].Id
		LEFT JOIN [dbo].[Objects] ON [Questions].object_id=[Objects].Id
		WHERE [QuestionsInTerritory].territory_id =@sector_id AND [Assignments].assignment_state_id=3 /*на перевірці*/ AND [Assignments].AssignmentResultsId=4 /*виконано*/
		
		AND #filter_columns#
		--#sort_columns#
		ORDER BY 1
		offset @pageOffsetRows rows fetch next @pageLimitRows rows only
	END

	IF @column=N'count_for_revision' --7
	BEGIN
		SELECT [Assignments].Id, [Questions].[registration_number], [Assignments].registration_date, [QuestionTypes].name questionType, 
		[Applicants].full_name applicant, [Objects].name [place_problem], [Questions].control_date,

		-- (SELECT TOP 1 ISNULL([Districts].name+N' р-н, ',N' ')+ISNULL([StreetTypes].shortname+N' ', N'')+ ISNULL([Streets].name, N'')+ISNULL(N', '+[Buildings].name, N'')+ISNULL(N', кв '+[LiveAddress].flat,N'')
		-- FROM [dbo].[LiveAddress] 
		--  LEFT JOIN [dbo].[Buildings] ON [LiveAddress].building_id=[Buildings].Id
		--  LEFT JOIN [dbo].[Districts] ON [Buildings].district_id=[Districts].Id
		--  LEFT JOIN [dbo].[Streets] ON [Buildings].street_id=[Streets].Id
		--  LEFT JOIN [dbo].[StreetTypes] ON [Streets].street_type_id=[StreetTypes].Id
		--  WHERE [LiveAddress].applicant_id=[Applicants].Id) applicantAdress,
		 [Applicants].ApplicantAdress applicantAdress, [Questions].question_content content,

		 (SELECT TOP 1 [Organizations].short_name FROM [dbo].[ExecutorInRoleForObject]
		 INNER JOIN [dbo].[Organizations] ON [ExecutorInRoleForObject].executor_id=[Organizations].Id
		 WHERE [executor_role_id]=1 AND [ExecutorInRoleForObject].object_id=[Questions].object_id) balancer
		 ,[Organizations].short_name executor
		FROM [dbo].[QuestionsInTerritory]
	    INNER JOIN [dbo].[Questions] ON [QuestionsInTerritory].question_id=[Questions].Id
	    INNER JOIN [dbo].[Assignments] ON [Questions].Id=[Assignments].question_id
		LEFT JOIN [dbo].[Organizations] ON [Assignments].executor_organization_id=[Organizations].Id
		--INNER JOIN @person_executor_choose_table p_tab ON [Assignments].[executor_person_id]=p_tab.Id
		--INNER JOIN @sector_org_table st ON [Assignments].executor_organization_id=st.organization_id
		INNER JOIN [dbo].[Appeals] ON [Questions].appeal_id=[Appeals].Id
		LEFT JOIN [dbo].[Applicants] ON [Appeals].applicant_id=[Applicants].Id
		LEFT JOIN [dbo].[QuestionTypes] ON [Questions].question_type_id=[QuestionTypes].Id
		LEFT JOIN [dbo].[Objects] ON [Questions].object_id=[Objects].Id
		WHERE [QuestionsInTerritory].territory_id =@sector_id AND [Assignments].assignment_state_id=4 /*не виконано*/ AND [Assignments].AssignmentResultsId=5 /*на доопрацюванні*/
		
		AND #filter_columns#
		--#sort_columns#
		ORDER BY 1
		offset @pageOffsetRows rows fetch next @pageLimitRows rows only
	END

	IF @column=N'count_plan_program' --8
	BEGIN
		SELECT [Assignments].Id, [Questions].[registration_number], [Assignments].registration_date, [QuestionTypes].name questionType, 
		[Applicants].full_name applicant, [Objects].name [place_problem], [Questions].control_date,

		-- (SELECT TOP 1 ISNULL([Districts].name+N' р-н, ',N' ')+ISNULL([StreetTypes].shortname+N' ', N'')+ ISNULL([Streets].name, N'')+ISNULL(N', '+[Buildings].name, N'')+ISNULL(N', кв '+[LiveAddress].flat,N'')
		-- FROM [dbo].[LiveAddress] 
		--  LEFT JOIN [dbo].[Buildings] ON [LiveAddress].building_id=[Buildings].Id
		--  LEFT JOIN [dbo].[Districts] ON [Buildings].district_id=[Districts].Id
		--  LEFT JOIN [dbo].[Streets] ON [Buildings].street_id=[Streets].Id
		--  LEFT JOIN [dbo].[StreetTypes] ON [Streets].street_type_id=[StreetTypes].Id
		--  WHERE [LiveAddress].applicant_id=[Applicants].Id) applicantAdress,
		 [Applicants].ApplicantAdress applicantAdress, [Questions].question_content content,

		 (SELECT TOP 1 [Organizations].short_name FROM [dbo].[ExecutorInRoleForObject]
		 INNER JOIN [dbo].[Organizations] ON [ExecutorInRoleForObject].executor_id=[Organizations].Id
		 WHERE [executor_role_id]=1 AND [ExecutorInRoleForObject].object_id=[Questions].object_id) balancer
		 ,[Organizations].short_name executor
		FROM [dbo].[QuestionsInTerritory]
	    INNER JOIN [dbo].[Questions] ON [QuestionsInTerritory].question_id=[Questions].Id
	    INNER JOIN [dbo].[Assignments] ON [Questions].Id=[Assignments].question_id
		--INNER JOIN @sector_org_table st ON [Assignments].executor_organization_id=st.organization_id
		--INNER JOIN @person_executor_choose_table p_tab ON [Assignments].[executor_person_id]=p_tab.Id
		LEFT JOIN [dbo].[Organizations] ON [Assignments].executor_organization_id=[Organizations].Id
		--
		INNER JOIN (SELECT [Assignment_History].assignment_id, [Assignment_History].assignment_state_id last_state_id
				  FROM [dbo].[Assignment_History]
				  INNER JOIN 
				  (
				  SELECT [Assignment_History].assignment_id, MAX([Assignment_History].Id) Id_state
				  FROM [dbo].[Assignments]
				  INNER JOIN [dbo].[Assignment_History] ON [Assignments].Id=[Assignment_History].assignment_id
				  AND [Assignments].assignment_state_id<>[Assignment_History].assignment_state_id
				  WHERE [Assignments].assignment_state_id=5 AND [Assignments].AssignmentResultsId=7
				  GROUP BY [Assignment_History].assignment_id) tab_last_state ON [Assignment_History].Id=tab_last_state.Id_state) last_state_tab ON [Assignments].Id=last_state_tab.assignment_id

				  INNER JOIN (SELECT [Assignment_History].assignment_id, [Assignment_History].AssignmentResultsId last_result_id
				  FROM [dbo].[Assignment_History]
				  INNER JOIN 
				  (
				  SELECT [Assignment_History].assignment_id, MAX([Assignment_History].Id) Id_result
				  FROM [dbo].[Assignments]
				  INNER JOIN [dbo].[Assignment_History] ON [Assignments].Id=[Assignment_History].assignment_id
				  AND [Assignments].AssignmentResultsId<>[Assignment_History].AssignmentResultsId
				  WHERE [Assignments].assignment_state_id=5 AND [Assignments].AssignmentResultsId=7
				  GROUP BY [Assignment_History].assignment_id) tab_last_result ON [Assignment_History].Id=tab_last_result.Id_result) last_result_tab ON [Assignments].Id=last_result_tab.assignment_id
		--

		INNER JOIN [dbo].[Appeals] ON [Questions].appeal_id=[Appeals].Id
		LEFT JOIN [dbo].[Applicants] ON [Appeals].applicant_id=[Applicants].Id
		LEFT JOIN [dbo].[QuestionTypes] ON [Questions].question_type_id=[QuestionTypes].Id
		LEFT JOIN [dbo].[Objects] ON [Questions].object_id=[Objects].Id

		WHERE [QuestionsInTerritory].territory_id =@sector_id AND [Assignments].assignment_state_id=5 /*закрито*/ AND [Assignments].AssignmentResultsId=7 /*роз.яснено*/ 
				AND last_state_tab.last_state_id=3/*на перевірці*/ AND last_result_tab.last_result_id=8 /*неможливо виконати в даний період*/
		
		AND #filter_columns#
		--#sort_columns#
		ORDER BY 1
		offset @pageOffsetRows rows fetch next @pageLimitRows rows only
	END