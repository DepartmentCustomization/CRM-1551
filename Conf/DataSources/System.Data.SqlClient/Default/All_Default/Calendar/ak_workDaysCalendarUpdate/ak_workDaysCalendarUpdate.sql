--declare @Id int=1108;
  declare @date date;
  declare @exe_date date;
  declare @is_work bit=
  (select is_work
  from [WorkDaysCalendar]
  where id=@Id)

  if @is_work='true'
	begin
		set @date=(select [date] from [WorkDaysCalendar] where id=@Id)
		set @exe_date=(select min(execution_date) from [WorkDaysCalendar] where [date]>@date)

		update [WorkDaysCalendar]
		set is_work='false'
		where id=@Id

		update [WorkDaysCalendar]
		set execution_date=@exe_date
		where execution_date=@date
	end

	if @is_work='false'
		begin
			set @exe_date=(select execution_date from [WorkDaysCalendar] where id=@Id)
			set @date=(select [date] from [WorkDaysCalendar] where id=@Id)

			update [WorkDaysCalendar]
			set is_work='true'
			,execution_date=@date
			where id=@id

			update [WorkDaysCalendar]
			set execution_date=@date
			where execution_date=@exe_date and [date]<=@date
		end