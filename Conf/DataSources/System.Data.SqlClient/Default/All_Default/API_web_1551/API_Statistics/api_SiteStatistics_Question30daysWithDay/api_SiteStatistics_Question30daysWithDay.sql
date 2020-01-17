select Id, [For_date], [InWork], [Closed], [Overdue]
  from [CRM_1551_Site_Integration].[dbo].[Statistics_Question30daysWithDay]
  where For_date between dateadd(DD, -30, convert(date, getdate())) and convert(date, getdate())
  and #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only

