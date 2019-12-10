-- заглушка от дурака :) (повторное нажатие на кнопку зберегти питання) что бы нелетели полу пустые запросы
if (@Question_TypeId is null or @Question_TypeId = '') OR
    (@Question_Content is null or @Question_Content = '') 
    -- and     (@Question_OrganizationId is null or @Question_OrganizationId = '')
    BEGIN
      RETURN
    end

  declare @output table (Id int);
  declare @output2 table (Id int);
  declare @app_id int;
  declare @assign int;
declare @getdate datetime = getutcdate();
 
 
 insert into [dbo].[Questions] ([appeal_id]
      ,[registration_number]
      ,[registration_date]
      ,[receipt_date]
      ,[question_state_id]
      ,[control_date]
      ,[object_id]
      ,[object_comment]
      ,[organization_id]
      ,[application_town_id]
      ,[event_id]
      ,[question_type_id]
      ,[question_content]
      ,[answer_form_id]
      ,[answer_phone]
      ,[answer_post]
      ,[answer_mail]
      ,[user_id]
      ,[edit_date]
      ,[user_edit_id]
      ,[last_assignment_for_execution_id]
	  ,[entrance] -- art
	  ,[flat]) -- art
output [inserted].[Id] into @output (Id)	
select @AppealId
      ,@AppealNumber+N'/'+rtrim((select count(1) from [dbo].[Questions] where appeal_id = @AppealId)+1) /*[registration_number]*/
      ,getutcdate() /*[registration_date]*/
      ,getutcdate() /*[receipt_date]*/
      ,1 /*[question_state_id]*/
      
      --,dateadd(day,isnull((select  (isnull(execution_term,0)) /24 as execution_term from [QuestionTypes] where Id = @Question_TypeId),0),getutcdate()) /*[control_date]*/
      /*,(
							select  top 1
							case when dat1.[is_work] = 0 then dateadd(second,59,dateadd(minute,59,dateadd(hour,23,cast(dat2.execution_date as datetime))))
							else dateadd(second,59,dateadd(minute,59,dateadd(hour,23,cast(cast(@getdate + [QuestionTypes].[execution_term]/24 as date) as datetime)))) end as execut
							from [dbo].[QuestionTypes]
							left join  [dbo].[WorkDaysCalendar] as dat1 on dat1.[date] = cast((@getdate + [QuestionTypes].[execution_term]/24) as date)
							left join  [dbo].[WorkDaysCalendar] as dat2 on dat1.[execution_date] = dat2.[date]
							where [QuestionTypes].[id] = @Question_TypeId
						   )
						   */
	,@Question_ControlDate				   
      ,@Question_Building /*[object_id]*/
      ,NULL /*[object_comment]*/
      ,@Question_Organization /*[organization_id]*/
      ,NULL /*[application_town_id]*/
      ,@Question_EventId /*[event_id]*/
      ,@Question_TypeId /*[question_type_id]*/
      ,@Question_Content /*[question_content]*/
      ,@Question_AnswerType /*[answer_form_id]*/
      ,case when @Question_AnswerType = 2 then @Applicant_Phone end /*[answer_phone]*/
      ,case when @Question_AnswerType in (4, 5) then @Applicant_Building end /*[answer_post]*/
      ,case when @Question_AnswerType = 3 then @Applicant_Email end /*[answer_mail]*/
      ,@CreatedUser /*[user_id]*/
      ,getutcdate() /*edit_date*/
      ,@CreatedUser /*[user_edit_id]*/
      ,NULL /*last_assignment_for_execution_id*/
	  ,@entrance -- art
	  ,@flat -- art
	set @app_id = (select top 1 Id from @output)
	
	
-- 		insert into [dbo].[Assignments] ([question_id]
--       ,[assignment_type_id]
--       ,[registration_date]
--       ,[assignment_state_id]
--       ,[executor_organization_id]
--       ,[main_executor]
--       ,[user_id]
--       ,[edit_date]
--       ,[user_edit_id]
--       ,[AssignmentResultsId]
--       ,[AssignmentResolutionsId])
-- output [inserted].[Id] into @output2 (Id)
-- values (@app_id, /*[question_id]*/
-- 		1,	/*До виконання*/ /*[assignment_type_id]*/
-- 	   getutcdate(), /*[registration_date]*/
-- 	   1, /*[assignment_state_id]*/
-- 	   @Question_OrganizationId, /*[executor_organization_id]*/
--       1, /*[main_executor]*/
--       @CreatedUser, /*[user_id]*/
--       getutcdate(), /*[edit_date]*/
--       @CreatedUser, /*[user_edit_id]*/
--       1, /*Очікує прийому в роботу*//*[AssignmentResultsId]*/
--       NULL /*[AssignmentResolutionsId]*/
-- 		)
	
-- 	set @assign = (select top 1 Id from @output2)
	
	
  update [dbo].[Appeals] 
  set [applicant_id] = @applicant_id
  ,[edit_date]=getutcdate()
			  where [Id] = @AppealId	
			  
	exec [dbo].[sp_CreateAssignment] @app_id, @Question_TypeId, @Question_Building, @Question_Organization, @CreatedUser, @Question_ControlDate
	--@question_id int, @question_type_id int, @object_id int, 	@organization_execut int, @user_id nvarchar(128)