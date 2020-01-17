delete from [dbo].[ApplicantPhones] where Id = @PhoneId and IsMain = 0
select 'OK' as [Result]