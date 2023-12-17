-- Create a view to display option prices for each (client, stock) pair
CREATE OR REPLACE VIEW option_prices_view AS
SELECT
    ao.id AS option_id,
    c.id AS client_id,
    s.id AS stock_id,
    c.first_name || ' ' || c.last_name AS client_name,
    s.stock_name,
    ao.option_type,
    ao.strike_price,
    ao.expiration AS option_expiration,
    monte_carlo_simulation(ao.stock_value, ao.strike_price, 0.2, 1, 0.05, 1000).call_option_price AS monte_carlo_call_price,
    monte_carlo_simulation(ao.stock_value, ao.strike_price, 0.2, 1, 0.05, 1000).put_option_price AS monte_carlo_put_price,
    black_scholes_option_prices(ao.stock_value, ao.strike_price, 0.2, 1, 0.05).call_option_price AS black_scholes_call_price,
    black_scholes_option_prices(ao.stock_value, ao.strike_price, 0.2, 1, 0.05).put_option_price AS black_scholes_put_price
FROM
    actual_options ao
    JOIN stocks s ON ao.stock_id = s.id
    JOIN wallet w ON ao.wallet_id = w.id
    JOIN clients c ON w.client_id = c.id;

-- Sample queries using the view

-- Query 1: Get option prices for a specific client and stock
SELECT * FROM option_prices_view WHERE client_id = 1 AND stock_id = 1;

-- Query 2: Get all option prices for a specific stock
SELECT * FROM option_prices_view WHERE stock_id = 2;

-- Query 3: Get all option prices for a specific client
SELECT * FROM option_prices_view WHERE client_id = 2;
