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
        RETURN OLD;
    ELSE
         -- Subtract 1 from options_number in the corresponding wallet
        UPDATE wallet
        SET options_number = options_number - 1
        WHERE id = OLD.wallet_id;
        INSERT INTO expired_options (stock_id, wallet_id, option_type, strike_price, expired_on) VALUES
        (OLD.stock_id, OLD.wallet_id, OLD.option_type, OLD.strike_price, OLD.expiration);
        RETURN NEW;
    END IF;
    
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to execute the function before delete on options
CREATE TRIGGER prevent_delete_if_not_expired_trigger
BEFORE DELETE ON actual_options
FOR EACH ROW
EXECUTE FUNCTION prevent_delete_if_not_expired();