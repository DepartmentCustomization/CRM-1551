--declare @uglId int = 15371;
declare @outId table (Id int);
declare @Is_AppealCreated bit; 

set @Is_AppealCreated = (
select case when Appeals_Id is not null then 1 else 0 end
from [Звернення УГЛ] 
where Id = @uglId
)

If (@Is_AppealCreated = 0)
begin
    declare @phone nvarchar(15);
    set @phone = ( 
    select 
    IIF(
    charindex(',', Телефон) > 0, 
    (substring(Телефон, 1, 10)),
    Телефон) 
    from [Звернення УГЛ] 
    where Id = @uglId
    )

Insert into dbo.Appeals (
    registration_date,
    receipt_source_id,
    phone_number,
    receipt_date,
    [start_date], 
    [user_id],
    edit_date,
    user_edit_id )

output inserted.Id into @outId (Id)
Values ( 
    getutcdate(),
    3,
    @phone,
    getutcdate(),
    getutcdate(),
    @user_id,
    getutcdate(),
    @user_id )

declare @newId int = (select top 1 Id from @outId)
update [dbo].[Appeals] 
 set registration_number =  concat( SUBSTRING ( rtrim(YEAR(getdate())),4,1),'-',
(select count(Id) from Appeals where year(Appeals.registration_date) = year(getdate())) )
 where Id =  @newId

update [dbo].[Звернення УГЛ]
 set Appeals_id = @newId
 ,[Опрацював]=@user_id
 ,[Дата опрацювання]=GETUTCDATE()
 ,[Опрацьовано]=1
 where Id = @uglId;
  
select @newId as [Id]
return;
end

Else 
begin 
select Appeals_Id as Id
from [Звернення УГЛ] 
where Id = @uglId
return;
end