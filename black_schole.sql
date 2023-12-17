CREATE OR REPLACE PROCEDURE black_scholes_simulation(
    S0 numeric,
    K numeric,
    T numeric,
    r numeric,
    sigma numeric,
    option_type varchar,
    OUT opt_price numeric
)
AS $$
DECLARE
    d1 numeric;
    d2 numeric;
BEGIN
    -- Calculate d1 and d2
    d1 := (LN(S0 / K) + (r + POWER(sigma, 2) / 2) * T) / (sigma * SQRT(T));
    d2 := d1 - sigma * SQRT(T);

    IF option_type = 'call' THEN
        -- Calculate call option price
        opt_price := S0 * pg_normdist(d1) - K * EXP(-r * T) * pg_normdist(d2);
    ELSIF option_type = 'put' THEN
        -- Calculate put option price
        opt_price := K * EXP(-r * T) * pg_normdist(-d2) - S0 * pg_normdist(-d1);
    ELSE
        RAISE EXCEPTION 'Option type not recognized.';
    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;


-- Test case for the black_scholes_simulation procedure
DO $$
DECLARE
    opt_price_call numeric;
    opt_price_put numeric;
BEGIN
    -- Example parameters
    CALL black_scholes_simulation(100, 100, 1, 0.05, 0.2, 'call', opt_price_call);
    CALL black_scholes_simulation(100, 100, 1, 0.05, 0.2, 'put', opt_price_put);

    -- Display the results
    RAISE NOTICE 'Call Option Price: %', opt_price_call;
    RAISE NOTICE 'Put Option Price: %', opt_price_put;
END;
$$;
