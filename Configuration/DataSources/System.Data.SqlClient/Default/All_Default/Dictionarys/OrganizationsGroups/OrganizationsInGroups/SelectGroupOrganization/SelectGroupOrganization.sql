select Id, organization_group_id as groupId, organization_id
from [OGroupIncludeOrganizations]
where Id = @Id;