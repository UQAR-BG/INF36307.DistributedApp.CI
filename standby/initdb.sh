#!/bin/bash
postgres -c config_file=/config/postgresql.conf

rm -rf /data/*

for N in 1 .. 5
do
    pg_basebackup -h $PRIMARY_HOSTNAME -p 5432 -U $REPLICATION_USER -w -D $PGDATA -Fp -Xs -R

    if [ $? -eq 0 ]
    then
        echo Replication started successfully
        exit 0
    fi

    sleep 3
done