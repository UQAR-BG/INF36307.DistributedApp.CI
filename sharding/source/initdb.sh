#!/bin/bash
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d "$POSTGRES_DB"  <<-EOSQL
    CREATE USER $REPLICATION_USER WITH REPLICATION PASSWORD '$REPLICATION_USER_PASSWORD' LOGIN CONNECTION LIMIT 15;

    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO $REPLICATION_USER;

    GRANT CONNECT ON DATABASE $POSTGRES_DB TO $REPLICATION_USER;

    CREATE EXTENSION postgres_fdw;

    CREATE SERVER $PRIMARY_HOSTNAME FOREIGN DATA WRAPPER postgres_fdw
        OPTIONS (host '$PRIMARY_HOSTNAME', dbname '$POSTGRES_DB');

    CREATE TABLE customers (
        id serial, 
        firstname text, 
        lastname text,
        email text,
        country text,
        age smallint,
        date_created timestamp, 
    ) PARTITION BY RANGE (age);

    CREATE FOREIGN TABLE customer_child
        PARTITION OF customers
        FOR VALUES FROM (0) TO (12)
        SERVER $PRIMARY_HOSTNAME;

    CREATE FOREIGN TABLE customer_teenager
        PARTITION OF customers
        FOR VALUES FROM (12) TO (18)
        SERVER $PRIMARY_HOSTNAME;

    CREATE FOREIGN TABLE customer_youngadult
        PARTITION OF customers
        FOR VALUES FROM (18) TO (30)
        SERVER $PRIMARY_HOSTNAME;

    CREATE FOREIGN TABLE customer_adult
        PARTITION OF customers
        FOR VALUES FROM (30) TO (55)
        SERVER $PRIMARY_HOSTNAME;

    CREATE FOREIGN TABLE customer_elder
        PARTITION OF customers
        FOR VALUES FROM (55) TO (200)
        SERVER $PRIMARY_HOSTNAME;

    INSERT INTO customers (firstname, date_created, age) VALUES ('Vuyisile', CURRENT_TIMESTAMP, 35);

EOSQL