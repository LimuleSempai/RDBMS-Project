CREATE OR REPLACE FUNCTION calculate_black_scholes(
    IN stock_price numeric,
    IN strike_price numeric,
    IN time_to_expiration numeric,
    IN volatility numeric,
    IN risk_free_rate numeric,
    IN option_type varchar
)
RETURNS TABLE (option_price numeric)
AS $$
DECLARE
    d1 numeric;
    d2 numeric;
BEGIN
    d1 := (ln(stock_price / strike_price) + (risk_free_rate + power(volatility, 2) / 2) * time_to_expiration) / (volatility * sqrt(time_to_expiration));
    d2 := d1 - volatility * sqrt(time_to_expiration);

    IF option_type = 'call' THEN
        option_price := stock_price * cdf(d1) - strike_price * exp(-risk_free_rate * time_to_expiration) * cdf(d2);
    ELSIF option_type = 'put' THEN
        option_price := strike_price * exp(-risk_free_rate * time_to_expiration) * cdf(-d2) - stock_price * cdf(-d1);
    ELSE
        RAISE EXCEPTION 'Invalid option type. Use either ''call'' or ''put''.';
    END IF;

    RETURN NEXT;
END
$$ LANGUAGE plpgsql;

-- Create a simple test case
DO $$
DECLARE
    call_price numeric;
    put_price numeric;
BEGIN
    -- Test with sample values
    SELECT * INTO call_price FROM calculate_black_scholes(100, 100, 1, 0.2, 0.05, 'call');
    SELECT * INTO put_price FROM calculate_black_scholes(100, 100, 1, 0.2, 0.05, 'put');

    -- Display results
    RAISE NOTICE 'Call Option Price: %', call_price;
    RAISE NOTICE 'Put Option Price: %', put_price;
END
$$;

