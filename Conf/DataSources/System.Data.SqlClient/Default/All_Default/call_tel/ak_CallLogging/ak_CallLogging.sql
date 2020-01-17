  insert into [CallLogging]
  (
  [Session]
      ,[UserId]
      ,[AssigmentId]
      ,[CreatedAt]
  )

  select @Session, @UserId, @AssigmentId, getutcdate()