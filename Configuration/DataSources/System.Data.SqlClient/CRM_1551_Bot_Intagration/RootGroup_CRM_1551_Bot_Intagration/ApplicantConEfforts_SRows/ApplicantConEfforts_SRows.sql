select *
from [dbo].[ApplicantConnectionEfforts]
order by Id
offset @pageOffsetRows rows fetch next @pageLimitRows rows only