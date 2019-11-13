
SET nocount ON

SELECT [gg].claim_number as [Id] -- № заходу +
	  ,gg.claims_type as event_type_name -- Тип заходу
	--   ,gg.claims_type as event_class_name -- Клас заходу +
	  ,gg.object_name -- Об'єкт
	  ,gg.executor as executor_name -- Виконавець
	  ,CONVERT(datetime, CONVERT(datetimeoffset(4),gg.registration_date) AT TIME ZONE 'Pacific SA Standard Time') AS  start_date -- Дата початку
	  ,qs.[name] as [status]
	  ,CONVERT(datetime, CONVERT(datetimeoffset(4),gg.fact_finish_date) AT TIME ZONE 'Pacific SA Standard Time') as real_end_date -- Факт.завершення
  FROM [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_global] as gg
	join [CRM_1551_GORODOK_Integrartion].[dbo].[Claims_states] cs on cs.name = gg.[status]
	JOIN CRM_1551_Analitics.dbo.QuestionStates qs ON qs.Id = cs.[1551_state]

	where #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only