SELECT [ApplicantPhones].[Id]
      ,PhoneTypes.name as phone_type_name
        , PhoneTypes.Id as phone_type_id
      ,[ApplicantPhones].[phone_number]
  FROM [dbo].[ApplicantPhones]
	left join PhoneTypes on PhoneTypes.Id = ApplicantPhones.phone_type_id
WHERE [ApplicantPhones].[Id] = @Id