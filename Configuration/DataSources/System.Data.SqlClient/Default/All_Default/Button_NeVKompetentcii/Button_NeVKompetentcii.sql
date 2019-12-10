

--declare @executor_organization_id int, @Id int, @user_edit_id nvarchar(128)

DECLARE @output TABLE (Id INT);
DECLARE @output_con TABLE (Id INT);
DECLARE @new_con INT;
DECLARE @ass_id INT;
DECLARE @result_id INT;
DECLARE @resolution_id INT;
DECLARE @current_consid INT;
DECLARE @ass_state_id  INT;
DECLARE @question_id INT
DECLARE @is_main_exec BIT

--якщо дане доручення дійсно є не в компетенції, то виконуєтся запит початок

if exists (select [Assignments].Id
from [Assignments]
inner join [AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
inner join [AssignmentResolutions] on [Assignments].AssignmentResolutionsId=[AssignmentResolutions].Id
inner join [AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
inner join [AssignmentConsiderations] on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
inner join [AssignmentResults] on [Assignments].AssignmentResultsId=[AssignmentResults].Id
where
[Assignments].Id=@Id and
[AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code<>N'Closed' and [AssignmentResults].code=N'NotInTheCompetence'
  and [AssignmentResolutions].name in (N'Повернуто в 1551', N'Повернуто в батьківську організацію') 
  and [AssignmentConsiderations].[turn_organization_id] is not null)

  begin


--при виборі одного й того самого виконався стан проставляти на зареєстровано
IF @executor_organization_id=(SELECT [executor_organization_id]
FROM [Assignments]
WHERE Id=@Id)
BEGIN



	UPDATE Assignments
SET [assignment_state_id]=1
			,edit_date = GETUTCDATE()
			,user_edit_id = @user_edit_id
			,[LogUpdated_Query] = N'Button_NeVKompetentcii_Row22'
WHERE Id=@Id
END

--

IF @executor_organization_id IS NOT NULL
BEGIN


	SELECT @ass_state_id  = assignment_state_id
	, @result_id = AssignmentResultsId
	, @resolution_id = AssignmentResolutionsId
	, @current_consid = current_assignment_consideration_id
	, @question_id = question_id
	FROM Assignments
	WHERE Id = @Id



	-- 3 Не в компетенції	NotInTheCompetence 
	-- 14 Повернуто в батьківську організацію	ReturnedToParentOrganization

	DECLARE @new_res INT
	DECLARE @new_resol INT


	IF @result_id = 3 AND @resolution_id = 14
	BEGIN
		IF (SELECT first_executor_organization_id
		FROM AssignmentConsiderations
		WHERE Id = @current_consid) = @executor_organization_id
		BEGIN



			SET @new_res  = 6
			-- 6 Повернуто виконавцю	ReturnedToTheArtist
			SET @new_resol = 3
			-- 3 Перенаправлено за належністю	RedirectedByAffiliation

			SET @executor_organization_id = (SELECT first_executor_organization_id
			FROM AssignmentConsiderations
			WHERE Id = @current_consid)

			UPDATE Assignments 
									SET 
									 AssignmentResultsId = @new_res
									,AssignmentResolutionsId = @new_resol
									,edit_date = GETUTCDATE()
									,user_edit_id = @user_edit_id
									,[LogUpdated_Query] = N'Button_NeVKompetentcii_Row62'
									 WHERE id = @Id

			UPDATE dbo.AssignmentConsiderations 
									SET	 
									consideration_date = GETUTCDATE()
									,assignment_result_id = @new_res
									,assignment_resolution_id = @new_resol
									,transfer_to_organization_id = @executor_organization_id
									,edit_date = GETUTCDATE()
									,user_edit_id = @user_edit_id
									 WHERE Id = @current_consid


			DELETE FROM @output_con
			INSERT INTO dbo.AssignmentConsiderations
				( [assignment_id]
				,[consideration_date]
				,[assignment_result_id]
				,[assignment_resolution_id]
				,[user_id]
				,[edit_date]
				,[user_edit_id]
				,[first_executor_organization_id]
				,create_date
				,transfer_date
				)
			output inserted.Id INTO @output_con([Id])
			VALUES
				( @Id
									, GETUTCDATE()
									, @new_res
									, @new_resol
									, @user_edit_id
									, GETUTCDATE()
									, @user_edit_id
									, @executor_organization_id
									, GETUTCDATE()
									, GETUTCDATE()
								)


			SET @new_con = (SELECT TOP (1)
				Id
			FROM @output_con)
			UPDATE [Assignments] SET current_assignment_consideration_id = @new_con 
			,[edit_date]=GETUTCDATE()
			WHERE Id = @Id



		END
			ELSE
				-- 1 Очікує прийому в роботу	WaitingForWork
				-- 3 Перенаправлено за належністю	RedirectedByAffiliation
				-- if @result_id = 1 and @resolution_id = 3
			BEGIN

			SET @new_res  = 1
			-- 1 Очікує прийому в роботу	WaitingForWork
			SET @new_resol  = 3
			-- 3 Перенаправлено за належністю	RedirectedByAffiliation


			UPDATE Assignments 
						SET 
						 AssignmentResultsId = @new_res
						,AssignmentResolutionsId = @new_resol
						,edit_date = GETUTCDATE()
						,user_edit_id = @user_edit_id
						,executor_organization_id = @executor_organization_id
						,[LogUpdated_Query] = N'Button_NeVKompetentcii_Row121'
						 WHERE id = @Id

			UPDATE dbo.AssignmentConsiderations 
					SET	
						 consideration_date = GETUTCDATE()
						,assignment_result_id = @new_res
						,assignment_resolution_id = @new_resol
						,transfer_to_organization_id = @executor_organization_id
						,edit_date = GETUTCDATE()
						,user_edit_id = @user_edit_id
					 WHERE Id = @current_consid


			DELETE FROM @output_con;

			INSERT INTO dbo.AssignmentConsiderations
				( [assignment_id]
				,[consideration_date]
				,[assignment_result_id]
				,[assignment_resolution_id]
				,[user_id]
				,[edit_date]
				,[user_edit_id]
				,turn_organization_id
				,[first_executor_organization_id]
				,[create_date])
			output inserted.Id INTO @output_con([Id])
			SELECT @id
						   , getutcdate()
						   , @new_res
						   , @new_resol
						   , @user_edit_id
						   , getutcdate()
						   , @user_edit_id
						   , NULL
						   , @executor_organization_id
						   , getutcdate()
			FROM AssignmentConsiderations
			WHERE Id = @current_consid


			SET @new_con = ( SELECT TOP(1)
				Id
			FROM @output_con)
			UPDATE [Assignments] SET current_assignment_consideration_id = @new_con 
			,[edit_date]=getutcdate()
			WHERE Id = @Id
		-- @ass_id


		END
	END

	-- 1551
	IF @result_id = 3 AND @resolution_id = 1
	BEGIN
		IF (SELECT first_executor_organization_id
		FROM AssignmentConsiderations
		WHERE Id = @current_consid) = @executor_organization_id
		BEGIN
			SET @new_res  = 6
			-- 6 Повернуто виконавцю	ReturnedToTheArtist
			SET @new_resol = 3
			-- 3 Перенаправлено за належністю	RedirectedByAffiliation
			SET @executor_organization_id = (SELECT first_executor_organization_id
			FROM AssignmentConsiderations
			WHERE Id = @current_consid)


			-- закрываем Ревижн, + новый AssignmentConsiderations на того же самого исполнителя.
			UPDATE AssignmentRevisions 
								SET [assignment_resolution_id] = @new_resol
									,organization_id = @executor_organization_id
								-- 	,[control_comment] = @control_comment
								-- 	,[rework_counter] = @rework_counter_count
									,[edit_date] = getutcdate()
									,[user_edit_id] = @user_edit_id
									,control_result_id = @new_resol
									,control_date = GETUTCDATE()
								WHERE assignment_consideration_іd = @current_consid

			UPDATE Assignments 
								SET
								 AssignmentResultsId = @new_res -- Какие результат и резолучия должны быть????
								,AssignmentResolutionsId = @new_resol
								,edit_date = GETUTCDATE()
								,user_edit_id = @user_edit_id
								,[LogUpdated_Query] = N'Button_NeVKompetentcii_Row189'
								 WHERE id = @Id

			DELETE FROM @output_con
			INSERT INTO dbo.AssignmentConsiderations
				( [assignment_id]
				,[consideration_date]
				,[assignment_result_id]
				,[assignment_resolution_id]
				,[user_id]
				,[edit_date]
				,[user_edit_id]
				,[first_executor_organization_id]
				,create_date
				,transfer_date
				)
			output inserted.Id INTO @output_con([Id])
			VALUES( @Id
									, GETUTCDATE()
									, @new_res
									, @new_resol
									, @user_edit_id
									, GETUTCDATE()
									, @user_edit_id
									, @executor_organization_id
									, GETUTCDATE()
									, GETUTCDATE()
								   )

			SET @new_con = (SELECT TOP (1)
				Id
			FROM @output_con)
			UPDATE [Assignments] SET current_assignment_consideration_id = @new_con
			,[edit_date]=getutcdate()
			 WHERE Id = @Id

		END
		ELSE
		BEGIN
			SET @new_res  = 3
			-- 3 Не в компетенції	NotInTheCompetence
			SET @new_resol = 3
			-- 3 Перенаправлено за належністю	RedirectedByAffiliation


			--закрываем старое  Assignments и AssignmentConsiderations и AssignmentRevisions
			UPDATE Assignments 
								SET 
								 /*main_executor = 0
								,*/close_date = getutcdate()
								,AssignmentResultsId = @new_res
								,AssignmentResolutionsId = @new_resol
								,edit_date = GETUTCDATE()
								,user_edit_id = @user_edit_id
								,assignment_state_id = 5
								,[LogUpdated_Query] = N'Button_NeVKompetentcii_Row237'
								 WHERE id = @Id

			UPDATE dbo.AssignmentConsiderations 
							SET	consideration_date = GETUTCDATE()
								,assignment_result_id = @new_res
								,assignment_resolution_id = @new_resol
								,transfer_to_organization_id = @executor_organization_id
								,edit_date = GETUTCDATE()
								,user_edit_id = @user_edit_id
							 WHERE Id=@current_consid
			-- assignment_id = @Id

			UPDATE AssignmentRevisions 
								SET [assignment_resolution_id] = @new_resol
									,organization_id = @executor_organization_id
								-- 	,[control_comment] = @control_comment
								-- 	,[rework_counter] = @rework_counter_count
									,[edit_date] = getutcdate()
									,[user_edit_id] = @user_edit_id
									,control_result_id = @new_resol
									,control_date = GETUTCDATE()
								WHERE assignment_consideration_іd = @current_consid

			DELETE FROM @output;
			DELETE FROM @output_con;



			-- if 	(select count(1) from Assignments with (nolock) where question_id = (select question_id from Assignments with (nolock) where Id = @Id)
			--  and executor_organization_id = @executor_organization_id) = 0
			IF NOT EXISTS (SELECT 1
			FROM Assignments
			WHERE question_id = @question_id AND executor_organization_id = @executor_organization_id)
						BEGIN
				-- кк

				DECLARE @oldAss_questionId INT = (SELECT ass.question_id
				FROM Assignments AS ass
				WHERE ass.id = @Id)

				DECLARE @tested_transfer INT
				DECLARE @ass_id_for_main INT
				EXEC [dbo].Check_transfer_organizations @Id, @executor_organization_id, @tested_transfer output, @ass_id_for_main output

				IF @tested_transfer = 0
									BEGIN
					-- создаем новое Assignments и AssignmentConsiderations
					INSERT INTO [dbo].[Assignments]
						([question_id]
						,[assignment_type_id]
						,[registration_date]
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
						,LogUpdated_Query)
					output inserted.Id INTO @output([Id])
					SELECT ass.question_id
												  , ass.assignment_type_id
												  , GETUTCDATE()
												  , 1	--Зареєстровано
												  , GETUTCDATE()
												  --,(select first_executor_organization_id from AssignmentConsiderations where Id=@current_consid)
												  , @executor_organization_id
												  , @executor_organization_id
												--   ,1 --main
												  , main_executor
												  , ass.execution_date
												  , @user_edit_id
												  , GETUTCDATE()
												  , @user_edit_id
												  , 1	--Очікує прийому в роботу
												  , NULL
												  , N'Button_NeVKompetentcii__Row335'
					FROM Assignments AS ass
					WHERE ass.id = @Id

					SET @ass_id = (SELECT TOP 1
						[Id]
					FROM @output);

					INSERT INTO dbo.AssignmentConsiderations
						( [assignment_id]
						,[consideration_date]
						,[assignment_result_id]
						,[assignment_resolution_id]
						,[user_id]
						,[edit_date]
						,[user_edit_id]
						,turn_organization_id
						,[first_executor_organization_id]
						--    ,[short_answer]
						,create_date)
					output inserted.Id INTO @output_con([Id])
					SELECT @ass_id
												   , getutcdate()
												   , 1	--Очікує прийому в роботу
												   , NULL
												   , @user_edit_id
												   , getutcdate()
												   , @user_edit_id
												   , NULL
												--   ,first_executor_organization_id
												   , @executor_organization_id
												--    ,@short_answer
												   , getutcdate()
					FROM AssignmentConsiderations
					WHERE Id = (SELECT current_assignment_consideration_id
					FROM Assignments
					WHERE Id = @Id)

					--  проверка если это главное доручення то меняем в Вопросе last_assignment_for_execution_id
					/*if (select main_executor from Assignments where Id = @Id) = 1
											begin
											
												update Questions set 
													last_assignment_for_execution_id = @ass_id,
													edit_date = GETUTCDATE(),
													user_edit_id = @user_edit_id
											where last_assignment_for_execution_id = @Id
											end*/
					IF (SELECT main_executor
					FROM Assignments WITH (nolock)
					WHERE Id = @Id) = 1
											BEGIN
						IF object_id('tempdb..#temp_Questions') IS NOT NULL DROP TABLE #temp_Questions
						CREATE TABLE #temp_Questions
						(
							QuestionId INT
						)
						INSERT INTO #temp_Questions
							(QuestionId)
						SELECT Id
						FROM Questions WITH (nolock)
						WHERE last_assignment_for_execution_id = @Id

						UPDATE  Questions SET 
														last_assignment_for_execution_id = @ass_id,
														edit_date = GETUTCDATE(),
														user_edit_id = @user_edit_id
												WHERE Id IN (SELECT QuestionId
						FROM #temp_Questions)
					END



					SET @new_con = ( SELECT TOP(1)
						Id
					FROM @output_con)
					UPDATE [Assignments] SET main_executor = 0,
																	[LogUpdated_Query] = N'Button_NeVKompetentcii__Row379' 
											WHERE Id = @Id
					UPDATE [Assignments] SET current_assignment_consideration_id = @new_con,
																	[LogUpdated_Query]= N'Button_NeVKompetentcii__Row382'
																	,edit_date = GETUTCDATE()
											WHERE Id = @ass_id
				END
										ELSE -- if @tested_transfer = 1
										BEGIN
					UPDATE [Assignments] SET 
												main_executor = 1,
												[LogUpdated_Query] = N'Button_NeVKompetentcii__Row389',
												edit_date = getutcdate(),
												user_edit_id = @user_edit_id 
											WHERE Id = @ass_id_for_main

					UPDATE Questions 
												SET last_assignment_for_execution_id = @ass_id_for_main,
													edit_date = GETUTCDATE(),
													user_edit_id = @user_edit_id
												WHERE Id = @question_id

					UPDATE Assignments 	SET 
													 main_executor = 0
													,edit_date = GETUTCDATE()
													,user_edit_id = @user_edit_id
													,[LogUpdated_Query] = N'Button_NeVKompetentcii__Row404'
													WHERE id = @Id

				END
			END  -- кк
						ELSE
						BEGIN
				-- 		update [Assignments] set main_executor = 0,[LogUpdated_Query] = N'Button_NeVKompetentcii__Row356' where Id = @Id
				SELECT @is_main_exec  = main_executor
				FROM Assignments
				WHERE Id = @Id

				DECLARE @New_Ass INT = (SELECT TOP 1
					Id
				FROM Assignments WITH (nolock)
				WHERE question_id = (SELECT question_id
					FROM Assignments WITH (nolock)
					WHERE Id = @Id) AND executor_organization_id = @executor_organization_id)

				IF 	(SELECT count(1)
				FROM Assignments
				WHERE question_id = (SELECT question_id
					FROM Assignments
					WHERE Id = @Id)
					AND executor_organization_id = @executor_organization_id AND AssignmentResultsId = 3 AND AssignmentResolutionsId = 3) > 0
								BEGIN
					UPDATE	[Assignments] 
										  --set   main_executor = 1,
										  SET   main_executor = @is_main_exec,
												[AssignmentResultsId] = 1,
												[assignment_state_id] = 1,
												[AssignmentResolutionsId] = NULL,
												[LogUpdated_Query] = N'Button_NeVKompetentcii__Row365',
												close_date = NULL,
												edit_date = getutcdate(),
												user_edit_id = @user_edit_id
										WHERE Id = @New_Ass


					INSERT INTO dbo.AssignmentConsiderations
						( [assignment_id]
						,[consideration_date]
						,[assignment_result_id]
						,[assignment_resolution_id]
						,[user_id]
						,[edit_date]
						,[user_edit_id]
						,turn_organization_id
						,[first_executor_organization_id]
						,[short_answer]
						,[create_date])
					output inserted.Id INTO @output_con([Id])
					SELECT @New_Ass
											   , getutcdate()
											   , 1	--Очікує прийому в роботу
											   , NULL
											   , @user_edit_id
											   , getutcdate()
											   , @user_edit_id
											   , NULL
											--   ,first_executor_organization_id
											   , @executor_organization_id
											   , [short_answer]
											   , getutcdate()
					FROM AssignmentConsiderations
					WHERE Id = @current_consid

					UPDATE [Assignments] SET main_executor = 0,[LogUpdated_Query] = N'Button_NeVKompetentcii_Row441' WHERE Id = @Id

					SET @new_con = ( SELECT TOP(1)
						Id
					FROM @output_con)
					UPDATE [Assignments] SET current_assignment_consideration_id = @new_con
					,edit_date = GETUTCDATE()
					 WHERE Id = @New_Ass
				END
								ELSE
								BEGIN
					SELECT @Id AS Id
					-- 		update [Assignments] set main_executor = 1,[LogUpdated_Query] = N'Button_NeVKompetentcii__Row397' where Id = @New_Ass

					UPDATE [Assignments] SET 
												main_executor = 1,
												[LogUpdated_Query] = N'Button_NeVKompetentcii__Row453',
												edit_date = getutcdate(),
												user_edit_id = @user_edit_id 
											WHERE Id = @New_Ass
					UPDATE [Assignments] SET 
												main_executor = 0, 
												[LogUpdated_Query] = N'Button_NeVKompetentcii__Row459',
												edit_date = getutcdate(),
												user_edit_id = @user_edit_id 
											WHERE question_id = @question_id AND Id <> @New_Ass

				END
			END
		END
	END
END

--якщо дане доручення дійсно є не в компетенції, то виконуєтся запит кінець
end

/* 02-10-2019
--declare @executor_organization_id int, @Id int, @user_edit_id nvarchar(128)

declare @output table (Id int);
declare @output_con table (Id int);
declare @new_con int;
declare @ass_id int;
declare @result_id int;
declare @resolution_id int;
declare @current_consid int;
declare @ass_state_id  int;
declare @question_id int
declare @is_main_exec bit


--при виборі одного й того самого виконався стан проставляти на зареєстровано
if @executor_organization_id=(select [executor_organization_id]
  from [Assignments]
  where Id=@Id)
begin



update Assignments
set [assignment_state_id]=1
			,edit_date = GETUTCDATE()
			,user_edit_id = @user_edit_id
			,[LogUpdated_Query] = N'Button_NeVKompetentcii_Row22'
where Id=@Id
end

--

if @executor_organization_id is not null
begin


	select @ass_state_id  = assignment_state_id
	, @result_id = AssignmentResultsId
	, @resolution_id = AssignmentResolutionsId
	, @current_consid = current_assignment_consideration_id
	,@question_id = question_id 
	from Assignments where Id = @Id

	

     -- 3 Не в компетенції	NotInTheCompetence 
	-- 14 Повернуто в батьківську організацію	ReturnedToParentOrganization

	declare @new_res int
	declare @new_resol int


	IF @result_id = 3 and @resolution_id = 14
	BEGIN
		if (select first_executor_organization_id from AssignmentConsiderations where Id = @current_consid) = @executor_organization_id
		begin



						set @new_res  = 6 -- 6 Повернуто виконавцю	ReturnedToTheArtist
						set @new_resol = 3 -- 3 Перенаправлено за належністю	RedirectedByAffiliation

							set @executor_organization_id = (select first_executor_organization_id from AssignmentConsiderations where Id = @current_consid)

							update Assignments 
									set 
									 AssignmentResultsId = @new_res
									,AssignmentResolutionsId = @new_resol
									,edit_date = GETUTCDATE()
									,user_edit_id = @user_edit_id
									,[LogUpdated_Query] = N'Button_NeVKompetentcii_Row62'
									 where id = @Id

							update dbo.AssignmentConsiderations 
									set	 
									consideration_date = GETUTCDATE()
									,assignment_result_id = @new_res
									,assignment_resolution_id = @new_resol
									,transfer_to_organization_id = @executor_organization_id
									,edit_date = GETUTCDATE()
									,user_edit_id = @user_edit_id
									 where Id = @current_consid 
	
	
							delete from @output_con
							insert into dbo.AssignmentConsiderations
								(	 [assignment_id]
									,[consideration_date]
									,[assignment_result_id]
									,[assignment_resolution_id]
									,[user_id]
									,[edit_date]
									,[user_edit_id]
									,[first_executor_organization_id]
									,create_date
									,transfer_date
								)
								output inserted.Id into @output_con([Id])
								values
								(	@Id
									,GETUTCDATE()
									,@new_res
									,@new_resol
									,@user_edit_id
									,GETUTCDATE()
									,@user_edit_id
									,@executor_organization_id
									,GETUTCDATE()
									,GETUTCDATE()
								)


							set @new_con = (select top (1) Id from @output_con)
							update [Assignments] set current_assignment_consideration_id = @new_con where Id = @Id



			end
			else
				-- 1 Очікує прийому в роботу	WaitingForWork
				-- 3 Перенаправлено за належністю	RedirectedByAffiliation
				-- if @result_id = 1 and @resolution_id = 3
			begin

				set @new_res  = 1 -- 1 Очікує прийому в роботу	WaitingForWork
				set @new_resol  = 3 -- 3 Перенаправлено за належністю	RedirectedByAffiliation


				update Assignments 
						set 
						 AssignmentResultsId = @new_res
						,AssignmentResolutionsId = @new_resol
						,edit_date = GETUTCDATE()
						,user_edit_id = @user_edit_id
						,executor_organization_id = @executor_organization_id
						,[LogUpdated_Query] = N'Button_NeVKompetentcii_Row121'
						 where id = @Id

				update dbo.AssignmentConsiderations 
					set	
						 consideration_date = GETUTCDATE()
						,assignment_result_id = @new_res
						,assignment_resolution_id = @new_resol
						,transfer_to_organization_id = @executor_organization_id
						,edit_date = GETUTCDATE()
						,user_edit_id = @user_edit_id
					 where Id = @current_consid 


				delete from @output_con;

				insert into dbo.AssignmentConsiderations
					(		[assignment_id]
						   ,[consideration_date]
						   ,[assignment_result_id]
						   ,[assignment_resolution_id]
						   ,[user_id]
						   ,[edit_date]
						   ,[user_edit_id]
						   ,turn_organization_id
						   ,[first_executor_organization_id]
						   ,[create_date])
					output inserted.Id into @output_con([Id])
					 select @id
						   ,getutcdate()
						   ,@new_res
						   ,@new_resol
						   ,@user_edit_id
						   ,getutcdate()
						   ,@user_edit_id
						   ,null
						   ,@executor_organization_id
						   ,getutcdate()
						from AssignmentConsiderations where Id = @current_consid

		
				set @new_con = ( select top(1) Id from @output_con)
				update [Assignments] set current_assignment_consideration_id = @new_con where Id = @Id -- @ass_id


			end
	END

	-- 1551
	IF @result_id = 3 and @resolution_id = 1
	BEGIN
		if (select first_executor_organization_id from AssignmentConsiderations where Id = @current_consid) = @executor_organization_id
		begin
			set @new_res  = 6 -- 6 Повернуто виконавцю	ReturnedToTheArtist
			set @new_resol = 3 -- 3 Перенаправлено за належністю	RedirectedByAffiliation
			set @executor_organization_id = (select first_executor_organization_id from AssignmentConsiderations where Id = @current_consid)


			-- закрываем Ревижн, + новый AssignmentConsiderations на того же самого исполнителя.
						update AssignmentRevisions 
								set [assignment_resolution_id] = @new_resol
									,organization_id = @executor_organization_id
								-- 	,[control_comment] = @control_comment
								-- 	,[rework_counter] = @rework_counter_count
									,[edit_date] = getutcdate()
									,[user_edit_id] = @user_edit_id
									,control_result_id = @new_resol
								where assignment_consideration_іd = @current_consid

						update Assignments 
								set
								 AssignmentResultsId = @new_res -- Какие результат и резолучия должны быть????
								,AssignmentResolutionsId = @new_resol
								,edit_date = GETUTCDATE()
								,user_edit_id = @user_edit_id
								,[LogUpdated_Query] = N'Button_NeVKompetentcii_Row189'
								 where id = @Id
		
						delete from @output_con
						insert into dbo.AssignmentConsiderations
							(		[assignment_id]
								   ,[consideration_date]
								   ,[assignment_result_id]
								   ,[assignment_resolution_id]
								   ,[user_id]
								   ,[edit_date]
								   ,[user_edit_id]
								   ,[first_executor_organization_id]
								   ,create_date
								   ,transfer_date
							)
							output inserted.Id into @output_con([Id])
							values( @Id
									,GETUTCDATE()
									,@new_res
									,@new_resol
									,@user_edit_id
									,GETUTCDATE()
									,@user_edit_id
									,@executor_organization_id
									,GETUTCDATE()
									,GETUTCDATE()
								   )

						set @new_con = (select top (1) Id from @output_con)
						update [Assignments] set current_assignment_consideration_id = @new_con where Id = @Id

		end
		else
		begin
			set @new_res  = 3 -- 3 Не в компетенції	NotInTheCompetence
			set @new_resol = 3 -- 3 Перенаправлено за належністю	RedirectedByAffiliation


			--закрываем старое  Assignments и AssignmentConsiderations и AssignmentRevisions
	 					update Assignments 
								set 
								 close_date = getutcdate()
								,AssignmentResultsId = @new_res
								,AssignmentResolutionsId = @new_resol
								,edit_date = GETUTCDATE()
								,user_edit_id = @user_edit_id
								,assignment_state_id = 5
								,[LogUpdated_Query] = N'Button_NeVKompetentcii_Row237'
								 where id = @Id

						update dbo.AssignmentConsiderations 
							set	consideration_date = GETUTCDATE()
								,assignment_result_id = @new_res
								,assignment_resolution_id = @new_resol
								,transfer_to_organization_id = @executor_organization_id
								,edit_date = GETUTCDATE()
								,user_edit_id = @user_edit_id
							 where Id=@current_consid -- assignment_id = @Id

						update AssignmentRevisions 
								set [assignment_resolution_id] = @new_resol
									,organization_id = @executor_organization_id
								-- 	,[control_comment] = @control_comment
								-- 	,[rework_counter] = @rework_counter_count
									,[edit_date] = getutcdate()
									,[user_edit_id] = @user_edit_id
									,control_result_id = @new_resol
								where assignment_consideration_іd = @current_consid

						delete from @output;
						delete from @output_con;



						if 	(select count(1) from Assignments with (nolock) where question_id = (select question_id from Assignments with (nolock) where Id = @Id)
								 and executor_organization_id = @executor_organization_id) = 0
						begin

						


declare @oldAss_questionId int = (select ass.question_id
								  from Assignments as ass where ass.id = @Id)

								-- создаем новое Assignments и AssignmentConsiderations
										INSERT INTO [dbo].[Assignments]
											 ([question_id]
											 ,[assignment_type_id]
											 ,[registration_date]
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
											 ,LogUpdated_Query)
											output inserted.Id into @output([Id])
											select ass.question_id
											  ,ass.assignment_type_id
											  ,GETUTCDATE()
											  ,1	--Зареєстровано
											  ,GETUTCDATE()
											  --,(select first_executor_organization_id from AssignmentConsiderations where Id=@current_consid)
											  ,@executor_organization_id
											  ,@executor_organization_id
											--   ,1 --main
											  ,main_executor
											  ,ass.execution_date
											  ,@user_edit_id
											  ,GETUTCDATE()
											  ,@user_edit_id
											  ,1	--Очікує прийому в роботу
											  ,null
											  ,N'Button_NeVKompetentcii_Row306'
											from Assignments as ass where ass.id = @Id

										set @ass_id = (select top 1 [Id] from @output);

										insert into dbo.AssignmentConsiderations
										(		[assignment_id]
											   ,[consideration_date]
											   ,[assignment_result_id]
											   ,[assignment_resolution_id]
											   ,[user_id]
											   ,[edit_date]
											   ,[user_edit_id]
											   ,turn_organization_id
											   ,[first_executor_organization_id]
											   ,[create_date]
											   ,[short_answer])
										output inserted.Id into @output_con([Id])
										 select @ass_id
											   ,getutcdate()
											   ,1	--Очікує прийому в роботу
											   ,null
											   ,@user_edit_id
											   ,getutcdate()
											   ,@user_edit_id
											   ,null
											--   ,first_executor_organization_id
											   ,@executor_organization_id
											   ,getutcdate()
											   ,null
											

		
									-- надо поставить проверку если это главное доручення то меняем в Вопросе last_assignment_for_execution_id
									--if (select main_executor from Assignments with (nolock) where Id = @Id) = 1
									--begin
									--	update Questions set 
									--		last_assignment_for_execution_id = @ass_id,
									--		edit_date = GETUTCDATE(),
									--		user_edit_id = @user_edit_id
									-- where last_assignment_for_execution_id = @Id
									--end


									update dbo.Questions set last_assignment_for_execution_id = @ass_id,
															 edit_date = GETUTCDATE(),
															 user_edit_id = @user_edit_id
									 where Id = @oldAss_questionId


									set @new_con = ( select top(1) Id from @output_con)
									update [Assignments] set main_executor = 0,[LogUpdated_Query] = N'Button_NeVKompetentcii__Row347' where Id = @Id
									update [Assignments] set current_assignment_consideration_id = @new_con where Id = @ass_id
          
									select  @ass_id as Id
									-- 		execute define_status_Question @question_id
									-- exec pr_chech_in_status_assignment @Id, @result_id, @resolution_id
						end
						else
						begin	
				-- 		update [Assignments] set main_executor = 0,[LogUpdated_Query] = N'Button_NeVKompetentcii__Row356' where Id = @Id
				            select @is_main_exec  = main_executor from Assignments where Id = @Id
						
						declare @New_Ass int = (select top 1 Id from Assignments with (nolock) where question_id = (select question_id from Assignments with (nolock) where Id = @Id) and executor_organization_id = @executor_organization_id)
								
								if 	(select count(1) from Assignments where question_id = (select question_id from Assignments where Id = @Id)
									and executor_organization_id = @executor_organization_id and AssignmentResultsId = 3 and AssignmentResolutionsId = 3) > 0
								begin
										update	[Assignments] 
										  --set   main_executor = 1,
										  set   main_executor = @is_main_exec,
												[AssignmentResultsId] = 1,
												[assignment_state_id] = 1,
												[AssignmentResolutionsId] = null,
												[LogUpdated_Query] = N'Button_NeVKompetentcii__Row365',
												close_date = null,
												edit_date = getutcdate(),
												user_edit_id = @user_edit_id
										where Id = @New_Ass


								insert into dbo.AssignmentConsiderations
										(		[assignment_id]
											   ,[consideration_date]
											   ,[assignment_result_id]
											   ,[assignment_resolution_id]
											   ,[user_id]
											   ,[edit_date]
											   ,[user_edit_id]
											   ,turn_organization_id
											   ,[first_executor_organization_id]
											   ,[short_answer]
						                       ,[create_date])
										output inserted.Id into @output_con([Id])
										 select @New_Ass
											   ,getutcdate()
											   ,1	--Очікує прийому в роботу
											   ,null
											   ,@user_edit_id
											   ,getutcdate()
											   ,@user_edit_id
											   ,null
											--   ,first_executor_organization_id
											   ,@executor_organization_id
											   ,[short_answer]
											   ,getutcdate()
											from AssignmentConsiderations where Id = @current_consid
											
											update [Assignments] set main_executor = 0,[LogUpdated_Query] = N'Button_NeVKompetentcii_Row441' where Id = @Id

											set @new_con = ( select top(1) Id from @output_con)
											update [Assignments] set current_assignment_consideration_id = @new_con where Id = @New_Ass
								end
								else
								begin
										select  @Id as Id
								-- 		update [Assignments] set main_executor = 1,[LogUpdated_Query] = N'Button_NeVKompetentcii__Row397' where Id = @New_Ass
								
								        update [Assignments] set 
												main_executor = 1,
												[LogUpdated_Query] = N'Button_NeVKompetentcii__Row453',
												edit_date = getutcdate(),
												user_edit_id = @user_edit_id 
											where Id = @New_Ass
										update [Assignments] set 
												main_executor = 0, 
												[LogUpdated_Query] = N'Button_NeVKompetentcii__Row459',
												edit_date = getutcdate(),
												user_edit_id = @user_edit_id 
											where question_id = @question_id and Id <> @New_Ass
								
								end	
						end			
		end	
	END	
end
*/