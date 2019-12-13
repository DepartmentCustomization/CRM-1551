
  --пирожок 1.12
  select grade Id, Grade, count(question_id) Count_questions
  from [ExecutorEvaluations]
  where question_id is not null and bot_poll_item_id in (16,17,18,19,20) and grade between 1 and 5
  and convert(date, [answer_date]) between convert(date, @date_from) and convert(date, @date_to)
  group by grade
