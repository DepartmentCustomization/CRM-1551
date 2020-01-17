select top 1 phone_number 
from [dbo].[ApplicantPhones] 
where applicant_id = @Applicant_id
and IsMain = 1