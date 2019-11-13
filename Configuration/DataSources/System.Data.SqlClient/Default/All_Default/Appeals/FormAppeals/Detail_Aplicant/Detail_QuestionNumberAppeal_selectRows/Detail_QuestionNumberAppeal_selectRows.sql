SELECT [Questions].[Id],
       [Questions].[registration_number] as [Номер питання],
	   [QuestionStates].[name] as [Стан питання],
	   [QuestionTypes].[name] as [Тип питання],
	   [Organizations].[name] as [Виконавець],
	   [Questions].registration_date as [Дата та час реєстрації питання],
	   [Questions].control_date as [Дата контролю]
  FROM [dbo].[Questions]
  left join [dbo].[QuestionTypes] on [QuestionTypes].Id = [Questions].question_type_id
  left join [dbo].[Objects] on [Objects].Id = [Questions].[object_id]
  left join [dbo].[Buildings] on [Buildings].Id = [Objects].[builbing_id]
   left join [dbo].[Streets] on [Streets].Id = [Buildings].street_id
  left join [dbo].[StreetTypes] on [StreetTypes].Id = [Streets].street_type_id
  left join [dbo].[Districts] on [Districts].Id = [Streets].district_id
  left join [dbo].[QuestionStates] on [QuestionStates].Id = [Questions].question_state_id
  left join [dbo].[Assignments] on [Assignments].Id = [Questions].last_assignment_for_execution_id
    left join [dbo].[AssignmentResults] on [AssignmentResults].Id = [Assignments].AssignmentResultsId
    left join [dbo].[Organizations]  on [Organizations].Id = [Assignments].executor_organization_id
  left join [dbo].[Appeals] on [Appeals].Id = [Questions].appeal_id
  where [Appeals].[registration_number] = @AppealRegistrationNumber
--and #filter_columns#
--     #sort_columns#
--offset @pageOffsetRows rows fetch next @pageLimitRows rows only
