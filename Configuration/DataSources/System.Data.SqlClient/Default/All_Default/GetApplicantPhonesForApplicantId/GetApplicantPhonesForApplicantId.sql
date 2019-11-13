

--declare @applicant_id int = 4

SELECT ROW_NUMBER() OVER(ORDER BY [ApplicantPhones].id desc) as position 
      ,N'modal_phone'+rtrim(ROW_NUMBER() OVER(ORDER BY [ApplicantPhones].id desc)) as ColCode
      ,N'Телефон '+rtrim(ROW_NUMBER() OVER(ORDER BY [ApplicantPhones].id desc)) as ColName
      ,[phone_number]
      ,[isMain]
      ,0 isNew
	  ,[PhoneTypes].Id as [PhoneTypeId]
	  ,[PhoneTypes].[name] as [PhoneTypeName]
	  ,[ApplicantPhones].Id
  FROM [dbo].[ApplicantPhones]
  left join [dbo].[PhoneTypes] on [PhoneTypes].Id = [ApplicantPhones].phone_type_id
  where applicant_id = @applicant_id
union all 
select (select count(1)+1 FROM [dbo].[ApplicantPhones]
  where applicant_id = @applicant_id)
,N'modal_phone_NEW'
,N'Новий телефон',
  NULL,
  0 as [isMain],
  1 isNew,
  NULL,
  NULL,
  0 as Id