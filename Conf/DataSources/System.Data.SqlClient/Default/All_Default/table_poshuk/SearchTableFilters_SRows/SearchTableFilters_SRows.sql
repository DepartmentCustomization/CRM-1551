--declare @user_id nvarchar(128)=N'Vasya';

  SELECT [Id], [filter_name], [filters]
  FROM [dbo].[SearchTableFilters]
  WHERE[user_id]=@user_id
  AND #filter_columns#
  order by 1--#sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
