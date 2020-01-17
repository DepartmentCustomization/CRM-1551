insert 
into [OGroupIncludeOrganizations]
([organization_group_id], [organization_id])
output [inserted].[Id]
values(@groupId, @org)