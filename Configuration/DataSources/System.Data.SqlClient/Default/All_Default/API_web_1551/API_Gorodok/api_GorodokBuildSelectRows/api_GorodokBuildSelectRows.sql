  --declare @street_Id int =4;

  select [Id], [Name]
  from [Buildings]
  where [street_id]=@street_Id
  and  
  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only