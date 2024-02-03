@ECHO OFF

:: This batch file creates all the necessary ressources 
docker container stop postgres-primary
docker container rm postgres-primary

docker container stop postgres-secondary
docker container rm postgres-secondary

docker container stop postgres-tertiary
docker container rm postgres-tertiary

docker volume rm postgres_primary_volume

docker volume create --name postgres_primary_volume -d local