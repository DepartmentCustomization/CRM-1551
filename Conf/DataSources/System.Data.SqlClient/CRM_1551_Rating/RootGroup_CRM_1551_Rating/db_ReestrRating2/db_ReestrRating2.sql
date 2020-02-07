--declare @RatingId int = 1, @CalcDate date = N'2019-10-16', @RDAId int = 2007,  @ColumnCode nvarchar(100) = N'ViewedByArtist_WrongTime'


if @ColumnCode = N'PreviousPeriod_Total'
begin
--1. [Реєстр - Попередній період - Всього]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - Попередній період - Всього] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - Попередній період - Всього]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'PreviousPeriod_Registered'
begin
--2. [Реєстр - Попередній період - Зареєстровано]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - Попередній період - Зареєстровано] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - Попередній період - Зареєстровано]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'PreviousPeriod_InTheWorks'
begin
--3. [Реєстр - Попередній період - В роботі]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - Попередній період - В роботі] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - Попередній період - В роботі]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'PreviousPeriod_InTest'
begin
--4. [Реєстр - Попередній період - На перевірці]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - Попередній період - На перевірці] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - Попередній період - На перевірці]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'PreviousPeriod_ForRevision'
begin
--5. [Реєстр - Попередній період - На доопрацюванні]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - Попередній період - На доопрацюванні] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - Попередній період - На доопрацюванні]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'PreviousPeriod_Closed'
begin
--6. [Реєстр - Попередній період - Закрито]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - Попередній період - Закрито] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - Попередній період - Закрито]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'CurrentMonth_Total'
begin
--7. [Реєстр - Поточний місяць - Загальна кількість]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - Поточний місяць - Загальна кількість] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - Поточний місяць - Загальна кількість]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'CurrentMonth_Registered'
begin
--8. [Реєстр - Поточний місяць - Загальна кількість]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - Поточний місяць - Зареєстровано] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - Поточний місяць - Зареєстровано]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'CurrentMonth_InTheWorks'
begin
--9. [Реєстр - Поточний місяць - В роботі]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - Поточний місяць - В роботі] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - Поточний місяць - В роботі]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'CurrentMonth_InTest'
begin
--10. [Реєстр - Поточний місяць - На перевірці]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - Поточний місяць - На перевірці] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - Поточний місяць - На перевірці]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'CurrentMonth_ForRevision'
begin
--11. [Реєстр - Поточний місяць - На доопрацюванні]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - Поточний місяць - На доопрацюванні] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - Поточний місяць - На доопрацюванні]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'CurrentMonth_Closed'
begin
--12. [Реєстр - Поточний місяць - Закрито]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - Поточний місяць - Закрито] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - Поточний місяць - Закрито]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'OfThem_Registered'
begin
--13. [Реєстр - з них, Зареєстровано]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - з них, Зареєстровано] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - з них, Зареєстровано]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'OfThem_AtWork'
begin
--14. [Реєстр - з них, В роботі]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - з них, В роботі] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - з них, В роботі]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'OnTest_Done'
begin
--15. [Реєстр - На перевірці - Виконано]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - На перевірці - Виконано] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - На перевірці - Виконано]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'OnTest_Explained'
begin
--16. [Реєстр - На перевірці - Роз`яснено]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - На перевірці - Роз`яснено] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - На перевірці - Роз`яснено]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'OnTest_CannotBeExecutedAtThisTime'
begin
--17. [Реєстр - На перевірці - Не можливо виконанти в даний період]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - На перевірці - Не можливо виконанти в даний період] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - На перевірці - Не можливо виконанти в даний період]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'ResultOfExecution_Done'
begin
--18. [Реєстр - Результат виконання - Виконано]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - Результат виконання - Виконано] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - Результат виконання - Виконано]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'ResultOfExecution_Explained'
begin
--19. [Реєстр - Результат виконання - Роз`яснено]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - Результат виконання - Роз`яснено] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - Результат виконання - Роз`яснено]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'ResultOfExecution_Others'
begin
--20. [Реєстр - Результат виконання - Інші]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - Результат виконання - Інші] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - Результат виконання - Інші]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'ForRevision_All'
begin
--21. [Реєстр - На доопрацювання (Всього)]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - На доопрацювання (Всього) інфо] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - На доопрацювання (Всього) інфо]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'ForRevision_Total'
begin
--22. [Реєстр - На доопрацювання (Прозвон)]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - На доопрацювання (Прозвон) інфо] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - На доопрацювання (Прозвон) інфо]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'ForRevision_1Time'
begin
--23. [Реєстр - На доопрацювання (Прозвон) - 1 раз]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - На доопрацювання (Прозвон) - 1 раз інфо] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - На доопрацювання (Прозвон) - 1 раз інфо]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'ForRevision_2Times'
begin
--24. [Реєстр - На доопрацювання (Прозвон) - 2 рази]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - На доопрацювання (Прозвон) - 2 рази інфо] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - На доопрацювання (Прозвон) - 2 рази інфо]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'ForRevision_3AndMore'
begin
--25. [Реєстр - На доопрацювання (Прозвон) - 3 і більше]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - На доопрацювання (Прозвон) - 3 і більше інфо] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - На доопрацювання (Прозвон) - 3 і більше інфо]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'ViewedByArtist_Total'
begin
--26. [Реєстр - Розглянуті виконавцем - Всі]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - Розглянуті виконавцем - Всі] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - Розглянуті виконавцем - Всі]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end

if @ColumnCode = N'ViewedByArtist_WrongTime'
begin
--27. [Реєстр - Розглянуті виконавцем - Не вчасно]
  SELECT [Appeals].[registration_number] as [Номер звернення],
		 [Questions].[registration_number] as [Номер питання],
		 [QuestionTypes].[name] as [Тип питання],
		 [Organizations].[short_name] as [Виконавець],
		 t1.[AssignmentRegistrationDate] as [Дата реєстрації доручення],
		 [AssignmentStates].[name] as [Стан доручення],
		 [AssignmentResults].[name] as [Результат розгляду доручення],
		 [AssignmentResolutions].[name] as [Резолюція доручення],
		 t1.[AssignmentRegistrationDate] as [Дата контролю доручення],
		 [Rating].[name] as [Тип рейтингу],
		 [org_RDA].[short_name] as [Назва РДА]
  FROM [dbo].[Реєстр - Розглянуті виконавцем - Не вчасно] as t1
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = t1.[AppealId]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = t1.[QuestionId]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = t1.[QuestionTypeId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = t1.[AssignmentExecutorOrganizationId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [AssignmentStates].[Id] = t1.[AssignmentStateId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentResults].[Id] = t1.[AssignmentResultsId]
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentResolutions].[Id] = t1.[AssignmentResolutionsId]
  left join [CRM_1551_Analitics].[dbo].[Rating] on [Rating].[Id] = t1.[RatingId]
  left join [CRM_1551_Analitics].[dbo].[Organizations] as [org_RDA] on [org_RDA].[Id] = t1.[RDAId]
  where t1.[Id] in (
			SELECT max(Id)
			FROM [dbo].[Реєстр - Розглянуті виконавцем - Не вчасно]
			where [StateToDate] = @CalcDate
			and [RatingId] = @RatingId
			and [RDAId] = @RDAId
			group by AssignmentId
				)
end