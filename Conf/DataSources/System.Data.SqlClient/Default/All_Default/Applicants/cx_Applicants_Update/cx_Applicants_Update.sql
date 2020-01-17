  declare @building_id2 int;
  DECLARE @interval float= 0.2;
  declare @valid_date_birth datetime;
  declare @birth_date2 datetime;
  -- declare @building_id nvarchar(10)=N'';


if exists (select * from LiveAddress where applicant_id = @applicant_id)
 begin
	update [dbo].[LiveAddress]
    set
       [building_id]=@building_id
      ,[house_block]=@house_block
      ,[entrance]=@entrance
      ,[flat]=@flat

    where [applicant_id]=@applicant_id
 end
 else
 begin
	 insert into [dbo].[LiveAddress]
  (
       [applicant_id]
      ,[building_id]
      ,[house_block]
      ,[entrance]
      ,[flat]
      ,[main]
      ,[active]
  )
  values
  (
       @applicant_id
      ,@building_id2
      ,@house_block
      ,@entrance
      ,@flat
      ,N'true'
      ,N'true'
  )
 end 

set @birth_date2=(select 
  case 
  when @day_month is not null and @birth_year is not null and RIGHT(@day_month,2)*1<=12 and LEFT(@day_month,2)*1<=31 and substring(@day_month,3,1)=N'-'
  then convert(date,LTRIM(@birth_year)+N'-'+RIGHT(@day_month,2)+N'-'+LEFT(@day_month,2))
  else null end)

  set  @valid_date_birth = IIF( @birth_date2 is not null, @birth_date2 + @interval, null )

if @building_id in (N'', N' ', N'  ')
begin 
    set @building_id2=null
end;
else
begin
    set @building_id2=@building_id
end 

/*declare @phoneNot table (id int);

insert into @phoneNot (Id)
select id
from
(
select id, row_number() over (partition by applicant_id order by phone_type_id desc) n
from [ApplicantPhones]) q
where n>1
*/

-- еслм главный совпадает и не совпадает
if replace(replace(REPLACE(@phone_number, N'(', ''), N')', N''), N'-', N'')=
(select phone_number from [dbo].[ApplicantPhones] where applicant_id=@applicant_id and [IsMain]=N'true')
	begin
			update [dbo].[ApplicantPhones]
		set
		[phone_type_id]=@phone_type_id
		where applicant_id=@applicant_id and [IsMain]=N'true'

	end

else

	begin
		update [dbo].[ApplicantPhones]
		set [IsMain]=N'false'
		where applicant_id=@applicant_id and [IsMain]=N'true'

		  insert into [dbo].[ApplicantPhones]
		  (
		  [applicant_id]
			  ,[phone_type_id]
			  ,[phone_number]
			  ,[IsMain]
			  ,[CreatedAt]
		  )

		  values
		  (
		  @applicant_id
			  ,@phone_type_id
			  ,replace(replace(REPLACE(@phone_number, N'(', ''), N')', N''), N'-', N'')
			  ,N'true'
			  ,getdate()
		  )
	end
---------------если дополнитльный совпадает/не совпадает/пустой с тем что показывается

if @phone_number2 is null or @phone_number2=N''

	begin

		update [dbo].[ApplicantPhones]
				set [IsMain]=null
				where applicant_id=@applicant_id and [IsMain]=N'false' 
	end

    else
    begin

if replace(replace(REPLACE(@phone_number2, N'(', ''), N')', N''), N'-', N'')=
(select top 1 phone_number from [dbo].[ApplicantPhones] where applicant_id=@applicant_id and [IsMain]=N'false' order by id desc)-- МОЖЕТ НУЖЕН ПОСЛЕДНИЙ НОМЕР
	begin

			update [dbo].[ApplicantPhones]
		set
		[phone_type_id]=@phone_type_id2
		where applicant_id=@applicant_id and [IsMain]=N'false' and replace(replace(REPLACE(@phone_number2, N'(', ''), N')', N''), N'-', N'')=phone_number

	end

else

	begin
		  insert into [dbo].[ApplicantPhones]
		  (
		  [applicant_id]
			  ,[phone_type_id]
			  ,[phone_number]
			  ,[IsMain]
			  ,[CreatedAt]
		  )

		  values
		  (
		  @applicant_id
			  ,@phone_type_id2
			  ,replace(replace(REPLACE(@phone_number2, N'(', ''), N')', N''), N'-', N'')
			  ,N'false'
			  ,getdate()
		  )

	end
	end

update LiveAddress 
set 
building_id = @building_id,
entrance = @entrance,
flat = @flat 
where applicant_id = @applicant_id
and main = 1

update [dbo].[Applicants]
set    [full_name]=@full_name
      ,[applicant_type_id]=@applicant_type_id
      ,[category_type_id]=@category_type_id
      ,[social_state_id]=@social_state_id
      ,[mail]=@mail
      ,[sex]=@sex
      ,[birth_date]= @valid_date_birth
      --,[age]=@age
      ,[comment]=@comment
      --,[user_id]=@user_id
      ,[edit_date]=getdate()
      ,[user_edit_id]=@user_id
      ,[applicant_privilage_id]=@applicant_privilage_id
	  ,[birth_year]=@birth_year
	  ,ApplicantAdress = (select distinct
  isnull([Districts].name+N' р-н., ', N'')+
  isnull([StreetTypes].shortname+N' ',N'')+
  isnull([Streets].name+N' ',N'')+
  isnull([Buildings].name+N', ',N'')+
  isnull(N'п. '+ltrim([LiveAddress].[entrance])+N', ', N'')+
  isnull(N'кв. '+ltrim([LiveAddress].flat)+N', ', N'')+
  N'телефони: '+isnull(stuff((select N', '+lower(SUBSTRING([PhoneTypes].name, 1, 3))+N'.: '+[ApplicantPhones].phone_number
  from [CRM_1551_Analitics].[dbo].[ApplicantPhones]
  left join [CRM_1551_Analitics].[dbo].[PhoneTypes] on [ApplicantPhones].phone_type_id=[PhoneTypes].Id
  where [ApplicantPhones].applicant_id=[LiveAddress].applicant_id
  for xml path('')), 1, 2,N''), N'') phone
  from [CRM_1551_Analitics].[dbo].[LiveAddress] 
  left join [CRM_1551_Analitics].[dbo].[Buildings] on [LiveAddress].building_id=[Buildings].Id
  left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=[Streets].Id
  left join [CRM_1551_Analitics].[dbo].[StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Districts] on [Buildings].district_id=[Districts].Id
  where applicant_id=@applicant_id)
where id=@applicant_id



/*
UPDATE  [dbo].[Applicants]
         
		SET [full_name] = @full_name
           ,[applicant_type_id]= @types_id
           ,[applicant_category_id] = @category_id
           ,[social_state_id] = @states_id
           ,[mail] = @mail
           ,[sex] = @sex
           ,[birth_date] = @birth_date
           ,[comment] = @comment
           ,[edit_date] = getutcdate()
           ,[user_edit_id] = @user_edit_id
WHERE Id = @Id
*/