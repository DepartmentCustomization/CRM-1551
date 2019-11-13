declare @output table (Id int)
declare @out_id int
INSERT INTO [dbo].[QuestionGroups]
           ([report_code],[name])
          output [inserted].[Id]
     VALUES ('Analitika', @groupName)
     set @out_id = (select top 1 Id from @output);


select @out_id as [Id]
return;