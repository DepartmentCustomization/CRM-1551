declare @year int=(select top 1 YEAR([date])+1
  from [WorkDaysCalendar]
  order by date desc);
  declare @start_date date = datefromparts(@year, 1,1);
  declare @finish_date date = datefromparts(@year, 12,31);
  declare @date date;
  declare @n int=0;

  /*
  declare @calendar table ([date] date
      ,[day] nvarchar(10)
      ,[is_work] bit
      ,[execution_date] date)*/

	  -- проверка на высокосный год, или не нужно, sql сам посчитает

  while @start_date<=dateadd(dd, @n,@start_date) and @finish_date>=dateadd(dd, @n,@start_date)

	begin
		  set @date=dateadd(dd, @n,@start_date);

		  insert into [WorkDaysCalendar]
		  (
		  [date]
			  ,[day]
			  ,[is_work]
			  ,[execution_date]
		  )
   
  

		  select @date , case 
		  when datepart(weekday, @date)=2 then N'Пн'
		  when datepart(weekday, @date)=3 then N'Вт'
		  when datepart(weekday, @date)=4 then N'Ср'
		  when datepart(weekday, @date)=5 then N'Чт'
		  when datepart(weekday, @date)=6 then N'Пт'
		  when datepart(weekday, @date)=7 then N'Сб'
		  when datepart(weekday, @date)=1 then N'Нд'
		  end [day], 
		  case when datepart(weekday, @date) in (7,1) then 'false' else 'true' end is_work,

		  case when datepart(weekday, @date) not in (7,1) then @date 
		  when datepart(weekday, @date)=7 then dateadd(dd, 2,@date)
		  when datepart(weekday, @date)=1 then dateadd(dd, 1,@date)
		  end
		

	set @n=@n+1;
	end