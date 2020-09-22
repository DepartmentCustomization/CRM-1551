
  insert into [dbo].[FiltersForControler]
  (
  [user_id]
      ,[district_id]
      ,[questiondirection_id]
      ,[create_date]
      --,[organization_id]
      ,[emergensy_id]
  )
  
  select @user_id,
  @district_id,
  @questiondirection_id,
  getutcdate(),
  @emergensy_id