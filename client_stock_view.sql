CREATE OR REPLACE FUNCTION monte_carlo_simulation_fct(
    S0 numeric,
    mu numeric,
    sigma numeric,
    T numeric,
    r numeric,
    num_simulations int,
    num_steps int,
    K numeric,
    option_type varchar
)
RETURNS numeric AS $$
DECLARE
    opt_price numeric;
BEGIN
    CALL monte_carlo_simulation(S0, mu, sigma, T, r, num_simulations, num_steps, K, option_type, opt_price);
    RETURN opt_price;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION black_scholes_simulation_fct(
    S0 numeric,
    K numeric,
    T numeric,
    r numeric,
    sigma numeric,
    option_type varchar
)
RETURNS numeric AS $$
DECLARE
    opt_price numeric;
BEGIN
    CALL black_scholes_simulation(S0, K, T, r, sigma, option_type, opt_price);
    RETURN opt_price;
END;
$$ LANGUAGE plpgsql;

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
    ao.id AS option_id,
	monte_carlo_simulation_fct(s.stock_value, (SELECT AVG(stock_value) FROM stocks_historic sh WHERE sh.stock_id = s.id), (SELECT stddev(stock_value) FROM stocks_historic sh WHERE sh.stock_id = s.id), (EXTRACT(EPOCH from (ao.expiration - NOW())) / 3600 / 24 / 252), 0.05, 100, 100, ao.strike_price, ao.option_type) AS mc_opt_price,
	black_scholes_simulation_fct(s.stock_value, ao.strike_price, (EXTRACT(EPOCH from (ao.expiration - NOW())) / 3600 / 24 / 252), 0.05 , (SELECT stddev(stock_value) FROM stocks_historic sh WHERE sh.stock_id = s.id),  ao.option_type) AS bs_opt_price
	
FROM
    actual_options ao
JOIN
    stocks s ON ao.stock_id = s.id
JOIN
    wallet w ON ao.wallet_id = w.id
JOIN
    clients c ON w.client_id = c.id;
