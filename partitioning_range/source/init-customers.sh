#!/bin/bash

# Declarative partitioning
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d "$POSTGRES_DB"  <<-EOSQL
    
    CREATE TABLE customers (
        id serial, 
        firstname text, 
        lastname text,
        email text,
        country text,
        age smallint,
        date_created timestamp, 
    ) PARTITION BY RANGE (age);

    CREATE TABLE customer_child PARTITION OF customers FOR VALUES FROM (1) TO (12);
    CREATE TABLE customer_teenager PARTITION OF customers FOR VALUES FROM (12) TO (18);
    CREATE TABLE customer_youngadult PARTITION OF customers FOR VALUES FROM (18) TO (30);
    CREATE TABLE customer_adult PARTITION OF customers FOR VALUES FROM (30) TO (60);
    CREATE TABLE customer_elder PARTITION OF customers FOR VALUES FROM (60) TO (200);

    INSERT INTO customers (firstname, date_created, age) VALUES ('Vuyisile', CURRENT_TIMESTAMP, 35);
    
EOSQL