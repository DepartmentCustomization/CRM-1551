--declare @textHTML nvarchar(max)
--set @textHTML= N'<H1>Test</H1>' 


EXEC msdb.dbo.sp_send_dbmail 
    @profile_name='Notifications',
    @recipients='egorkatornado@gmail.com',
    @subject = 'Help',
    @body = @textHTML,
    @body_format = 'HTML'
