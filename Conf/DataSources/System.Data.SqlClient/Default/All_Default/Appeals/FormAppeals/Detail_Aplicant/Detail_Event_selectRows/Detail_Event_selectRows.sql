--   DECLARE @object_id INT = 34521;

 /*
Час в БД Городка зберігається реальний час, а ми при виводі Глобалок Городка додаємо +3 години чи +2 години. Потрібно в деталі Заходи та 
ЗАЯВКИ ЗА ГОРОДКОМ відображати час як є в БД.
Task 1006
*/
DECLARE @zoneVal SMALLINT = DATEPART(TZOffset, SYSDATETIMEOFFSET());

SELECT
    [Id],
    [Номер Заходу],
    [Тип Заходу],
    [Відповідальний за усунення],
    [Зміст],
    [Дата початку],
    [Планова дата завершення],
    [EventTypesId],
    [eventClassName],
    [BaseType]
FROM
    (
        SELECT
            [Events].[Id],
            [Events].[Id] AS [Номер Заходу],
            [EventTypes].name AS [Тип Заходу],
            [Organizations].short_name AS [Відповідальний за усунення],
            [Events].[comment] AS [Зміст],
            [Events].[start_date] AS [Дата початку],
            [Events].[plan_end_date] AS [Планова дата завершення],
            [EventTypes].Id AS [EventTypesId],
            ec.name AS eventClassName,
            'EVENT' AS [BaseType]
        FROM
            [dbo].[EventObjects]
            LEFT JOIN [dbo].[Events] ON [Events].Id = [EventObjects].[event_id]
            LEFT JOIN [dbo].[EventTypes] ON [EventTypes].Id = [Events].[event_type_id] 
            LEFT JOIN [dbo].[EventOrganizers] ON [EventOrganizers].event_id = [Events].Id
            LEFT JOIN [dbo].[Organizations] ON [Organizations].Id = [EventOrganizers].organization_id
            LEFT JOIN [dbo].[Event_Class] AS ec ON ec.id = [Events].event_class_id
        WHERE
            [EventObjects].[object_id] = @object_id
            AND [Events].[active] = 1
        UNION
        ALL
        SELECT
            lcg.[id] AS [Id],
            lcg.[claim_number] AS [Номер Заходу],
            [EventTypes].name AS [Тип Заходу],
            lcg.[executor] AS [Відповідальний за усунення],
            lcg.[content] AS [Зміст],
			-- что-бы отобразить в детали дату-время с бд городка уменьшаем на текущее значение от разницы UTC
			DATEADD(MINUTE,-@zoneVal,lcg.[start_date]) AS [Дата початку],
            DATEADD(MINUTE,-@zoneVal,lcg.[plan_finish_date]) AS [Планова дата завершення],
            [EventTypes].Id AS [EventTypesId],
            [Event_Class].[name] AS eventClassName,
            'GORODOK' AS [BaseType]
        FROM
            [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_global] AS lcg
            LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Global_claims_types_new] AS gctn ON gctn.id = lcg.claims_type_id
            LEFT JOIN [dbo].[Event_Class] ON [Event_Class].global_id = gctn.id
            LEFT JOIN [dbo].[EventTypes] ON [EventTypes].Id = [Event_Class].[event_type_id]
            LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[AllObjectInClaim] AS aoc ON aoc.claims_number_id = lcg.claim_number
			LEFT JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] gh ON gh.[gorodok_houses_id] = aoc.[object_id]
			LEFT JOIN [dbo].[Buildings] obj ON obj.Id = gh.[1551_houses_id]
        WHERE
            obj.Id = @object_id
            AND lcg.[status] IN (
                N'due',
                N'future',
                N'in_progress',
                N'not_transferred',
                N'overdue'
            )
    ) AS t1
WHERE
 #filter_columns#
 #sort_columns#
 OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY;