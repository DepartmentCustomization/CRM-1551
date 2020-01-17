
USE [CRM_1551_Analitics]
/*
moderated
changed_status
changed_executor
changed_control_date
closed
*/


--declare @NotificationCode nvarchar(100) = N'moderated'
--declare @appeal_from_site_id int = 20

if (select count(1) from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] where Id = @appeal_from_site_id) > 0
begin
EXEC ('USE [CRM_1551_Site_Integration]; DISABLE TRIGGER trg_AppealsFromSite_History_ChangeAppealId  ON [CRM_1551_Site_Integration].[dbo].[AppealsFromSite];');



--ENABLE TRIGGER trg_AppealsFromSite_History_ChangeAppealId  ON [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
update [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] set appeal_id = NULL
where appeal_id = 5398260

update [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] set appeal_id = 5398260
where Id = @appeal_from_site_id

declare @Results 
TABLE   (ResponseText nvarchar(max))
declare @url_str varchar(1024)
      , @post_str varchar(8000)
set @url_str = 'https://1551-back.systems.media/webhook/ticket-progress'
declare @access_token nvarchar(max) = N'RE4zTTUwVFI1SWlxbWxvaDlDYUN2MndDT254TThxQWFFN0lJTE9zcHNxUFdQd1RMS1duZm1QRjJ0aEtYOWlsdg=='

declare @Object as int;
declare @ResponseText as varchar(8000);
declare @Body as varchar(8000);



DECLARE @HistoryRowId INT
DECLARE @HistoryRowCode NVARCHAR(200)
DECLARE @CURSOR CURSOR
SET @CURSOR  = CURSOR SCROLL
FOR
  select id,  ActionCode
  from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite_History]
  where Id in (31,29,28,27,26)
  and ActionCode = @NotificationCode
  order by DateSendLog
