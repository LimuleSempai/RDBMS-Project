DO $$
    BEGIN
        -- Insert 10 records into 'stocks' table
        INSERT INTO stocks (stock_name, stock_value) VALUES
        ('Stock1', 100),
        ('Stock2', 150),
        ('Stock3', 200),
        ('Stock4', 120),
        ('Stock5', 180),
        ('Stock6', 90),
        ('Stock7', 130),
        ('Stock8', 160),
        ('Stock9', 110),
        ('Stock10', 140);

		-- Insert 10 records into 'clients' table
        INSERT INTO clients (first_name, last_name, email, phone_number) VALUES
        ('John', 'Doe', 'john.doe@example.com', '123-456-7890'),
        ('Jane', 'Smith', 'jane.smith@example.com', '987-654-3210'),
        ('Bob', 'Johnson', 'bob.johnson@example.com', '456-789-0123'),
        ('Alice', 'Williams', 'alice.williams@example.com', '789-012-3456'),
        ('Charlie', 'Davis', 'charlie.davis@example.com', '012-345-6789'),
        ('Eva', 'Miller', 'eva.miller@example.com', '321-654-9870'),
        ('David', 'Brown', 'david.brown@example.com', '654-987-0123'),
        ('Grace', 'Anderson', 'grace.anderson@example.com', '987-012-3456'),
        ('Henry', 'Moore', 'henry.moore@example.com', '011-345-6789'),
        ('Olivia', 'White', 'olivia.white@example.com', '234-567-8901');

        -- Insert 10 records into 'stocks_historic' table
        INSERT INTO stocks_historic (stock_id, stock_value, complete_date) VALUES
        (1, 105, '2023-01-10'),
        (2, 155, '2023-01-10'),
        (3, 205, '2023-01-10'),
        (4, 125, '2023-01-10'),
        (5, 185, '2023-01-10'),
        (6, 95, '2023-01-10'),
        (7, 135, '2023-01-10'),
        (8, 165, '2023-01-10'),
        (9, 115, '2023-01-10'),
        (10, 145, '2023-01-10');

        -- Insert 10 records into 'options' table
        INSERT INTO actual_options (stock_id, wallet_id, option_type, strike_price) VALUES
        (1, 1, 'call', 110),
        (2, 2, 'put', 160),
        (3, 3, 'call', 21),
        (4, 4, 'put', 130),
        (5, 5, 'call', 180),
        (6, 6, 'put', 100),
        (7, 7, 'call', 140),
        (8, 8, 'put', 170),
        (9, 9, 'call', 120),
        (10, 10, 'put', 150);

        INSERT INTO actual_options (stock_id, wallet_id, option_type, strike_price, expiration) VALUES
        (9, 9, 'call', 120, NOW() + INTERVAL '1 minute'),
        (10, 10, 'put', 150, NOW() + INTERVAL '1 minute');
        
END $$;