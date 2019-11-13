select u.UserId as Id,
u.LastName + isnull(' ' + u.FirstName, N'') + 
             isnull(' ' + u.Patronymic,N'') 
			 as Operator
from CRM_1551_System.[dbo].[User] u
 where #filter_columns#
       #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only