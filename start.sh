#!/bin/sh

PGDATA="/data/db"

mkdir -p /data/log/postgresql

chown -R postgres: /data

if [ ! -f /data/db/postgresql.conf ]; then

    su postgres -c "initdb -D ${PGDATA}"

    echo "host all  all    0.0.0.0/0  md5" >>/data/db/pg_hba.conf
    echo "listen_addresses='*'" >> /data/db/postgresql.conf

    sed -i "s/data_directory = '\/var\/lib\/postgresql\/9.4\/main'/data_directory = '\/data\/db\/main'/" /data/db/postgresql.conf
    sed -i "s/hba_file = '\/etc\/postgresql\/9.4\/main\/pg_hba.conf'/hba_file = '\/data\/config\/pg_hba.conf'/" /data/db/postgresql.conf
    sed -i "s/stats_temp_directory.*/stats_temp_directory = '\/data\/db\/9.4-main.pg_stat_tmp'/" /data/db/postgresql.conf

    echo "log_destination = 'stderr'" >> /data/db/postgresql.conf
    #echo "logging_collector = on" >> /data/db/postgresql.conf
    #echo "log_directory = '/data/log/postgresql'" >> /data/db/postgresql.conf
    #echo "log_rotation_age = 1d" >> /data/db/postgresql.conf
    #echo "log_rotation_size = 10MB" >> /data/db/postgresql.conf

    chown -R postgres: /data

    su postgres -c "/usr/bin/postgres -D /data/db" &
    sleep 1
    su postgres -c "psql < /setupPost.sql"
    /pgtune/pgtune -i /data/db/postgresql.conf  -o /data/db/postgresql.conf.new --type=Mixed
    mv /data/db/postgresql.conf /data/db/postgresql.conf.default
    mv /data/db/postgresql.conf.new /data/db/postgresql.conf
    sed -Ei -e 's/.*checkpoint_segments.*//' /data/db/postgresql.conf
    chown -R postgres: /data
    su postgres -c "pg_ctl stop  -D /data/db"
fi

su postgres -c "/usr/bin/postgres -D /data/db"
