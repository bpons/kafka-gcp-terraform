#!/bin/bash

sudo systemctl enable grafana-server.service
sudo systemctl start grafana-server

bash -c 'while [[ "$(curl -u admin:admin -s -o /dev/null -w ''%{http_code}'' localhost:3000)" != "200" ]]; do sleep 5; done'

curl -X PUT -H "Content-Type: application/json" -d '{
  "oldPassword": "admin",
  "newPassword": "password",
  "confirmNew": "password"
}' http://admin:admin@localhost:3000/api/user/password