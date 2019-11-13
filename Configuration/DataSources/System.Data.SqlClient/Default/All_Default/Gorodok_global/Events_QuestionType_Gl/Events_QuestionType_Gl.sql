SELECT
      qt.id
	, qt.name AS eventQuestionName
	, eq.is_hard_connection
FROM [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_global] AS gl
      JOIN [CRM_1551_Analitics].dbo.Event_Class AS es ON es.name = gl.claims_type
      LEFT JOIN [CRM_1551_Analitics].dbo.EventClass_QuestionType AS eq ON eq.event_class_id = es.id
      JOIN [CRM_1551_Analitics].dbo.QuestionTypes qt ON qt.Id = eq.question_type_id
WHERE gl.claim_number = @Id 
and  #filter_columns#
      order by eq.is_hard_connection desc
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only