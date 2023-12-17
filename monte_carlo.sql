CREATE OR REPLACE PROCEDURE brownian_motion(
    num_simulations int, 
    num_steps int, 
    dt numeric,
    OUT result numeric[]
)
AS $$
DECLARE
    wt numeric[];
BEGIN
    wt := ARRAY(SELECT ARRAY(SELECT SQRT(dt) * random() FROM generate_series(1, num_simulations)) FROM generate_series(1, num_steps));
    result := wt;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE monte_carlo_simulation(
    S0 numeric,
    mu numeric,
    sigma numeric,
    T numeric,
    r numeric,
    num_simulations int,
    num_steps int,
    K numeric,
    option_type varchar,
    OUT opt_price numeric
)
AS $$
DECLARE
    dt numeric;
    price_paths_array numeric[];
    payoffs numeric[];
    W_t_array numeric[];
BEGIN
    dt := T / num_steps;

    -- Initialize price_paths_array
    price_paths_array := ARRAY(SELECT ARRAY(SELECT 0 FROM generate_series(1, num_simulations)) FROM generate_series(1, num_steps + 1));

    -- REplace the first row by S0
    FOR i IN 1..num_simulations LOOP
		price_paths_array[1][i] := S0;
    END LOOP;

    -- Generate Brownian motion
    CALL brownian_motion(num_simulations, num_steps, dt, W_t_array);
    
    FOR t IN 1..num_steps+1 LOOP
        FOR i IN 1..num_simulations LOOP
    	    price_paths_array[t][i] := (price_paths_array[t-1][i] * EXP((mu - 0.5 * sigma^2) * dt + sigma * W_t_array[t-1][i]));
        END LOOP;
    END LOOP;
    
    IF option_type = 'call' THEN
        -- Calculate payoffs for call option
        payoffs := ARRAY(
            SELECT GREATEST(price_paths_array[num_steps + 1][i] - K, 0)::numeric
            FROM generate_series(1, num_simulations) AS i
        );
        -- Calculate option prices
        DECLARE
            flattened_payoffs numeric[];
        BEGIN
            flattened_payoffs := ARRAY(SELECT unnest(payoffs));
            opt_price := (SELECT AVG(value) FROM unnest(flattened_payoffs) AS value) * EXP(-r * T);
        END;

    ELSIF option_type = 'put' THEN
        -- Calculate payoffs for put option
        payoffs := ARRAY(
            SELECT GREATEST(K - price_paths_array[num_steps + 1][i], 0)::numeric
            FROM generate_series(1, num_simulations) AS i
        );
        -- Calculate option prices
        DECLARE
            flattened_payoffs numeric[];
        BEGIN
            flattened_payoffs := ARRAY(SELECT unnest(payoffs));
            opt_price := (SELECT AVG(value) FROM unnest(flattened_payoffs) AS value) * EXP(-r * T);
        END;

    ELSE
        RAISE EXCEPTION 'Option type not recognized.';

    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;