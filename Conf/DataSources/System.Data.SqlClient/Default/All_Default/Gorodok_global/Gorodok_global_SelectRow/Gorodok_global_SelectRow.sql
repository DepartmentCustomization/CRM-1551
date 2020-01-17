SELECT [gg].claim_number AS [Id] -- № заходу +
	  , gg.claims_type AS event_type_name -- Тип заходу
	--   ,gg.claims_type as event_class_name -- Клас заходу +
	  , gg.object_name -- Об'єкт
	  , gg.executor AS executor_name -- Виконавець
	--   , gg.registration_date -- Дата початку
	  , CONVERT(datetime, CONVERT(datetimeoffset(4),gg.registration_date) AT TIME ZONE 'Pacific SA Standard Time') AS registration_date
	--   , gg.fact_finish_date AS real_end_date-- Факт.завершення
      ,gg.[executor_comment]
	  ,gg.[content]
	  ,qs.[name] AS [status]
    --   ,gg.plan_finish_date
      ,CONVERT(datetime, CONVERT(datetimeoffset(4),gg.plan_finish_date) AT TIME ZONE 'Pacific SA Standard Time') AS plan_finish_date
	  ,CONVERT(datetime, CONVERT(datetimeoffset(4),gg.fact_finish_date) AT TIME ZONE 'Pacific SA Standard Time') as real_end_date
FROM [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_global] AS gg
	JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Claims_states] cs ON cs.name = gg.[status]
	JOIN CRM_1551_Analitics.dbo.QuestionStates qs ON qs.Id = cs.[1551_state]

WHERE claim_number = @Id