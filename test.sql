/* file containing the data and the test of the projects */

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

        -- Insert 10 records into 'stocks_historic' table
        INSERT INTO stocks_historic (stock_id, stock_value, complete_date) VALUES
        (1, 105, '2023-01-01'),
        (2, 155, '2023-01-02'),
        (3, 205, '2023-01-03'),
        (4, 125, '2023-01-04'),
        (5, 185, '2023-01-05'),
        (6, 95, '2023-01-06'),
        (7, 135, '2023-01-07'),
        (8, 165, '2023-01-08'),
        (9, 115, '2023-01-09'),
        (10, 145, '2023-01-10');

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
        ('Henry', 'Moore', 'henry.moore@example.com', '012-345-6789'),
        ('Olivia', 'White', 'olivia.white@example.com', '234-567-8901');

        -- Insert 10 records into 'wallet' table
        INSERT INTO wallet (client_id, actions_number) VALUES
        (1, 5),
        (2, 8),
        (3, 12),
        (4, 3),
        (5, 7),
        (6, 10),
        (7, 2),
        (8, 15),
        (9, 6),
        (10, 9);

        -- Insert 10 records into 'options' table
        INSERT INTO options (stock_id, wallet_id, option_type, strike_price, expiration) VALUES
        (1, 1, 'call', 110, '2023-01-15'),
        (2, 2, 'put', 160, '2023-01-20'),
        (3, 3, 'call', 210, '2023-01-25'),
        (4, 4, 'put', 130, '2023-01-30'),
        (5, 5, 'call', 180, '2023-02-05'),
        (6, 6, 'put', 100, '2023-02-10'),
        (7, 7, 'call', 140, '2023-02-15'),
        (8, 8, 'put', 170, '2023-02-20'),
        (9, 9, 'call', 120, '2023-02-25'),
        (10, 10, 'put', 150, '2023-03-01');

END $$