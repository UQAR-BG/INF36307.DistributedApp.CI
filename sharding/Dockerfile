FROM citusdata/citus

RUN apt-get update \
    && apt-get install -y dos2unix

ARG PATH_TO_SCRIPTS

COPY --chmod=775 ${PATH_TO_SCRIPTS}/*.sh /docker-entrypoint-initdb.d/

RUN dos2unix /docker-entrypoint-initdb.d/* \
    && apt-get --purge remove -y dos2unix \
    && rm -rf /var/lib/apt/lists/*