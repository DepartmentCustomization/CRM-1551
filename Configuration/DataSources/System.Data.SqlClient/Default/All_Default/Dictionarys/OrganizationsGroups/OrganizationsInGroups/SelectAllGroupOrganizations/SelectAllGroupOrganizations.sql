select ogino.Id, o.name as orgName
from [OGroupIncludeOrganizations] ogino
join OrganizationGroups og on ogino.organization_group_id = og.Id
join Organizations o on o.Id = ogino.organization_id
where og.Id = @Id
and #filter_columns#
 order by 1
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only