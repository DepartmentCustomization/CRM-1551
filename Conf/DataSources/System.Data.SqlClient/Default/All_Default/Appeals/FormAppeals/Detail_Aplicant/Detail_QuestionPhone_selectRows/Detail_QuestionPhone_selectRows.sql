
-- declare @phone_number nvarchar(100) = N'(044)2356767'
-- declare @type nvarchar(100) = N'Зареєстровано'
	
if @type = N'Усі'
begin
	select 
	[Questions].[Id],
	[Questions].[registration_number] as [Номер питання],
	[ReceiptSources].name as [Джерело],
	[QuestionStates].[name] as [Стан питання],
	[QuestionTypes].[name] as [Тип питання],
	[Organizations].[name] as [Виконавець],
	[Questions].registration_date as [Дата та час реєстрації питання],
	[Questions].control_date as [Дата контролю]
	FROM [dbo].[Questions]
	left join [dbo].[Appeals] on [Appeals].Id = [Questions].appeal_id
	left join [dbo].[Applicants] on [Applicants].Id = [Appeals].applicant_id
	left join [dbo].[QuestionStates] on [QuestionStates].Id = [Questions].question_state_id
	left join [dbo].[QuestionTypes] on [QuestionTypes].Id = [Questions].question_type_id
	left join [dbo].[LiveAddress] on [LiveAddress].applicant_id = [Applicants].Id
	left join [dbo].[Assignments] on [Assignments].Id = [Questions].last_assignment_for_execution_id
    left join [dbo].[AssignmentResults] on [AssignmentResults].Id = [Assignments].AssignmentResultsId
    left join [dbo].[Organizations]  on [Organizations].Id = [Assignments].executor_organization_id
	left join [dbo].[ReceiptSources] on [ReceiptSources].Id = [Appeals].receipt_source_id

	where [Appeals].phone_number in (select [ApplicantPhones].phone_number from [dbo].[ApplicantPhones] where [ApplicantPhones].phone_number = @phone_number)
	order by [Questions].registration_date desc
end

if @type = N'Зареєстровано'
begin
	select 
	[Questions].[Id],
	[Questions].[registration_number] as [Номер питання],
	[ReceiptSources].name as [Джерело],
	[QuestionStates].[name] as [Стан питання],
	[QuestionTypes].[name] as [Тип питання],
	[Organizations].[name] as [Виконавець],
	[Questions].registration_date as [Дата та час реєстрації питання],
	[Questions].control_date as [Дата контролю]
	FROM [dbo].[Questions]
	left join [dbo].[Appeals] on [Appeals].Id = [Questions].appeal_id
	left join [dbo].[Applicants] on [Applicants].Id = [Appeals].applicant_id
	left join [dbo].[QuestionStates] on [QuestionStates].Id = [Questions].question_state_id
	left join [dbo].[QuestionTypes] on [QuestionTypes].Id = [Questions].question_type_id
	left join [dbo].[LiveAddress] on [LiveAddress].applicant_id = [Applicants].Id
	left join [dbo].[Assignments] on [Assignments].Id = [Questions].last_assignment_for_execution_id
    left join [dbo].[AssignmentResults] on [AssignmentResults].Id = [Assignments].AssignmentResultsId
    left join [dbo].[Organizations]  on [Organizations].Id = [Assignments].executor_organization_id
	left join [dbo].[ReceiptSources] on [ReceiptSources].Id = [Appeals].receipt_source_id

	where [Appeals].phone_number in (select [ApplicantPhones].phone_number from [dbo].[ApplicantPhones] where [ApplicantPhones].phone_number = @phone_number)
	and [QuestionStates].[name] in (N'Зареєстровано')
		order by [Questions].registration_date desc
end


if @type = N'В роботі'
begin
	select 
	[Questions].[Id],
	[Questions].[registration_number] as [Номер питання],
	[ReceiptSources].name as [Джерело],
	[QuestionStates].[name] as [Стан питання],
	[QuestionTypes].[name] as [Тип питання],
	[Organizations].[name] as [Виконавець],
	[Questions].registration_date as [Дата та час реєстрації питання],
	[Questions].control_date as [Дата контролю]
	FROM [dbo].[Questions]
	left join [dbo].[Appeals] on [Appeals].Id = [Questions].appeal_id
	left join [dbo].[Applicants] on [Applicants].Id = [Appeals].applicant_id
	left join [dbo].[QuestionStates] on [QuestionStates].Id = [Questions].question_state_id
	left join [dbo].[QuestionTypes] on [QuestionTypes].Id = [Questions].question_type_id
	left join [dbo].[LiveAddress] on [LiveAddress].applicant_id = [Applicants].Id
	left join [dbo].[Assignments] on [Assignments].Id = [Questions].last_assignment_for_execution_id
    left join [dbo].[AssignmentResults] on [AssignmentResults].Id = [Assignments].AssignmentResultsId
    left join [dbo].[Organizations]  on [Organizations].Id = [Assignments].executor_organization_id
	left join [dbo].[ReceiptSources] on [ReceiptSources].Id = [Appeals].receipt_source_id

	where [Appeals].phone_number in (select [ApplicantPhones].phone_number from [dbo].[ApplicantPhones] where [ApplicantPhones].phone_number = @phone_number)
	and [QuestionStates].[name] in (N'В роботі', N'На перевірці')
		order by [Questions].registration_date desc
