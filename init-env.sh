#!/bin/bash

docker network create physical-replication-network
docker network create logical-replication-network
docker network create range-partitioning-network
docker network create hash-partitioning-network
docker network create list-partitioning-network

docker container stop postgres-primary
docker container rm postgres-primary

docker container stop postgres-standby-1
docker container rm postgres-standby-1

docker container stop postgres-standby-2
docker container rm postgres-standby-2

docker volume rm postgres_primary_volume

docker volume create --name postgres_primary_volume -d local