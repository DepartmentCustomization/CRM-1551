update [dbo].[Appeals] set [enter_number] = @Enter_number
  where id = @AppealId
  
 select N'OK' as result