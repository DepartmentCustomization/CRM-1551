DECLARE @date_now DATE = CONVERT(DATE, dateadd(DD, -1, GETUTCDATE()));

SELECT
    Id,
    Integral_indicator
FROM [dbo].[IntegralIndicator]
WHERE
    bot_poll_item_id IS NULL
    AND calc_date = 26
    AND bot_code = N'NPS';