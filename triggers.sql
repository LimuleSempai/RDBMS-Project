/* file containing all the trigger for a good databas management */

-- Add 1 to the number of actions of a wallet when inserting an action
CREATE OR REPLACE FUNCTION update_wallet_actions()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE wallet
    SET options_number = options_number + 1
    WHERE id = NEW.wallet_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_wallet_actions_trigger
AFTER INSERT ON actual_options
FOR EACH ROW
EXECUTE FUNCTION update_wallet_actions();

-- Create a wallet when inserting a new client
CREATE OR REPLACE FUNCTION create_wallet_for_new_client()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO wallet (client_id)
    VALUES (NEW.id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER create_wallet_trigger
AFTER INSERT ON clients
FOR EACH ROW
EXECUTE FUNCTION create_wallet_for_new_client();

-- Add the new stock value to the history when inserting or updating a stock
CREATE OR REPLACE FUNCTION update_stock_historic()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO stocks_historic (stock_id, stock_value, complete_date)
    VALUES (NEW.id, NEW.stock_value, NEW.complete_date);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_stock_historic_trigger
AFTER INSERT OR UPDATE ON stocks
FOR EACH ROW
EXECUTE FUNCTION update_stock_historic();

-- Create a function to prevent deletion of expired an option
CREATE OR REPLACE FUNCTION prevent_option_deletion()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Cannot delete expired option';
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to execute the function before delete on options
CREATE TRIGGER prevent_option_deletion_trigger
BEFORE DELETE ON expired_options
FOR EACH ROW
EXECUTE FUNCTION prevent_option_deletion();

-- Create a function to block deletion if expiration timestamp has not passed
CREATE OR REPLACE FUNCTION prevent_delete_if_not_expired()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.expiration >= CURRENT_TIMESTAMP THEN
        RAISE EXCEPTION 'Cannot delete option with expiration timestamp not passed.';
    END IF;  
    RETURN OLD;  
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to execute the function before delete on options
CREATE TRIGGER prevent_delete_if_not_expired_trigger
BEFORE DELETE ON actual_options
FOR EACH ROW
EXECUTE FUNCTION prevent_delete_if_not_expired();

CREATE OR REPLACE FUNCTION on_delete_if_expired()
RETURNS TRIGGER AS $$
BEGIN
    -- Subtract 1 from options_number in the corresponding wallet
    UPDATE wallet
    SET options_number = options_number - 1
    WHERE id = OLD.wallet_id;
    -- Insert into expired_options the expired option
    INSERT INTO expired_options (stock_id, wallet_id, option_type, strike_price, expired_on) VALUES
    (OLD.stock_id, OLD.wallet_id, OLD.option_type, OLD.strike_price, OLD.expiration);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to execute the function after delete on options
CREATE TRIGGER delete_if_expired_trigger
AFTER DELETE ON actual_options
FOR EACH ROW
EXECUTE FUNCTION on_delete_if_expired();

/*
marche pas encore
CREATE OR REPLACE FUNCTION calcul_option_price()
RETURNS TRIGGER AS $$
DECLARE
    opt_price numeric;
    opt_price2 numeric;
    S0 numeric;
    mu numeric;
    sigma numeric;
    T numeric;
BEGIN
    S0 := (SELECT stock_value FROM stocks WHERE stocks.id = NEW.stock_id);
    mu := (SELECT AVG(stock_value) FROM stocks_historic sh WHERE sh.stock_id = NEW.stock_id);
    sigma := (SELECT stddev(stock_value) FROM stocks_historic sh WHERE sh.stock_id = NEW.stock_id);
    T := (EXTRACT(EPOCH from (NEW.expiration - NOW())) / 3600 / 24 / 252); 
    
    CALL monte_carlo_simulation(S0, mu, sigma, T, NEW.risk_free, 100, 100, NEW.strike_price, NEW.option_type, opt_price);
    UPDATE actual_options SET monte_carlo_price = opt_price WHERE id = NEW.id;

    CALL black_scholes_simulation(S0, NEW.strike_price,  T, NEW.risk_free,  sigma,  NEW.option_type, opt_price2);
    UPDATE actual_options SET black_schole_price = opt_price2 WHERE id = NEW.id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER calcul_price_option
AFTER INSERT OR UPDATE ON actual_options
FOR EACH ROW
EXECUTE FUNCTION calcul_option_price();
*/