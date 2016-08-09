#!/usr/bin/env bash
docker rm -f postgres
docker run -d -v /data/postgres:/data -p 5432:5432 --name postgres timhaak/postgres-alpine
