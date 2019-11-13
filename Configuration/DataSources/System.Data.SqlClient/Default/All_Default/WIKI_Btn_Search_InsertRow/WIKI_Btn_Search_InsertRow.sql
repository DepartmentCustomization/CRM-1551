insert into [dbo].[Consultations] ([registration_date]
									  ,[phone_number]
									  ,[appeal_id]
									  ,[consultation_type_id]
									  ,[object_id]
									  ,[user_id])
values ( 
getutcdate(),
@Applicant_Phone,
@AppealId,
3, /*За Базою Знань (БЗ)*/		
@Applicant_Building,
@CreatedUser
)
----- add Artem
update [CRM_1551_Analitics].[dbo].[Appeals]
  set applicant_id=@applicant_id
  where id=@AppealId