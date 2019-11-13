declare @output table (Id int);
declare @out_Id int;

insert into [OrganizationGroups]([name])
output [inserted].[Id] into @output (Id)

values(@name)
set @out_Id = (select top 1 Id from @output);

select @out_Id as [Id]
return;