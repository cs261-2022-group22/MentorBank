FROM postgres:latest
COPY ./schema.sql /docker-entrypoint-initdb.d/10-schema.sql
RUN chmod 777 /docker-entrypoint-initdb.d/10-schema.sql