#!/bin/bash
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d "$POSTGRES_DB"  <<-EOSQL
    CREATE USER $REPLICATION_USER WITH REPLICATION PASSWORD '$REPLICATION_USER_PASSWORD' LOGIN CONNECTION LIMIT 15;

    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO $REPLICATION_USER;

    GRANT CONNECT ON DATABASE $POSTGRES_DB TO $REPLICATION_USER;

    CREATE TABLE customers (
        id serial, 
        firstname text, 
        lastname text,
        email text,
        country text,
        age smallint,
        date_created timestamp, 
    ) PARTITION BY RANGE (age);
    INSERT INTO customers (firstname, date_created) VALUES ('Vuyisile', CURRENT_TIMESTAMP);

    CREATE TABLE sales (
        id SERIAL PRIMARY KEY,
        product_id INTEGER,
        sales_date DATE,
        amount DECIMAL
    );
    INSERT INTO sales (product_id, sales_date, amount) VALUES (1, '2021-01-15', 100.0);

    CREATE PUBLICATION customers_publication FOR TABLE customers;
    CREATE PUBLICATION sales_publication FOR TABLE sales;
EOSQL