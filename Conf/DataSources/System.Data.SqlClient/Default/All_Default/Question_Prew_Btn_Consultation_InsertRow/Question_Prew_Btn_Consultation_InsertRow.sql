  insert into [dbo].[Consultations] ([registration_date]
									  ,[phone_number]
									  ,[appeal_id]
									  ,[consultation_type_id]
									  ,[object_id]
									  ,[user_id]
									  ,[question_id]
									  ,[question_type_id]
									  )
values ( 
getutcdate(),
@Applicant_Phone,
@AppealId,
1,	/*За питанням*/
@Applicant_Building,
@CreatedUser,
@Question_Prew_Id,
@Question_Prew_TypeId
)