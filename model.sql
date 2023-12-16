/* This file is the base file of the project containing the pricipal structure of the database */

DO $$
    BEGIN

        CREATE IF NOT EXIST TABLE stocks (
            id serial PRIMARY KEY,
            stock_name varchar UNIQUE,
            stock_value int
        );

        CREATE IF NOT EXIST TABLE stocks_historic (
            stock_id varchar UNIQUE REFERENCES (stocks.id),
            stock_value int,
            complete_date timestamp NOT NULL
        );

        CREATE IF NOT EXIST TABLE clients (
            id serial PRIMARY KEY,
            first_name varchar NOT NULL,
            last_name varchar NOT NULL,
            email varchar UNIQUE NOT NULL,
            phone_number varchar UNIQUE NOT NULL
        );

        CREATE IF NOT EXIST TABLE wallet (
            id serial PRIMARY KEY,
            client_id int UNIQUE REFERENCES (clients.id) ON DELETE RESTRICT,
            actions_number int DEFAULT(0)
        );

        CREATE IF NOT EXIST TABLE options (
            id serial PRIMARY KEY,
            stock_id int REFERENCES (stocks.id) ON DELETE RESTRICT,
            wallet_id int REFERENCES (wallet.id) ON DELETE RESTRICT,
            option_type varchar CHECK (otpion_type IN ('call','put')),
            strike_price int NOT NULL,
            expiration timestamp DEFAULT(NOW + '1 day')
        );

END $$