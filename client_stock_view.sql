-- Create a view to display option prices for each (client, stock) pair
CREATE OR REPLACE VIEW option_prices_view AS
SELECT
    c.id AS client_id,
    s.id AS stock_id,
    ao.id AS option_id,
    c.first_name || ' ' || c.last_name AS client_name,
    s.stock_name,
    ao.option_type,
    ao.strike_price,
    ao.expiration,
    ao.wallet_id
FROM
    actual_options as ao
JOIN
    stocks as s ON ao.stock_id = s.id
JOIN
    clients as c ON ao.wallet_id = c.id	
	
