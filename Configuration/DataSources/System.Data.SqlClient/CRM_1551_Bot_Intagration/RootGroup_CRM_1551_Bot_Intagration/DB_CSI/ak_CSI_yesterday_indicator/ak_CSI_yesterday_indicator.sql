--csi за вчорашній день

select Id, Integral_indicator
  from [IntegralIndicator]
  where convert(date, [calc_date])=dateadd(DAY,-1 ,getutcdate())