#!/bin/bash
postgres -c config_file=/config/postgresql.conf

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d "$POSTGRES_DB"  <<-EOSQL
    CREATE USER $REPLICATION_USER WITH REPLICATION PASSWORD '$REPLICATION_USER_PASSWORD' LOGIN CONNECTION LIMIT 15;

    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO $REPLICATION_USER;

    GRANT CONNECT ON DATABASE $POSTGRES_DB TO $REPLICATION_USER;

    CREATE TABLE customers (firstname text, customer_id serial, date_created timestamp);
    INSERT INTO customers (firstname, date_created) VALUES ('Vuyisile', CURRENT_TIMESTAMP);
EOSQL