/* file containing all the trigger for a good databas management */

-- Add 1 to the number of actions of a wallet when inserting an action
CREATE OR REPLACE FUNCTION update_wallet_actions()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE wallet
    SET actions_number = actions_number + 1
    WHERE id = NEW.wallet_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_wallet_actions_trigger
AFTER INSERT ON options
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
