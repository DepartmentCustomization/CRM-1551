
insert into [dbo].[Consultations] ([registration_date]
									  ,[phone_number]
									  ,[appeal_id]
									  ,[consultation_type_id]
									  ,[object_id]
									  ,[user_id]
									  ,[application_town_id]
									  )
values ( 
getutcdate(),
@Applicant_Phone,
@AppealId,
2,	/*За GORODOK*/
@Applicant_Building,
@CreatedUser,
@GorodokClaim_RowId
)