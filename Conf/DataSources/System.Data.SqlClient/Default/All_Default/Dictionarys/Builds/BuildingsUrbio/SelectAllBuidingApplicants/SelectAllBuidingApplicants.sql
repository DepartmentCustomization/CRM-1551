select a.Id as applicant,
a.full_name as fullName, 
la.entrance, la.flat
from Applicants a
join LiveAddress la on la.applicant_id = a.Id 
where la.building_id = @Id
and #filter_columns#
    #sort_columns#
--offset @pageOffsetRows rows fetch next @pageLimitRows rows only