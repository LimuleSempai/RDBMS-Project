CREATE OR REPLACE PROCEDURE home_made_cdf(
  d numeric,
  OUT n numeric
)
AS $$
DECLARE
    s numeric;
    t numeric;
    y numeric;
BEGIN
    s := 1.0 / (1.0 + 0.2316419 * ABS(d));
    t := s * (0.319381530 + s * (-0.356563782 + s * (1.781477937 + s * (-1.821255978 + 1.330274429 * s))));
    y := exp(-0.5 * d^2) / 2.506628274631;

    IF d > 0 THEN
        n := 1.0 - y * t;
    ELSE
        n := y * t;
    END IF;
END;
$$ LANGUAGE plpgsql;

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
    n1 numeric;
    n2 numeric;
BEGIN
    -- Calculate d1 and d2
    d1 := (LN(S0 / K) + (r + POWER(sigma, 2) / 2) * T) / (sigma * SQRT(T));
    d2 := d1 - sigma * SQRT(T);

    IF option_type = 'call' THEN
        CALL home_made_cdf(d1, n1);
        CALL home_made_cdf(d2, n2);
        -- Calculate call option price
        opt_price := S0 * n1 - K * EXP(-r * T) * n2;

    ELSIF option_type = 'put' THEN
        CALL home_made_cdf(-d1, n1);
        CALL home_made_cdf(-d2, n2);
        -- Calculate put option price
        opt_price := K * EXP(-r * T) * n2 - S0 * n1;

    ELSE
        RAISE EXCEPTION 'Option type not recognized.';

    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;