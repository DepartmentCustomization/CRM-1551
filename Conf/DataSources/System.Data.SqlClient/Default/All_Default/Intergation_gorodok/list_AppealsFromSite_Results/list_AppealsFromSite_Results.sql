select id as Id, name
from SiteAppealsResults
where #filter_columns# 
      #sort_columns#
      offset @pageOffsetRows rows fetch next @pageLimitRows rows only