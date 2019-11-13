

  --declare @Attention_term_hours nvarchar(200)=N'12(123)';

  declare @Attention_term_hours1 int =
  case
when CHARINDEX(N'(',@Attention_term_hours, 1)>0
then left(right(@Attention_term_hours, len(@Attention_term_hours)-charindex(N'(', @Attention_term_hours, 1)), LEN(right(@Attention_term_hours, len(@Attention_term_hours)-charindex(N'(', @Attention_term_hours, 1)))-1)*1
else @Attention_term_hours*24  end;

--declare @execution_term nvarchar(200)=N'23';

  declare @execution_term1 int =

  case
when CHARINDEX(N'(',@execution_term, 1)>0
then left(right(@execution_term, len(@execution_term)-charindex(N'(', @execution_term, 1)), LEN(right(@execution_term, len(@execution_term)-charindex(N'(', @execution_term, 1)))-1)*1
else @execution_term*24  end 

  --declare @Id int =288;

  --select Id, [Attention_term_hours], [execution_term],
  --case when [execution_term]=@execution_term1
  --then [Attention_term_hours]
  --else @Attention_term_hours1  end
  --from [CRM_1551_Analitics].[dbo].[QuestionTypes]
  --where Id=@Id




UPDATE [dbo].[QuestionTypes]
       SET    [question_type_id]= @question_type_id
           ,[index] = @index
           ,[name]= @name
           ,[emergency]= @emergency
           ,[active]= @active
           ,[rule_id]= @rule_id
           ,[parent_organization_is] = @parent_organization_is
           ,[comments]= @comments


           ,[Attention_term_hours]=--@Attention_term_hours1 	
		   (select
  case when [execution_term]=@execution_term1
  then @Attention_term_hours1
  else convert(numeric(8,0),@execution_term1*0.75)  end Attention_term_hours2
  from [CRM_1551_Analitics].[dbo].[QuestionTypes]
  where Id=@Id)
		      
		   ,[execution_term]=@execution_term1
           ,[edit_date]= GETUTCDATE()
           ,[user_edit_id] = @user_edit_id
           ,[Object_is]=@Object_is
           ,[Organization_is]=@Organization_is
WHERE Id = @Id

-- if not exists(select Id
--  from [CRM_1551_Analitics].[dbo].[QuestionTypeInRating]
--  where [QuestionType_id]=@Id)
--  begin
--insert into [CRM_1551_Analitics].[dbo].[QuestionTypeInRating]
--  ([QuestionType_id]
--      ,[Rating_id])

--  select @Id, case when @blag is not null then @blag
--  when @zhytraion is not null then @zhytraion
--  when @zhkg is not null then @zhkg
--  end
--  end


--if @zhkg=1
--		begin

--	update [CRM_1551_Analitics].[dbo].[QuestionTypeInRating]
--  set [Rating_id]=1
--  where [QuestionType_id]=@Id

--  end

--  if @blag=1
--  begin
  
--  update [CRM_1551_Analitics].[dbo].[QuestionTypeInRating]
--  set [Rating_id]=2
--  where [QuestionType_id]=@Id

--  end

--  if @zhytraion=1

--  begin

--  update [CRM_1551_Analitics].[dbo].[QuestionTypeInRating]
--  set [Rating_id]=3
--  where [QuestionType_id]=@Id

--  end

--  if (@blag=0 and @zhytraion=0 and @zhkg=0)
--  begin
--  delete 
--  from [CRM_1551_Analitics].[dbo].[QuestionTypeInRating]
--  where [QuestionType_id]=@Id
--  end

delete
  from [QuestionTypeInRating]
  where Id in
  (
  select Id
  from [QuestionTypeInRating]
  where [QuestionType_id]=@id
  and Rating_id in
  (
  select case when @zhkg=0 then 1 end
  union
  select case when @blag=0 then 2 end
  union
  select case when @zhytraion=0 then 3 end
  )
  )


  -- при добавлении в таблицу
  
  insert into [QuestionTypeInRating]
  (
       [Rating_id]
      ,[QuestionType_id]
  )
  
  select t, id
  from 
  (
  select case when @zhkg=1 then 1 else null end t, @id id
  union all
  select case when @blag=1 then 2 else null end t, @id id
  union all
  select case when @zhytraion=1 then 3 else null end t, @id id
  ) q
  where t is not null
  except
  select [Rating_id], [QuestionType_id]
  from [QuestionTypeInRating]
  where [QuestionType_id]=@id




declare @step nvarchar(50)=N'update_question_type';
  exec [dbo].[ak_UpdateOrganizationsQuestionsTypeAndParent] @step, @Id
