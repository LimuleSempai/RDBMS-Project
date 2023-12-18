/* This file is the base file of the project containing the pricipal structure of the database */

DO $$
    BEGIN

        CREATE TABLE IF NOT EXISTS stocks (
            id serial PRIMARY KEY,
            stock_name varchar UNIQUE,
            stock_value int,
            complete_date date DEFAULT(CURRENT_DATE),
            
            CHECK (complete_date = CURRENT_DATE)
        );

        CREATE TABLE IF NOT EXISTS stocks_historic (
            stock_id int REFERENCES stocks(id) ON UPDATE RESTRICT,
            stock_value int,
            complete_date date NOT NULL,

            UNIQUE (stock_id, complete_date)
        );

        CREATE TABLE IF NOT EXISTS clients (
            id serial PRIMARY KEY,
            first_name varchar NOT NULL,
            last_name varchar NOT NULL,
            email varchar UNIQUE NOT NULL,
            phone_number varchar UNIQUE NOT NULL,
            risk_adversity int CHECK (risk_adversity IN (1,2,3,4,5))
        );

        CREATE TABLE IF NOT EXISTS wallet (
            id serial PRIMARY KEY,
            client_id int UNIQUE REFERENCES clients(id) ON UPDATE RESTRICT ON DELETE RESTRICT ,
            options_number int DEFAULT(0)
        );

        CREATE TABLE IF NOT EXISTS actual_options (
            id serial PRIMARY KEY,
            stock_id int REFERENCES stocks(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
            wallet_id int REFERENCES wallet(id) ON DELETE RESTRICT,
            option_type varchar CHECK (option_type IN ('call','put')),
            strike_price int NOT NULL,
            expiration timestamp DEFAULT(NOW() + INTERVAL '1 day'),
            risk_free numeric,
            monte_carlo_price numeric DEFAULT(0),
            black_schole_price numeric DEFAULT(0)

            CHECK (expiration >= NOW())
        );

        CREATE TABLE IF NOT EXISTS expired_options (
            id serial PRIMARY KEY,
            stock_id int REFERENCES stocks(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
            wallet_id int REFERENCES wallet(id) ON DELETE RESTRICT,
            option_type varchar CHECK (option_type IN ('call','put')),
            strike_price int NOT NULL,
            expired_on timestamp ,

            CHECK (expired_on <= NOW())
        );
END $$