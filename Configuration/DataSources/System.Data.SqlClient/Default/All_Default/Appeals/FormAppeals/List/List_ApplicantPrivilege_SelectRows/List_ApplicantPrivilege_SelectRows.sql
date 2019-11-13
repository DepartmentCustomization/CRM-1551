select [ApplicantPrivilege].Id,
       [ApplicantPrivilege].[name] as [Name]
from [dbo].[ApplicantPrivilege]
  WHERE 
	#filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only