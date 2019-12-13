
select convert(nvarchar, [calc_date], 112)*1 Id, [Calc_date], avg(average_grade) Average
  from [EveragePollItemGrade]
  where [bot_poll_item_id]=1 and calc_date between convert(date, @date_from) and convert(date, @date_to)
  group by [calc_date]