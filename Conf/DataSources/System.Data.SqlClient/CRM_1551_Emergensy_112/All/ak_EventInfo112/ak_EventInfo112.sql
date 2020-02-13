--DECLARE @event_id INT =1;

  SELECT e.Id, e.id [number], c.name category_name, e.[receipt_date]
  FROM [dbo].[Events] e
  LEFT JOIN [dbo].[Categories] c ON e.category_id=c.id
  WHERE e.id=@event_id