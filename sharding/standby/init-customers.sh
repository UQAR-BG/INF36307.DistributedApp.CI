#!/bin/bash

for partition in $CUSTOMER_PARTITIONS; do
    echo "CREATE TABLE ${partition.NAME} (
                id serial, 
                firstname text, 
                lastname text,
                email text,
                country text,
                age smallint,
                date_created timestamp, 
            );"
done | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d "$POSTGRES_DB"