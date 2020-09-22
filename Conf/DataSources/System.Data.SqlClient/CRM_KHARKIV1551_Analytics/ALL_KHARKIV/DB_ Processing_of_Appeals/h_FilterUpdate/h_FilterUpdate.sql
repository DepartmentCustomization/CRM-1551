update [dbo].[FiltersForControler]
  set [district_id]=@district_id,
  [questiondirection_id]=@questiondirection_id,
  [emergensy_id]=@emergensy_id
  where Id=@Id and [user_id]=@user_id