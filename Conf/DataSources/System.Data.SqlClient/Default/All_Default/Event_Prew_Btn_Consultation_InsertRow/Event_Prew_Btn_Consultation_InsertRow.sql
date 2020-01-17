
  insert into [dbo].[Consultations] ([registration_date]
									  ,[phone_number]
									  ,[appeal_id]
									  ,[consultation_type_id]
									  ,[object_id]
									  ,[user_id]
									  ,[event_id]
									  )
values ( 
getutcdate(),
@Applicant_Phone,
@AppealId,
4,	/*Щодо заходу*/
@Applicant_Building,
@CreatedUser,
@Event_Prew_Id
)