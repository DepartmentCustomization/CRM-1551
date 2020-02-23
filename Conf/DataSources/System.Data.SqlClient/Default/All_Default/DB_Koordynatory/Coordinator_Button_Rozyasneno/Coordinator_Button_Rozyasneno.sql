--declare @ids nvarchar(200)=N'1,2,3';
--declare @user nvarchar(128)=N'Вася';
--расспарсивание @ids в таблицу начало

-- наша входная строка с айдишниками
DECLARE @input_str NVARCHAR(max) = @ids+N',';
-- создаем таблицу в которую будем
-- записывать наши айдишники
DECLARE @table TABLE (id INT);
-- создаем переменную, хранящую разделитель
DECLARE @delimeter NVARCHAR(1) = ',';
-- определяем позицию первого разделителя
DECLARE @pos INT = charindex(@delimeter,@input_str);
-- создаем переменную для хранения
-- одного айдишника
DECLARE @id NVARCHAR(10);
WHILE (@pos != 0)
BEGIN
    -- получаем айдишник
    SET @id = SUBSTRING(@input_str, 1, @pos-1);
    -- записываем в таблицу
    INSERT INTO @table (id) VALUES(CAST(@id AS INT));
    -- сокращаем исходную строку на
    -- размер полученного айдишника
    -- и разделителя
    SET @input_str = SUBSTRING(@input_str, @pos+1, LEN(@input_str));
    -- определяем позицию след. разделителя
    SET @pos = CHARINDEX(@delimeter,@input_str);
END;

--select * from @table

--расспарсивание @ids в таблицу конец


declare @tabIds table (Id int)

--[AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''WasExplained '' and [AssignmentResolutions].code=N''Requires1551ChecksByTheController''
insert into @tabIds (Id)

select [Assignments].Id
from [Assignments]
inner join [AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
inner join [AssignmentResolutions] on [Assignments].AssignmentResolutionsId=[AssignmentResolutions].Id
inner join [AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
inner join [AssignmentResults] on [Assignments].AssignmentResultsId=[AssignmentResults].Id
where
[AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'OnCheck' and 
[AssignmentResults].code=N'WasExplained ' and [AssignmentResolutions].code=N'Requires1551ChecksByTheController'
and [Assignments].Id in (select Id from @table t)
  
  --select * from @tabIds



  --declare @t nvarchar(max)=N'

  update [dbo].[Assignments]
  set
    assignment_state_id = 5
    ,close_date = GETUTCDATE()
    ,AssignmentResultsId = 7
    ,AssignmentResolutionsId = 6
    ,edit_date = GETUTCDATE()
    ,LogUpdated_Query = N'Coordinator_Button_Rozyasneno_Row9' 
    ,user_edit_id = @user 
    ,[state_change_date] = GETUTCDATE()
  where Id in (select Id from @tabIds)
  
  /*
  update [CRM_1551_Analitics].[dbo].[AssignmentConsiderations]
  set 
   [assignment_result_id] = 7 
  ,[assignment_resolution_id] = 6 
  ,edit_date = GETUTCDATE()
  ,user_edit_id =@user
  where Id in ( select current_assignment_consideration_id from Assignments where Id in (select Id from @tabIds) )
  */
  
  UPDATE dbo.AssignmentRevisions
      SET
      assignment_resolution_id = 6
      ,control_result_id = 7
      ,control_type_id = 2
      ,control_date = GETUTCDATE()
      ,edit_date = GETUTCDATE()
      ,user_edit_id =@user
    WHERE assignment_consideration_іd IN (SELECT current_assignment_consideration_id  FROM dbo.Assignments  WHERE Id IN (select Id from @tabIds) )




--declare @ids nvarchar(200)=N'1,2,3';
  -- declare @t nvarchar(max)=N'

  -- update [dbo].[Assignments]
  -- set
  --   assignment_state_id = 5
  --   ,close_date = GETUTCDATE()
  --   ,AssignmentResultsId = 7
  --   ,AssignmentResolutionsId = 6
  --   ,edit_date = GETUTCDATE()
  --   ,LogUpdated_Query = N''Coordinator_Button_Rozyasneno_Row9''' +N'
  --   ,user_edit_id = N'''+ @user + N'''
  -- where Id in ( '+ @ids+N')'+ N'
  
  -- update [CRM_1551_Analitics].[dbo].[AssignmentConsiderations]
  -- set 
  --  [assignment_result_id] = 7 
  -- ,[assignment_resolution_id] = 6 
  -- ,edit_date = GETUTCDATE()
  -- ,user_edit_id = N'''+ @user + N'''
  -- where Id in ( select current_assignment_consideration_id from Assignments where Id in ('+@Ids+N') )

  
  -- UPDATE dbo.AssignmentRevisions
  --     SET
  --     assignment_resolution_id = 6
  --     ,control_result_id = 7
  --     ,control_type_id = 2
  --     ,control_date = GETUTCDATE()
  --     ,edit_date = GETUTCDATE()
  --     ,user_edit_id = N'''+ @user + N'''
  --   WHERE assignment_consideration_іd IN (SELECT current_assignment_consideration_id  FROM dbo.Assignments  WHERE Id IN ('+@Ids+N') )


  -- '

  -- exec (@t)