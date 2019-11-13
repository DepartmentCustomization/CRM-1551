select Id, name as Name
  from QuestionGroups
   where report_code = 'Analitica_spheres'
     and #filter_columns#
         #sort_columns#
   offset @pageOffsetRows rows fetch next @pageLimitRows rows only