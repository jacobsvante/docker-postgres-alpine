-- noinspection SqlNoDataSourceInspection
CREATE USER docker WITH SUPERUSER PASSWORD 'docker';
CREATE EXTENSION adminpack;
CREATE EXTENSION dblink;
CREATE EXTENSION "uuid-ossp";
CREATE EXTENSION "pg_buffercache";
CREATE EXTENSION pgcrypto;
CREATE EXTENSION hstore;
CREATE EXTENSION plv8;

