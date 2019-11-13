SELECT  [Events].[Id],
		[Events].[Id] as [Номер Заходу],
		[EventTypes].name as [Тип Заходу],
-- 		[Events].[name] as [Назва Заходу],
		[Organizations].short_name as [Відповідальний за усунення],
		[Events].[comment] as [Зміст],
		[Events].[start_date] as [Дата початку],
		[Events].[plan_end_date] as [Планова дата завершення],
		[EventTypes].Id as [EventTypesId]
  FROM [dbo].[EventObjects]
  left join [dbo].[Events] on [Events].Id = [EventObjects].[event_id]
  left join [dbo].[EventTypes] on [EventTypes].Id = [Events].[event_type_id]
  left join [dbo].EventQuestionsTypes as eqt on eqt.event_id = [Events].Id
  left join [dbo].[QuestionTypes] on [QuestionTypes].Id = eqt.question_type_id
  left join [dbo].[EventOrganizers] on [EventOrganizers].event_id = [Events].Id
  left join [dbo].[Organizations] on [Organizations].Id = [EventOrganizers].organization_id
  where [EventObjects].[object_id] = @object_id
 and #filter_columns#
    #sort_columns#
offset @pageOffsetRows rows fetch next @pageLimitRows rows only