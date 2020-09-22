INSERT INTO [dbo].[SearchTableFilters]
  (
  [user_id]
      ,[filter_name]
      ,[filters]
  )

  SELECT @user_id, @filter_name, @filters