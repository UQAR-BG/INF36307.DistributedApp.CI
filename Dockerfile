FROM postgres:15

RUN apt-get update \
    && apt-get install -y dos2unix

ARG PATH_TO_SCRIPTS

COPY ${PATH_TO_SCRIPTS}/config /config/
COPY ${PATH_TO_SCRIPTS}/archive /mnt/server/archive/
COPY --chmod=775 ${PATH_TO_SCRIPTS}/*.sh /docker-entrypoint-initdb.d/
COPY --chmod=600 ${PATH_TO_SCRIPTS}/.pgpass /home/postgres/

RUN dos2unix /docker-entrypoint-initdb.d/* \
    && apt-get --purge remove -y dos2unix \
    && rm -rf /var/lib/apt/lists/*

ENV PGPASSFILE=/home/postgres/.pgpass

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432

CMD ["postgres"]