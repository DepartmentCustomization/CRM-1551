-- DECLARE @ApplicantsId INT = 27;

SELECT
  [Consultations].id ConsultationsId,
  [Consultations].phone_number,
  [ConsultationTypes].name ConsultationType,
  [Events].Id EventId,
  [Consultations].[registration_date]
FROM
  [dbo].[Consultations]
  LEFT JOIN [dbo].[Appeals] ON [Appeals].id = Consultations.appeal_id
  LEFT JOIN Applicants ON Applicants.Id = Appeals.applicant_id
  LEFT JOIN [dbo].[ConsultationTypes] ON [Consultations].consultation_type_id = [ConsultationTypes].Id
  LEFT JOIN [dbo].[Events] ON [Consultations].event_id = [Events].Id
WHERE
  [Applicants].id = @ApplicantsId
  AND #filter_columns#
      #sort_columns#
 OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY ;