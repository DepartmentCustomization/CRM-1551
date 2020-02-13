--DECLARE @event_id INT =1;

  SELECT e.Id, e.id [number], c.name category_name, e.[event_date], [longitude], [latitude]
  FROM [dbo].[Events] e
  LEFT JOIN [dbo].[Categories] c ON e.category_id=c.id;
