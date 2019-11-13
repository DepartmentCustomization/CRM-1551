
--declare @applicant_id int = 24
--declare @type nvarchar(100) = N'Зареєстровано'


if @type = N'Усі'
begin
	select [Questions].[registration_number] as [Номер консультації],
	[ConsultationTypes].[name] as [Тип консультації],
	isnull(isnull([Consultations].[application_town_id],[Consultations].[event_id]),[Consultations].[knowledge_base_id]) as [Номер Заходу/заявки Городок/статті БЗ], 
    [Consultations].[registration_date] as [Дата та час реєстрації],
	[Questions].[Id]
	FROM [Consultations] 
	left join [dbo].[Questions] on [Consultations].question_id  = [Questions].Id
	left join [dbo].[Appeals] on [Appeals].Id = [Questions].appeal_id
	left join [dbo].[Applicants] on [Applicants].Id = [Appeals].applicant_id
	left join [dbo].[QuestionStates] on [QuestionStates].Id = [Questions].question_state_id
	left join [dbo].[QuestionTypes] on [QuestionTypes].Id = [Questions].question_type_id
	left join [dbo].[ConsultationTypes] on [ConsultationTypes].Id = [Consultations].consultation_type_id
	left join [dbo].[Events] on [Events].Id = [Consultations].event_id
	where [Consultations].appeal_id = @appeal_id and [Consultations].phone_number = @phone_number
	and #filter_columns#
	order by [Consultations].[registration_date] desc

end

if @type = N'Зареєстровано'
begin
	select [Questions].[registration_number] as [Номер консультації],
	[ConsultationTypes].[name] as [Тип консультації],
	isnull(isnull([Consultations].[application_town_id],[Consultations].[event_id]),[Consultations].[knowledge_base_id]) as [Номер Заходу/заявки Городок/статті БЗ], 
    [Consultations].[registration_date] as [Дата та час реєстрації],
	[Questions].[Id]
	FROM [Consultations] 
	left join [dbo].[Questions] on [Consultations].question_id  = [Questions].Id
	left join [dbo].[Appeals] on [Appeals].Id = [Questions].appeal_id
	left join [dbo].[Applicants] on [Applicants].Id = [Appeals].applicant_id
	left join [dbo].[QuestionStates] on [QuestionStates].Id = [Questions].question_state_id
	left join [dbo].[QuestionTypes] on [QuestionTypes].Id = [Questions].question_type_id
	left join [dbo].[ConsultationTypes] on [ConsultationTypes].Id = [Consultations].consultation_type_id
	left join [dbo].[Events] on [Events].Id = [Consultations].event_id
	where [Consultations].appeal_id = @appeal_id and [Consultations].phone_number = @phone_number
	and #filter_columns#
	order by [Consultations].[registration_date] desc
end



/*
and #filter_columns#
     #sort_columns#
offset @pageOffsetRows rows fetch next @pageLimitRows rows only
*/
