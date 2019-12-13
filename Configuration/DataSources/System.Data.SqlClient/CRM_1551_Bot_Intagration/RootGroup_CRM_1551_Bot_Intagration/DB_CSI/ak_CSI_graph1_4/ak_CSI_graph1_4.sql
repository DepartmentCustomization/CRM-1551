
  --график 1.4
  select convert(nvarchar, [calc_date], 112)*1 Id, [calc_date], avg(average_grade) average
  from [EveragePollItemGrade]
  where [bot_poll_item_id]=4 and calc_date between convert(date, @date_from) and convert(date, @date_to)
  group by [calc_date]