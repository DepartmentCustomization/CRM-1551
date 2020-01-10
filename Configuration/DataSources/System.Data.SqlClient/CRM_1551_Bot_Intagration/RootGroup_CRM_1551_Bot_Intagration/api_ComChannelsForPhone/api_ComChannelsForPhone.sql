
--declare @phone_number nvarchar(15)=N'911';

  select Id, phone_number, chanel_id, chat_id, chat_is
  from [CommunicationChannelsForPhone]
  where phone_number=@phone_number