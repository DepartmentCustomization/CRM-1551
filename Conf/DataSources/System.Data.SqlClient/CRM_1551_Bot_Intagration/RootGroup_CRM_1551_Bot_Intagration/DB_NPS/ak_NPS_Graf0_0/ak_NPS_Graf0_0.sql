SELECT
    Id,
    Integral_indicator,
    CONVERT(DATE, calc_date) Calc_date
FROM
    [IntegralIndicator]
WHERE
    bot_poll_item_id IS NULL
    AND CONVERT(DATE, calc_date) BETWEEN CONVERT(DATE, @date_from)
    AND CONVERT(DATE, @date_to)
    AND bot_code = N'NPS'

ORDER BY CONVERT(DATE, calc_date);