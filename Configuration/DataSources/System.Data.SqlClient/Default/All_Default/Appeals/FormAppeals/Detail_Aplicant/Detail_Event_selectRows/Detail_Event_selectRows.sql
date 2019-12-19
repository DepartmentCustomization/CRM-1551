SELECT  [Id],
        [Номер Заходу], 
        [Тип Заходу], 
        [Відповідальний за усунення],
        [Зміст], 
        [Дата початку],
        [Планова дата завершення], 
        [EventTypesId],
        [eventClassName],
        [BaseType] 
from  
(
        SELECT  [Events].[Id],
                [Events].[Id] as [Номер Заходу], 
                [EventTypes].name as [Тип Заходу], 
                [Organizations].short_name as [Відповідальний за усунення],
                [Events].[comment] as [Зміст], 
                [Events].[start_date] as [Дата початку],
                [Events].[plan_end_date] as [Планова дата завершення], 
                [EventTypes].Id as [EventTypesId]
                ,ec.name as eventClassName 
                ,'EVENT' as [BaseType]  
        FROM [dbo].[EventObjects]
        left join [dbo].[Events] on [Events].Id = [EventObjects].[event_id]
        left join [dbo].[EventTypes] on [EventTypes].Id = [Events].[event_type_id]
        -- left join [dbo].EventQuestionsTypes as eqt on eqt.event_id = [Events].Id
        --left join [dbo].[QuestionTypes] on [QuestionTypes].Id = eqt.question_type_id
        left join [dbo].[EventOrganizers] on [EventOrganizers].event_id = [Events].Id
        left join [dbo].[Organizations] on [Organizations].Id = [EventOrganizers].organization_id
        left join [dbo].[Event_Class] as ec on ec.id = [Events].event_class_id
        where [EventObjects].[object_id] = @object_id and [Events].[active] = 1
            UNION ALL
        SELECT lcg.[id] as [Id]
            ,lcg.[claim_number] as [Номер Заходу]
            ,[EventTypes].name as [Тип Заходу]
            ,lcg.[executor] as [Відповідальний за усунення]
            ,lcg.[content] as [Зміст]
            ,lcg.[registration_date] as [Дата початку]
            ,lcg.[plan_finish_date] as [Планова дата завершення]
            ,[EventTypes].Id as [EventTypesId]
            ,[Event_Class].[name] as eventClassName	
            ,'GORODOK' as [BaseType]  
        FROM [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_global] as lcg
            left join  [CRM_1551_GORODOK_Integrartion].[dbo].[Global_claims_types_new] as gctn on gctn.id = lcg.claims_type_id
        left join  [dbo].[Event_Class] on [Event_Class].global_id = gctn.id
        left join [dbo].[EventTypes] on [EventTypes].Id = [Event_Class].[event_type_id]
        left join [CRM_1551_GORODOK_Integrartion].[dbo].[AllObjectInClaim] as aoc on aoc.claims_number_id = lcg.claim_number
        where aoc.[object_id] = @object_id
            and lcg.[status] in (N'due',
                                N'future',
                                N'in_progress',
                                N'not_transferred',
                                N'overdue')
) as t1
 where #filter_columns#
    #sort_columns#
offset @pageOffsetRows rows fetch next @pageLimitRows rows only