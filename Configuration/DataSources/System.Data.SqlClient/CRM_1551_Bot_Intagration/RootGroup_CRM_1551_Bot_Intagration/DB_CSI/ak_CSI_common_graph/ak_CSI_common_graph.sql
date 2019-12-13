  --загальний графік

  select Id, Integral_indicator, convert(date, [calc_date]) Calc_date
  from [IntegralIndicator]
  where calc_date between convert(date, @date_from) and convert(date, @date_to)