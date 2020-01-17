

 declare @output table (Id int);
-- declare @question_type_id int;



 -- declare @question_type_id int = 207;
  declare @new_index_right nvarchar(max) =

  (
  select case when len(REVERSE(left(REVERSE([index]), charindex(N'.',REVERSE([index]))-1))*1+1)>1
  then ltrim(REVERSE(left(REVERSE([index]), charindex(N'.',REVERSE([index]))-1))*1+1)
  else N'0'+ltrim(REVERSE(left(REVERSE([index]), charindex(N'.',REVERSE([index]))-1))*1+1)
  end


  from [CRM_1551_Analitics].[dbo].[QuestionTypes]
  where convert(bigint,(REPLACE([index], N'.', N'')))=
  ((
  select max(convert(bigint,(REPLACE([index], N'.', N''))))
  from [CRM_1551_Analitics].[dbo].[QuestionTypes]
  where [question_type_id]=@question_type_id))  
  )

  --- left

  declare @new_index_left nvarchar(max) =

  (
  select left([index], len([index])-2)


  from [CRM_1551_Analitics].[dbo].[QuestionTypes]
  where convert(bigint,(REPLACE([index], N'.', N'')))=
  ((
  select min(convert(bigint,(REPLACE([index], N'.', N''))))
  from [CRM_1551_Analitics].[dbo].[QuestionTypes]
  where [question_type_id]=@question_type_id))  
  )


  declare @new_index1 nvarchar(max)= (select @new_index_left+ @new_index_right)




  declare @new_index2 nvarchar(max)=
  (
  select case when len(ltrim(MAX([index]*1)+1))<2
  then ltrim(N'0'+ltrim(MAX([index]*1)+1))
  else ltrim(MAX([index]*1)+1) end
  from [CRM_1551_Analitics].[dbo].[QuestionTypes]
  where question_type_id is null
  )

  declare @count_pid int=
  (
  select count(id) from [CRM_1551_Analitics].[dbo].[QuestionTypes] where question_type_id=@question_type_id
  )

   declare @new_index3 nvarchar(max)=
  (
  select [index]+N'.01'
  from [CRM_1551_Analitics].[dbo].[QuestionTypes]
  where id=@question_type_id
  )


  declare @new_index nvarchar(max)=
  (
  case when @question_type_id is null then @new_index2 
  when @count_pid=0 then @new_index3
  else @new_index1 end
  )
   -- select @new_index1, @new_index_left, @new_index_right, @new_index2, @new_index3, @new_index



INSERT INTO [dbo].[QuestionTypes]
           ([question_type_id]
           ,[index]
           ,[name]
           ,[emergency]
           ,[active]
           ,[rule_id]
           ,[parent_organization_is]
           ,[comments]
           ,[Attention_term_hours]
           ,[execution_term]
           ,[user_id]
           ,[edit_date]
           ,[user_edit_id]
           ,[Object_is]
           ,[Organization_is])
           

 output [inserted].[Id] into @output (Id)
  
           
     VALUES
           (@question_type_id
           --,@index
           ,@new_index
           ,@name
           
           ,@emergency
           ,@active
           ,@rule_id
           ,@parent_organization_is
           ,@comments
           --,@Attention_term_hours
           --,@execution_term
           ,case when @Attention_term_hours is null
		   then convert(numeric(8,0), @execution_term*24*0.75)
		   else @Attention_term_hours*24 end
           ,@execution_term*24 
           ,@user_edit_id
           ,GETUTCDATE()
           ,@user_edit_id
           ,@Object_is
           ,@Organization_is
		   )
		   
  declare @id_type int;
   set @id_type=(select top 1 id from @output)		   
   

	--	if @zhkg=1
	--	begin

	--insert into [CRM_1551_Analitics].[dbo].[QuestionTypeInRating]
 -- (
 -- [QuestionType_id]
 --     ,[Rating_id]
      
 -- )

 -- VALUES
  
 -- ( @id_type
 --     , 1
 -- ) 

 -- end

 -- if @blag=1

 -- begin

 -- insert into [CRM_1551_Analitics].[dbo].[QuestionTypeInRating]
 -- (
 -- [QuestionType_id]
 --     ,[Rating_id]
      
 -- )

 -- VALUES
  
 -- ( @id_type
 --     , 2
 -- ) 

 -- end

 -- if @zhytraion=1

 -- begin

 -- insert into [CRM_1551_Analitics].[dbo].[QuestionTypeInRating]
 -- (
 -- [QuestionType_id]
 --     ,[Rating_id]
      
 -- )

 -- VALUES
  
 -- ( @id_type
 --     , 3
 -- ) 

 -- end
  
  insert into [CRM_1551_Analitics].[dbo].[QuestionTypeInRating]
  ([Rating_id],
  [QuestionType_id])
      

  select t, id
  from 
  (
  select case when @zhkg=1 then 1 else null end t, @id_type id
  union all
  select case when @blag=1 then 2 else null end t, @id_type id
  union all
  select case when @zhytraion=1 then 3 else null end t, @id_type id
  ) q
  where t is not null


  declare @step nvarchar(50)=N'insert_question_type';
  exec [dbo].[ak_UpdateOrganizationsQuestionsTypeAndParent] @step, @id_type

 select @id_type id
	return;