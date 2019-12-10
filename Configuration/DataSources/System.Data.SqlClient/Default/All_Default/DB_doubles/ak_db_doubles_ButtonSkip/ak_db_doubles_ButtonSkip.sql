/*
declare @Ids nvarchar(300)=N'1,2,3';
declare @Id_table int=1;
*/
-- если не важно, на множественный выбор
update [ApplicantDublicate]
  set [IsDone]='true',
  [User_done_id]=@user_Id,
  [Done_date]=getutcdate()
  where Id=@Id_table

-- если с выбраными во множенственном выборе
/*
  if @Ids is not null
  begin
  update [ApplicantDublicate]
  set [IsDone]='true',
  [User_done_id]=@user_Id,
  [Done_date]=getutcdate()
  where Id=@Id_table
  end
 */