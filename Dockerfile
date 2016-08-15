FROM alpine:edge
MAINTAINER Tim Haak <tim@haak.co>

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    TERM="xterm" \
    PGDATA="/data/db"

RUN apk -U upgrade && \
    mkdir -p /data && \
    apk -U add \
      git\
      tzdata \
      postgresql postgresql-client postgresql-contrib \
      python && \
    sed -E -i -e 's/\/var\/lib\/postgresql/\/data/' /etc/passwd && \
    rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/Africa/Johannesburg /etc/localtime && \
    git clone --depth 1 https://github.com/gregs1104/pgtune.git /pgtune && \
    apk del git && \
    rm -rf /tmp/src && \
    rm -rf /var/cache/apk/*

ADD start.sh /start.sh
ADD setupPost.sql /setupPost.sql
RUN chmod u+x  /start.sh

EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME ["/data"]

CMD ["/start.sh"]