OPEN @CURSOR
FETCH NEXT FROM @CURSOR INTO @HistoryRowId, @HistoryRowCode
WHILE @@FETCH_STATUS = 0
BEGIN

	set @Body = N''
	delete from @Results

	if @HistoryRowCode = N'moderated'
	begin
		select @Body = rtrim((	
					  select * 
					  from (
					  SELECT [AppealsFromSite_History].[ActionCode] as [action_code], 
					  	   [AppealsFromSite_History].[ActionAt] as [action_at],
					  	   [AppealsFromSite].[Id] as [appeal_from_site_id],
					         [AppealsFromSite].[ApplicantFromSiteId] as [applicant_from_site_id],
					  	   [Appeals].[registration_number] as [registration_number],
						   [QuestionStates].[name] as  [question_state],
					  	   [AppealsFromSite_History].[QuestionControlDate] as [control_date],
					  	   [Organizations].[short_name] as [executor],
						   (select top 1 [QuestionTypes].[name] 
						    from [CRM_1551_Analitics].[dbo].[Appeals]
						    left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].appeal_id =  [Appeals].Id
							left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].id =  [Questions].[question_type_id]
							where [Appeals].Id in (select [appeal_id] from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite_History] where [id] = @HistoryRowId)
							) as [question_type]
					  FROM [CRM_1551_Site_Integration].[dbo].[AppealsFromSite_History]
					  left join [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] on [AppealsFromSite].[Appeal_Id] = [AppealsFromSite_History].appeal_id
					  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = [AppealsFromSite_History].[appeal_id]
					  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = [AppealsFromSite_History].[MainExecutorId]
					  left join [CRM_1551_Analitics].[dbo].[QuestionStates] on [QuestionStates].[Id] = [AppealsFromSite_History].[QuestionStateId]
					  where [AppealsFromSite_History].[id] = @HistoryRowId
					  ) as result
					  FOR JSON AUTO
					));
	end


	if @HistoryRowCode = N'changed_executor'
	begin
		select @Body = rtrim((	
					  select * 
					  from (
					  SELECT [AppealsFromSite_History].[ActionCode] as [action_code], 
					  	   [AppealsFromSite_History].[ActionAt] as [action_at],
					  	   [AppealsFromSite].[Id] as [appeal_from_site_id],
					         [AppealsFromSite].[ApplicantFromSiteId] as [applicant_from_site_id],
					  	   [Appeals].[registration_number] as [registration_number],
					  	   [Organizations].[short_name] as [executor]
					  FROM [CRM_1551_Site_Integration].[dbo].[AppealsFromSite_History]
					  left join [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] on [AppealsFromSite].[appeal_id] = [AppealsFromSite_History].appeal_id
					  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = [AppealsFromSite_History].[appeal_id]
					  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = [AppealsFromSite_History].[MainExecutorId]
					  where [AppealsFromSite_History].[id] = @HistoryRowId
					  ) as result
					  FOR JSON AUTO
					));
	end

	if @HistoryRowCode = N'changed_control_date'
	begin
		select @Body = rtrim((	
					  select * 
					  from (
					  SELECT [AppealsFromSite_History].[ActionCode] as [action_code], 
					  	   [AppealsFromSite_History].[ActionAt] as [action_at],
					  	   [AppealsFromSite].[Id] as [appeal_from_site_id],
					         [AppealsFromSite].[ApplicantFromSiteId],
					  	   [Appeals].[registration_number] as [registration_number],
					  	   [AppealsFromSite_History].[QuestionControlDate] as [control_date]
					  FROM [CRM_1551_Site_Integration].[dbo].[AppealsFromSite_History]
					  left join [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] on [AppealsFromSite].[appeal_id] = [AppealsFromSite_History].appeal_id
					  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = [AppealsFromSite_History].[appeal_id]
					  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = [AppealsFromSite_History].[MainExecutorId]
					  where [AppealsFromSite_History].[id] = @HistoryRowId
					  ) as result
					  FOR JSON AUTO
					));
	end

	if @HistoryRowCode = N'changed_status'
	begin
		select @Body = rtrim((
			select * 
			from (
					SELECT [AppealsFromSite_History].[ActionCode] as [action_code], 
						   [AppealsFromSite_History].[ActionAt] as [action_at],
						   [AppealsFromSite].[Id] as [appeal_from_site_id],
					       [AppealsFromSite].[ApplicantFromSiteId] as [applicant_from_site_id],
						   [Appeals].[registration_number] as [registration_number],
						   [QuestionStates].[name] as  [question_state]
					FROM [CRM_1551_Site_Integration].[dbo].[AppealsFromSite_History]
					left join [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] on [AppealsFromSite].[appeal_id] = [AppealsFromSite_History].appeal_id
					left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = [AppealsFromSite_History].[appeal_id]
					left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = [AppealsFromSite_History].[MainExecutorId]
					left join [CRM_1551_Analitics].[dbo].[QuestionStates] on [QuestionStates].[Id] = [AppealsFromSite_History].[QuestionStateId]
					where [AppealsFromSite_History].[id] = @HistoryRowId
					) as result
					FOR JSON AUTO
					));
	end

	if @HistoryRowCode = N'closed'
	begin
		select @Body = rtrim((
			select * 
			from (
					SELECT [AppealsFromSite_History].[ActionCode] as [action_code], 
						   [AppealsFromSite_History].[ActionAt] as [action_at],
						   [AppealsFromSite].[Id] as [appeal_from_site_id],
					       [AppealsFromSite].[ApplicantFromSiteId] as [applicant_from_site_id],
						   [Appeals].[registration_number] as [registration_number],
						   [QuestionStates].[name] as  [question_state]
					FROM [CRM_1551_Site_Integration].[dbo].[AppealsFromSite_History]
					left join [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] on [AppealsFromSite].[appeal_id] = [AppealsFromSite_History].appeal_id
					left join [CRM_1551_Analitics].[dbo].[Appeals] on [Appeals].[Id] = [AppealsFromSite_History].[appeal_id]
					left join [CRM_1551_Analitics].[dbo].[Organizations] on [Organizations].[Id] = [AppealsFromSite_History].[MainExecutorId]
					left join [CRM_1551_Analitics].[dbo].[QuestionStates] on [QuestionStates].[Id] = [AppealsFromSite_History].[QuestionStateId]
					where [AppealsFromSite_History].[id] = @HistoryRowId
					) as result
					FOR JSON AUTO
					));
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

	--------------------------
select ResponseText FROM @Results
--select @Body
	-------------------------
	if (select ResponseText FROM @Results) = '"OK"'
	begin
		update [CRM_1551_Site_Integration].[dbo].[AppealsFromSite_History] set IsSendError = 0
		where Id = @HistoryRowId
	end
	else
	begin
		update [CRM_1551_Site_Integration].[dbo].[AppealsFromSite_History] set IsSendError = 1
		where Id = @HistoryRowId
	end


	update [CRM_1551_Site_Integration].[dbo].[AppealsFromSite_History] set IsSendLog = 1, DateSendLog = getdate()
	where Id = @HistoryRowId 

select @Body
FETCH NEXT FROM @CURSOR INTO @HistoryRowId, @HistoryRowCode
END
CLOSE @CURSOR


EXEC ('USE [CRM_1551_Site_Integration]; ENABLE TRIGGER trg_AppealsFromSite_History_ChangeAppealId  ON [CRM_1551_Site_Integration].[dbo].[AppealsFromSite];');
end
else
begin
	/*
	select rtrim((
			select * 
			from (
					SELECT @appeal_from_site_id as [appeal_from_site_id]
					) as result
					FOR JSON AUTO
					))*/ select N'[{"executor": "КП \"Київпастранс\"", "action_at": "2019-06-24T13:12:17.400", "action_code": "changed_executor", "registration_number": "9-5170", "appeal_from_site_id":'+rtrim(@appeal_from_site_id)+' }]' as [ResponseText]
end