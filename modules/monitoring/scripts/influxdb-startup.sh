#!/bin/bash

sudo systemctl enable influxd
sudo systemctl start influxd

influx -execute "CREATE DATABASE telegraf_db"
influx -execute "CREATE USER telegraf_user WITH PASSWORD 'password'"
influx -execute "GRANT ALL ON telegraf_db TO telegraf_user"
influx -execute 'CREATE RETENTION POLICY "one_year" ON "telegraf_db" DURATION 365d REPLICATION 1'