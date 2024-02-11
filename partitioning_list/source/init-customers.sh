#!/bin/bash

# Hash partitioning
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d "$POSTGRES_DB"  <<-EOSQL
    
    CREATE TABLE customers (
        id serial, 
        firstname text, 
        lastname text,
        email text,
        country text,
        age smallint,
        date_created timestamp
    ) PARTITION BY LIST (country);

    CREATE TABLE customers_usa PARTITION OF customers
        FOR VALUES IN ('USA');

    CREATE TABLE customers_canada PARTITION OF customers
        FOR VALUES IN ('Canada');

    CREATE TABLE customers_uk PARTITION OF customers
        FOR VALUES IN ('UK');

    CREATE TABLE customers_germany PARTITION OF customers
        FOR VALUES IN ('Germany');

    INSERT INTO customers (firstname, lastname, email, country, age) VALUES ('Bastien', 'Goulet', 'test@uqar.ca', 'Canada', 24);
EOSQL