-- declare @PhoneNumber nvarchar(25) = N'0993896537',
-- 		@CreatedById nvarchar(128) = N'Admin'

if (select count(1) from [dbo].[ApplicantDublicate] where PhoneNumber = @PhoneNumber and IsDone = 0) > 0
begin
	select N'Поточний номер уже додано до списку для обробки' as [Id]
end
else
begin
	insert into [dbo].[ApplicantDublicate] (PhoneNumber, CreatedById)
	output [inserted].[Id]
	values (@PhoneNumber, @CreatedById)
end