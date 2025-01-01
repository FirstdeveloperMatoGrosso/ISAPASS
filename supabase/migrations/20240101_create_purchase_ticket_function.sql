CREATE OR REPLACE FUNCTION purchase_ticket(event_id UUID, user_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Check if tickets are available
  IF (SELECT available_tickets FROM events WHERE id = event_id) <= 0 THEN
    RAISE EXCEPTION 'Sold out';
  END IF;

  -- Create ticket record
  INSERT INTO tickets (event_id, user_id)
  VALUES (event_id, user_id);

  -- Update available tickets count
  UPDATE events
  SET available_tickets = available_tickets - 1
  WHERE id = event_id;
END;
$$;