end

if @type = N'Просрочено'
begin
	select 
	[Questions].[Id],
	[Questions].[registration_number] as [Номер питання],
	[ReceiptSources].name as [Джерело],
	[QuestionStates].[name] as [Стан питання],
	[QuestionTypes].[name] as [Тип питання],
	[Organizations].[name] as [Виконавець],
	[Questions].registration_date as [Дата та час реєстрації питання],
	[Questions].control_date as [Дата контролю]
	FROM [dbo].[Questions]
	left join [dbo].[Appeals] on [Appeals].Id = [Questions].appeal_id
	left join [dbo].[Applicants] on [Applicants].Id = [Appeals].applicant_id
	left join [dbo].[QuestionStates] on [QuestionStates].Id = [Questions].question_state_id
	left join [dbo].[QuestionTypes] on [QuestionTypes].Id = [Questions].question_type_id
	left join [dbo].[LiveAddress] on [LiveAddress].applicant_id = [Applicants].Id
	left join [dbo].[Assignments] on [Assignments].Id = [Questions].last_assignment_for_execution_id
    left join [dbo].[AssignmentResults] on [AssignmentResults].Id = [Assignments].AssignmentResultsId
    left join [dbo].[Organizations]  on [Organizations].Id = [Assignments].executor_organization_id
	left join [dbo].[ReceiptSources] on [ReceiptSources].Id = [Appeals].receipt_source_id

	where [Appeals].phone_number in (select [ApplicantPhones].phone_number from [dbo].[ApplicantPhones] where [ApplicantPhones].phone_number = @phone_number)
	and [Questions].[control_date] <= getutcdate()
	and [QuestionStates].[name] not in (N'Закрито')
		order by [Questions].registration_date desc
end

if @type = N'Виконано'
begin
	select 
	[Questions].[Id],
	[Questions].[registration_number] as [Номер питання],
	[ReceiptSources].name as [Джерело],
	[QuestionStates].[name] as [Стан питання],
	[QuestionTypes].[name] as [Тип питання],
	[Organizations].[name] as [Виконавець],
	[Questions].registration_date as [Дата та час реєстрації питання],
	[Questions].control_date as [Дата контролю]
	FROM [dbo].[Questions]
	left join [dbo].[Appeals] on [Appeals].Id = [Questions].appeal_id
	left join [dbo].[Applicants] on [Applicants].Id = [Appeals].applicant_id
	left join [dbo].[QuestionStates] on [QuestionStates].Id = [Questions].question_state_id
	left join [dbo].[QuestionTypes] on [QuestionTypes].Id = [Questions].question_type_id
	left join [dbo].[LiveAddress] on [LiveAddress].applicant_id = [Applicants].Id
	left join [dbo].[Assignments] on [Assignments].Id = [Questions].last_assignment_for_execution_id
    left join [dbo].[AssignmentResults] on [AssignmentResults].Id = [Assignments].AssignmentResultsId
    left join [dbo].[Organizations]  on [Organizations].Id = [Assignments].executor_organization_id
	left join [dbo].[ReceiptSources] on [ReceiptSources].Id = [Appeals].receipt_source_id

	where [Appeals].phone_number in (select [ApplicantPhones].phone_number from [dbo].[ApplicantPhones] where [ApplicantPhones].phone_number = @phone_number)
	and [QuestionStates].[name] in (N'Закрито')
		order by [Questions].registration_date desc
end


if @type = N'Доопрацювання'
begin
	select 
	[Questions].[Id],
	[Questions].[registration_number] as [Номер питання],
	[ReceiptSources].name as [Джерело],
	[QuestionStates].[name] as [Стан питання],
	[QuestionTypes].[name] as [Тип питання],
	[Organizations].[name] as [Виконавець],
	[Questions].registration_date as [Дата та час реєстрації питання],
	[Questions].control_date as [Дата контролю]
	FROM [dbo].[Questions]
	left join [dbo].[Appeals] on [Appeals].Id = [Questions].appeal_id
	left join [dbo].[Applicants] on [Applicants].Id = [Appeals].applicant_id
	left join [dbo].[QuestionStates] on [QuestionStates].Id = [Questions].question_state_id
	left join [dbo].[QuestionTypes] on [QuestionTypes].Id = [Questions].question_type_id
	left join [dbo].[LiveAddress] on [LiveAddress].applicant_id = [Applicants].Id
	left join [dbo].[Assignments] on [Assignments].Id = [Questions].last_assignment_for_execution_id
    left join [dbo].[AssignmentResults] on [AssignmentResults].Id = [Assignments].AssignmentResultsId
    left join [dbo].[Organizations]  on [Organizations].Id = [Assignments].executor_organization_id
	left join [dbo].[ReceiptSources] on [ReceiptSources].Id = [Appeals].receipt_source_id

	where [Appeals].phone_number in (select [ApplicantPhones].phone_number from [dbo].[ApplicantPhones] where [ApplicantPhones].phone_number = @phone_number)
	and [QuestionStates].[name] in (N'Не виконано')
		order by [Questions].registration_date desc
end


--and #filter_columns#
--     #sort_columns#
--offset @pageOffsetRows rows fetch next @pageLimitRows rows only