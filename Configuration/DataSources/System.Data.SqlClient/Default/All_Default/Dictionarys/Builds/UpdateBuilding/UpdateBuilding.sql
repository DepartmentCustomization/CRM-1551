begin
UPDATE [dbo].[Buildings]
   SET [district_id] = @district_id
    --   ,[street_id] = @street_id     
    --   ,[number] = @number
      ,[letter] = @letter
      ,[bsecondname] = @bsecondname 
      ,[name] = isnull(rtrim(@number),N'')+isnull(rtrim(' ' + @letter),N'')+
      isnull(rtrim(', к.'+ @bsecondname), N'')
      ,[index] = @index
      ,[is_active] = @isActive
      ,edit_date = getutcdate()
      ,user_edit_id = @user_edit_id
 WHERE Id = @Id
 end

  begin
 declare @street_type_and_name nvarchar(max);

 set @street_type_and_name = (
 select 
	 st.shortname + ' ' + s.name
	 from [Objects] as o
		left join Buildings as b on b.Id = o.builbing_id
		left join Streets as s on s.Id = b.street_id
		left join StreetTypes as st on st.Id = s.street_type_id
	where b.Id = @Id
	)
update [Objects]
set name = @street_type_and_name +
					isnull(rtrim(', ' + @number),N'')+
						isnull(rtrim(' '+ @letter),N'')+
							isnull(rtrim(', '+ @bsecondname), N'')
  ,edit_date = getutcdate()
  ,user_edit_id = @user_edit_id
  ,[is_active] = @isActive
where [Objects].builbing_id = @Id
end