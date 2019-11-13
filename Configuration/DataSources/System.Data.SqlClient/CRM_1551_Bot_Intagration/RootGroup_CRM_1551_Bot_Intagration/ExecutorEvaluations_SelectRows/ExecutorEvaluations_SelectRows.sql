select *
from [dbo].[ExecutorEvaluations]
order by Id
offset @pageOffsetRows rows fetch next @pageLimitRows rows only