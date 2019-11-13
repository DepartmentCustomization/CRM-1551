

  --declare @OrganisationId int =7683;

  select 
    Id, 
    short_name as name, 
    phone_number, 
    address
  from [dbo].[Organizations]
  where parent_organization_id=@OrganisationId
  and #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
