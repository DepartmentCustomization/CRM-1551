
--declare @phone_number nvarchar(15)=N'911';

  SELECT Id, phone_number, chanel_id, chat_id, chat_is
  FROM [dbo].[CommunicationChannelsForPhone]
  WHERE phone_number=@phone_number
  AND #filter_columns#
  #sort_columns#
 offset @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS only;
