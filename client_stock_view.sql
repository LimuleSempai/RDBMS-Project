-- Create a view to display option prices for each (client, stock) pair
CREATE OR REPLACE VIEW option_prices_view AS
SELECT
    c.id AS client_id,
    c.first_name || ' ' || c.last_name AS client_name,
    s.id AS stock_id,
    s.stock_name,
    ao.option_type,
    ao.strike_price,
    ao.expiration,
    ao.wallet_id,
    ao.id AS option_id
FROM
    actual_options ao
JOIN
    stocks s ON ao.stock_id = s.id
JOIN
    wallet w ON ao.wallet_id = w.id
JOIN
    clients c ON w.client_id = c.id;
