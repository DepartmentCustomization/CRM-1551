
USE [CRM_1551_Analitics]
/*
moderated
changed_status
changed_executor
changed_control_date
closed
*/


--changed_status
--declare @appeal_from_site_id int = 20
--declare @QuestionStateId int = 4

declare @Results 
TABLE   (ResponseText nvarchar(max))

declare @url_str varchar(1024)
      , @post_str varchar(8000)
set @url_str = 'https://1551-back.systems.media/webhook/ticket-progress'
declare @access_token nvarchar(max) = N'RE4zTTUwVFI1SWlxbWxvaDlDYUN2MndDT254TThxQWFFN0lJTE9zcHNxUFdQd1RMS1duZm1QRjJ0aEtYOWlsdg=='

declare @Object as int;
declare @ResponseText as varchar(8000);
declare @Body as varchar(8000);
	set @Body = N''
	delete from @Results
if (select count(1) from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] where Id = @appeal_from_site_id) > 0
begin
	if (select count(1) from [CRM_1551_Analitics].[dbo].[QuestionStates] where Id = @QuestionStateId) > 0
	begin
		select @Body = rtrim((
			select * 
			from (
					SELECT top 1 N'changed_status' as [action_code], 
						   Getdate() as [action_at],
						   [AppealsFromSite].[Id] as [appeal_from_site_id],
					       [AppealsFromSite].[ApplicantFromSiteId] as [applicant_from_site_id],
						   [Appeals].[registration_number] as [registration_number],
						   (select top 1 [QuestionStates].[name] from [CRM_1551_Analitics].[dbo].[QuestionStates] where [QuestionStates].[Id] = @QuestionStateId)  as  [question_state]
					FROM [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
					left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = [AppealsFromSite].[Appeal_Id]
					where [AppealsFromSite].[id] = @appeal_from_site_id
					) as result
					FOR JSON AUTO
					));
		end
		else
		begin
			select @Body = rtrim((
			select * 
			from (
					SELECT top 1 N'changed_status' as [action_code], 
						   Getdate() as [action_at],
						   [AppealsFromSite].[Id] as [appeal_from_site_id],
					       [AppealsFromSite].[ApplicantFromSiteId] as [applicant_from_site_id],
						   [Appeals].[registration_number] as [registration_number],
						   (select top 1 [QuestionStates].[name] from [CRM_1551_Analitics].[dbo].[QuestionStates] where [QuestionStates].[Id] = 1)  as  [question_state]
					FROM [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
					left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = [AppealsFromSite].[appeal_id]
					where [AppealsFromSite].[id] = @appeal_from_site_id
					) as result
					FOR JSON AUTO
					));
		end
end
else
begin
	if (select count(1) from [CRM_1551_Analitics].[dbo].[QuestionStates] where Id = @QuestionStateId) > 0
	begin
		select @Body = rtrim((
			select * 
			from (
					SELECT N'changed_status' as [action_code], 
						   getdate() as [action_at],
						   @appeal_from_site_id as [appeal_from_site_id],
					       123 as [applicant_from_site_id],
						   N'Test' as [registration_number],
						   (select top 1 [QuestionStates].[name] from [CRM_1551_Analitics].[dbo].[QuestionStates] where [QuestionStates].[Id] = @QuestionStateId)  as  [question_state]
					) as result
					FOR JSON AUTO
					));
	end
	else
	begin
		select @Body = rtrim((
			select * 
			from (
					SELECT N'changed_status' as [action_code], 
						   getdate() as [action_at],
						   @appeal_from_site_id as [appeal_from_site_id],
					       123 as [applicant_from_site_id],
						   N'Test' as [registration_number],
						   (select top 1 [QuestionStates].[name] from [CRM_1551_Analitics].[dbo].[QuestionStates] where [QuestionStates].[Id] = 1)   as  [question_state]
					) as result
					FOR JSON AUTO
					));
	end
end



	Exec sp_OACreate 'MSXML2.ServerXMLHTTP', @Object OUT;
	EXEC sp_OAMethod @Object, 'open', NULL, 'POST', @url_str, 'false'
	Exec sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'application/json'
	exec sp_OAMethod @Object, 'setRequestHeader', NULL, 'X-1551-Token', @access_token
	exec sp_OAMethod @Object, 'setRequestHeader', NULL, 'Accept', 'application/json, text/plain, */*'
	Exec sp_OAMethod @Object, 'send', null, @Body
	INSERT INTO @Results
	Exec sp_OAMethod @Object, 'responseText'--, @ResponseText OUTPUT
	Exec sp_OADestroy @Object

--	--------------------------
select ResponseText FROM @Results
----select @Body
--	-------------------------
--	if (select ResponseText FROM @Results) = '"OK"'
--	begin
--		update [CRM_1551_Site_Integration].[dbo].[AppealsFromSite_History] set IsSendError = 0
--		where Id = @HistoryRowId
--	end
--	else
--	begin
--		update [CRM_1551_Site_Integration].[dbo].[AppealsFromSite_History] set IsSendError = 1
--		where Id = @HistoryRowId
--	end


--	update [CRM_1551_Site_Integration].[dbo].[AppealsFromSite_History] set IsSendLog = 1, DateSendLog = getdate()
--	where Id = @HistoryRowId 

--select @Body
