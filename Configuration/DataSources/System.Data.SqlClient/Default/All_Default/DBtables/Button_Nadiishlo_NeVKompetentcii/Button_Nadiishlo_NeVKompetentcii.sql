declare @output table ([Id] int)
    declare @ass_id int
--     declare @new_execution_date datetime
    
--     set @new_execution_date = getutcdate() + (select execution_term from QuestionTypes where id = 
--                 (select question_type_id from Questions where id = 
--                     (select question_id FROM Assignments where id = @Id)))/24

 ------------
 if (select [executor_organization_id] from [CRM_1551_Analitics].[dbo].[Assignments] where Id=@Id)=@executor_organization_id
 begin

 update [CRM_1551_Analitics].[dbo].[Assignments]
   set [assignment_state_id]=1 -- Зареєстровано
   ,[AssignmentResultsId]=6 --Повернуто виконавцю
   ,[AssignmentResolutionsId]=3 --Перенаправлено за належністю
   ,edit_date = GETUTCDATE()
   ,user_edit_id = @user_edit_id
   ,[LogUpdated_Query] = N'Button_Nadiishlo_NeVKompetentcii_Row19'
   where Id=@Id

   update [CRM_1551_Analitics].[dbo].[AssignmentConsiderations]
  set [assignment_result_id]=6 --Повернуто виконавцю
  ,[assignment_resolution_id]=3 --Перенаправлено за належністю
  ,edit_date = GETUTCDATE()
  ,user_edit_id = @user_edit_id
--   where assignment_id=@Id
where Id = ( select current_assignment_consideration_id from Assignments where Id= @Id )

 end
 ------------
 else
 begin




  update [CRM_1551_Analitics].[dbo].[Assignments]
   set [assignment_state_id]=5
   ,[AssignmentResultsId]=3
   ,[AssignmentResolutionsId]=3
   ,edit_date = GETUTCDATE()
   ,user_edit_id = @user_edit_id
  ,[LogUpdated_Query] = N'Button_Nadiishlo_NeVKompetentcii_Row44'
   where Id=@Id


   update [CRM_1551_Analitics].[dbo].[AssignmentConsiderations]
  set [assignment_result_id]=3 
  ,[assignment_resolution_id]=3 
  ,edit_date = GETUTCDATE()
  ,user_edit_id = @user_edit_id
--   where assignment_id=@Id
  where Id = ( select current_assignment_consideration_id from Assignments where Id= @Id )




    INSERT INTO [dbo].[Assignments]
           ([question_id]
           ,[assignment_type_id]
           ,[registration_date]
        --   ,[transfer_date]
           ,[assignment_state_id]
           ,[state_change_date]
           ,[organization_id]
           ,[executor_organization_id]
           ,[main_executor]
           ,[execution_date]
           ,[user_id]
           ,[edit_date]
           ,[user_edit_id]
           ,AssignmentResultsId
           ,AssignmentResolutionsId
           ,[LogUpdated_Query])

    output inserted.Id into @output([Id])
    
      select ass.question_id
          ,ass.assignment_type_id
          ,GETUTCDATE()
        --   ,GETUTCDATE() --[transfer_date]
          ,1  --Зареєстровано
          ,GETUTCDATE()
          ,(select first_executor_organization_id from AssignmentConsiderations where Id = 
					(select current_assignment_consideration_id from Assignments where Id = @Id) )
          ,@executor_organization_id--@transfer_to_organization_id
          ,main_executor --main
        --   ,@new_execution_date
          ,ass.execution_date
          ,@user_edit_id
          ,GETUTCDATE()
          ,@user_edit_id
          ,1  --Очікує прийому в роботу
          ,null
          ,N'Button_Nadiishlo_NeVKompetentcii_Row96'
        from Assignments as ass where ass.id = @Id

      set @ass_id = (select top 1 [Id] from @output);
    delete from @output
    insert into dbo.AssignmentConsiderations
      (    [assignment_id]
           ,[consideration_date]
           ,[assignment_result_id]
           ,[assignment_resolution_id]
           ,[user_id]
           ,[edit_date]
           ,[user_edit_id]
           ,turn_organization_id
           ,[first_executor_organization_id])
          output inserted.Id into @output([Id])
       select @ass_id
           ,getutcdate()
           ,1  --Очікує прийому в роботу
           ,null
           ,@user_edit_id
           ,getutcdate()
           ,@user_edit_id
           ,null
           ,first_executor_organization_id
        from AssignmentConsiderations where Id = (select current_assignment_consideration_id from Assignments where Id = @Id)
        
    declare @con_id int;
    set @con_id = (select top 1 [Id] from @output);
        
    update Questions set last_assignment_for_execution_id = @ass_id 
        ,edit_date = GETUTCDATE()
	    ,user_edit_id = @user_edit_id
    where last_assignment_for_execution_id = @Id
    
        update Assignments set main_executor = 0,
                edit_date = GETUTCDATE(),
				user_edit_id = @user_edit_id
				where id = @Id
        update Assignments set [current_assignment_consideration_id] = @con_id,
                edit_date = GETUTCDATE(),
				user_edit_id = @user_edit_id
				where id = @ass_id

end

-- update [CRM_1551_Analitics].[dbo].[Assignments]
--   set [executor_organization_id]=@executor_organization_id
--   where id=@Id