declare  @output table (Id int)

insert into [dbo].[ExecutorRole]
    (name)
output inserted.Id into @output(Id)
  values 
    @name
    
declare @newId int
set @newId = (select top 1 Id from @output)
    
select @newId as Id
return;