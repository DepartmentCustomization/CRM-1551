
  --declare @Id int = 5; 
  declare @question_id int=
  (select question_id from [CRM_1551_Analitics].[dbo].[Question_History] where Id=@Id);

  --declare @question_id int = 1234;

  with main as
  (select top 2 ROW_NUMBER() over(order by [Question_History].[Id] desc) n,
  [Question_History].Id, 
  [Question_History].question_id, 
  convert(nvarchar(500), [Question_History].registration_number) registration_number, 
  --[Question_History].receipt_date, 
  convert(nvarchar(500), FORMAT([Question_History].receipt_date, 'yyyy-MM-dd hh:mm')) [receipt_date],
  convert(nvarchar(500), [QuestionStates].name) [QuestionStates], 
  --convert(nvarchar(500), [Question_History].control_date) control_date,
  convert(nvarchar(500), FORMAT([Question_History].control_date, 'yyyy-MM-dd hh:mm')) [control_date],
  convert(nvarchar(500), [Objects].name) [Objects], 
  convert(nvarchar(500), [Question_History].[object_comment]) [object_comment], 
  convert(nvarchar(500), [Organizations].short_name) [Organization],
  convert(nvarchar(500), [Question_History].application_town_id) application_town_id, 
  convert(nvarchar(500), [Events].name) [Event], 
  convert(nvarchar(500), [QuestionTypes].name) [QuestionTypes],
  convert(nvarchar(500), [Question_History].question_content) question_content, 
  convert(nvarchar(500), [AnswerTypes].name) [AnswerTypes], 
  convert(nvarchar(500), [Question_History].answer_phone) answer_phone,
  convert(nvarchar(500), [Question_History].answer_post) answer_post, 
  convert(nvarchar(500), [Question_History].answer_mail) answer_mail, 
  convert(nvarchar(500), [Question_History].operator_notes) operator_notes,
  convert(nvarchar(500), [Question_History].entrance) entrance, 
  convert(nvarchar(500), [Question_History].flat) flat
  from [CRM_1551_Analitics].[dbo].[Question_History]
  left join [CRM_1551_Analitics].[dbo].[QuestionStates] on [Question_History].question_state_id=[QuestionStates].Id
  left join [CRM_1551_Analitics].[dbo].[Objects] on [Question_History].[object_id]=[Objects].Id
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Question_History].organization_id=[Organizations].Id
  left join [CRM_1551_Analitics].[dbo].[Events] on [Question_History].event_id=[Events].Id
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [Question_History].question_type_id=[QuestionTypes].Id
  left join [CRM_1551_Analitics].[dbo].[AnswerTypes] on [Question_History].answer_form_id=[AnswerTypes].Id
  where question_id=@question_id and [Question_History].Id<=@Id),

  table_history as
  (select question_id, [n], [sravnenie], [znachenie]
  from main
  unpivot(
  [sravnenie] for [znachenie]  in ([registration_number], [receipt_date], [QuestionStates], 
  [control_date], [Objects], 
  [object_comment], [Organization], [application_town_id], [Event],
  [QuestionTypes], [question_content], [AnswerTypes], [answer_phone], 
  [answer_post], [answer_mail], [operator_notes], [entrance],
  [flat]
  )
  ) as unp)

  select /*t1.n, t2.n,*/t1.question_id Id,
  case
  when t1.znachenie=N'registration_number' then N'Реєстраційний номер питання'
  when t1.znachenie=N'receipt_date' then N'Дата та час надходження'
  when t1.znachenie=N'QuestionStates' then N'Стан питання'
  when t1.znachenie=N'control_date' then N'Дата контролю'
  when t1.znachenie=N'Objects' then N'Об`єкт'
  when t1.znachenie=N'object_comment' then N'Коментар щодо об`єкта'
  when t1.znachenie=N'Organization' then N'Організація'
  when t1.znachenie=N'application_town_id' then N'Заявка в «Городок»'
  when t1.znachenie=N'Event' then N'Захід'
  when t1.znachenie=N'QuestionTypes' then N'Тип питання'
  when t1.znachenie=N'question_content' then N'Зміст питання'
  when t1.znachenie=N'AnswerTypes' then N'Надати відповідь у вигляді'
  when t1.znachenie=N'answer_phone' then N'Телефон для відповіді'
  when t1.znachenie=N'answer_post' then N'Поштова адреса для відповіді'
  when t1.znachenie=N'answer_mail' then N'E-mail для відповіді'
  when t1.znachenie=N'operator_notes' then N'Нотатки оператора'
  when t1.znachenie=N'entrance' then N'Під`їзд'
  when t1.znachenie=N'flat' then N'Квартира'
  end znachenie,

  t2.sravnenie [bylo], t1.sravnenie [stalo]
  from (select * from table_history where n=1) t1
  inner join (select * from table_history where n=2) t2 on t1.znachenie=t2.znachenie and t1.sravnenie<>t2.sravnenie
