
-- declare @applicant_id int = 1490872
-- declare @type nvarchar(100) = N'В роботі'

if @type = N'Усі'
begin
	select [Lokal_copy_gorodok_claims].claim_number as [Номер питання], 
           [QuestionStates].[name] as [Стан питання], 
           [Lokal_copy_gorodok_claims].claims_type as [Тип питання], 
           [Lokal_copy_gorodok_claims].executor as [Виконавець],
           [Lokal_copy_gorodok_claims].plan_finish_date as [Планова дата виконання],
		   [Lokal_copy_gorodok_claims].Id
	FROM [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses]
	  left join[CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_claims] on [Lokal_copy_gorodok_claims].[object_id] =  [Gorodok_1551_houses].gorodok_houses_id
	  left join [CRM_1551_GORODOK_Integrartion].[dbo].Claims_states on Claims_states.[name] = [Lokal_copy_gorodok_claims].[status]
	  left join [dbo].[QuestionStates] on [QuestionStates].Id = Claims_states.[1551_state]
	where [Gorodok_1551_houses].[1551_houses_id] in (select [LiveAddress].building_id from [dbo].[LiveAddress] where building_id is not null and [LiveAddress].applicant_id = @applicant_id)
end

if @type = N'Зареєстровано'
begin
select [Lokal_copy_gorodok_claims].claim_number as [Номер питання], 
           [QuestionStates].[name] as [Стан питання], 
           [Lokal_copy_gorodok_claims].claims_type as [Тип питання], 
           [Lokal_copy_gorodok_claims].executor as [Виконавець],
           [Lokal_copy_gorodok_claims].plan_finish_date as [Планова дата виконання],
		   [Lokal_copy_gorodok_claims].Id
	FROM [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses]
	  left join[CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_claims] on [Lokal_copy_gorodok_claims].[object_id] =  [Gorodok_1551_houses].gorodok_houses_id
	  left join [CRM_1551_GORODOK_Integrartion].[dbo].Claims_states on Claims_states.[name] = [Lokal_copy_gorodok_claims].[status]
	  left join [dbo].[QuestionStates] on [QuestionStates].Id = Claims_states.[1551_state]
	where [Gorodok_1551_houses].[1551_houses_id] in (select [LiveAddress].building_id from [dbo].[LiveAddress] where building_id is not null and [LiveAddress].applicant_id = @applicant_id)
	and Claims_states.[1551_state] in (select [QuestionStates].Id from [QuestionStates] where [QuestionStates].[name] in (N'Зареєстровано'))
end


if @type = N'В роботі'
begin
select [Lokal_copy_gorodok_claims].claim_number as [Номер питання], 
           [QuestionStates].[name] as [Стан питання], 
           [Lokal_copy_gorodok_claims].claims_type as [Тип питання], 
           [Lokal_copy_gorodok_claims].executor as [Виконавець],
           [Lokal_copy_gorodok_claims].plan_finish_date as [Планова дата виконання],
		   [Lokal_copy_gorodok_claims].Id
	FROM [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses]
	  left join[CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_claims] on [Lokal_copy_gorodok_claims].[object_id] =  [Gorodok_1551_houses].gorodok_houses_id
	  left join [CRM_1551_GORODOK_Integrartion].[dbo].Claims_states on Claims_states.[name] = [Lokal_copy_gorodok_claims].[status]
	  left join [dbo].[QuestionStates] on [QuestionStates].Id = Claims_states.[1551_state]
	where [Gorodok_1551_houses].[1551_houses_id] in (select [LiveAddress].building_id from [dbo].[LiveAddress] where building_id is not null and [LiveAddress].applicant_id = @applicant_id)
	and Claims_states.[1551_state] in (select [QuestionStates].Id from [QuestionStates] where [QuestionStates].[name] in (N'В роботі', N'На перевірці'))
end

if @type = N'Просрочено'
begin
select [Lokal_copy_gorodok_claims].claim_number as [Номер питання], 
           [QuestionStates].[name] as [Стан питання], 
           [Lokal_copy_gorodok_claims].claims_type as [Тип питання], 
           [Lokal_copy_gorodok_claims].executor as [Виконавець],
           [Lokal_copy_gorodok_claims].plan_finish_date as [Планова дата виконання],
		   [Lokal_copy_gorodok_claims].Id
	FROM [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses]
	  left join[CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_claims] on [Lokal_copy_gorodok_claims].[object_id] =  [Gorodok_1551_houses].gorodok_houses_id
	  left join [CRM_1551_GORODOK_Integrartion].[dbo].Claims_states on Claims_states.[name] = [Lokal_copy_gorodok_claims].[status]
	  left join [dbo].[QuestionStates] on [QuestionStates].Id = Claims_states.[1551_state]
	where [Gorodok_1551_houses].[1551_houses_id] in (select [LiveAddress].building_id from [dbo].[LiveAddress] where building_id is not null and [LiveAddress].applicant_id = @applicant_id)
	and Claims_states.[1551_state] in (select [QuestionStates].Id from [QuestionStates] where [QuestionStates].[name]  not in (N'Закрито'))
	and [Lokal_copy_gorodok_claims].[plan_finish_date] <= getutcdate()
end

if @type = N'Виконано'
begin
select [Lokal_copy_gorodok_claims].claim_number as [Номер питання], 
           [QuestionStates].[name] as [Стан питання], 
           [Lokal_copy_gorodok_claims].claims_type as [Тип питання], 
           [Lokal_copy_gorodok_claims].executor as [Виконавець],
           [Lokal_copy_gorodok_claims].plan_finish_date as [Планова дата виконання],
		   [Lokal_copy_gorodok_claims].Id
	FROM [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses]
	  left join[CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_claims] on [Lokal_copy_gorodok_claims].[object_id] =  [Gorodok_1551_houses].gorodok_houses_id
	  left join [CRM_1551_GORODOK_Integrartion].[dbo].Claims_states on Claims_states.[name] = [Lokal_copy_gorodok_claims].[status]
	  left join [dbo].[QuestionStates] on [QuestionStates].Id = Claims_states.[1551_state]
	where [Gorodok_1551_houses].[1551_houses_id] in (select [LiveAddress].building_id from [dbo].[LiveAddress] where building_id is not null and [LiveAddress].applicant_id = @applicant_id)
	and Claims_states.[1551_state] in (select [QuestionStates].Id from [QuestionStates] where [QuestionStates].[name] in (N'Закрито'))
end

--and #filter_columns#
--     #sort_columns#
--offset @pageOffsetRows rows fetch next @pageLimitRows rows only

