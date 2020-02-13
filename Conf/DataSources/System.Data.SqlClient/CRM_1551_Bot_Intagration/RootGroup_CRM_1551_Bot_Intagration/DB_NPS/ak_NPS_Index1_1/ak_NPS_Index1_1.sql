DECLARE @date_now DATE = CONVERT(DATE, dateadd(DD, -1, GETUTCDATE()));

SELECT
    Id,
    Integral_indicator
FROM [dbo].[IntegralIndicator]
WHERE
    bot_poll_item_id=24
    AND calc_date = @date_now
    AND bot_code = N'NPS';