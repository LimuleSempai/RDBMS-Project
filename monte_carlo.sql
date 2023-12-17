CREATE OR REPLACE PROCEDURE brownian_motion(
    num_simulations int, 
    num_steps int, 
    dt numeric,
    OUT result double precision[]
)
AS $$
DECLARE
    wt double precision[];
BEGIN
    wt := ARRAY(SELECT ARRAY(SELECT SQRT(dt) * random() FROM generate_series(1, num_simulations)) FROM generate_series(1, num_steps));
    result := wt;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE monte_carlo_simulation()    