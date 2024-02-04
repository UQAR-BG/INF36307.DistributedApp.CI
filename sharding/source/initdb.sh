#!/bin/bash

sleep 10

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d "$POSTGRES_DB"  <<-EOSQL
    CREATE USER $REPLICATION_USER WITH REPLICATION PASSWORD '$REPLICATION_USER_PASSWORD' LOGIN CONNECTION LIMIT 15;

    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO $REPLICATION_USER;

    GRANT CONNECT ON DATABASE $POSTGRES_DB TO $REPLICATION_USER;

    SELECT citus_set_coordinator_host('$PRIMARY_HOSTNAME', 5432);
    SELECT citus_add_node('node1', 5432);
    SELECT citus_add_node('node2', 5432);

    CREATE EXTENSION pg_stat_statements;

    CREATE TABLE customers (
        id serial, 
        firstname text, 
        lastname text,
        email text,
        country text,
        age smallint NOT NULL,
        date_created timestamp
    );

    SELECT create_distributed_table('customers', 'age');

    INSERT INTO customers (firstname, date_created, age) VALUES ('Vuyisile', CURRENT_TIMESTAMP, 35);
EOSQL