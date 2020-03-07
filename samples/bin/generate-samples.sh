#!/bin/bash

mkdir -p sample-rules

echo "---

schema_version: 1

rules:

  - description: Send everyting except secret to backend23.example.net
    domains:
      - mydomain.example.com
    matches:
      all:
        - paths:
            regex:
              - '.*'
        - paths:
            not: True
            begins_with:
              - '/secret/'

    actions:
      backend:
        origin: 'http://backend23.example.net'" > sample-rules/mydomain-sample-rule.yml

echo "---

schema_version: 1

haproxy:
  address: 127.0.0.1

varnish:
  address: 127.0.0.1

dns:
  nameservers:
    - 127.0.0.11
    - 1.1.1.1
    - 1.0.0.1
    - 8.8.8.8
    - 8.8.4.4

internal_networks:
  - '127.0.0.1/8'
  - '10.0.0.1/8'
  - '172.16.0.1/12'
  - '192.168.0.1/16'" > globals.yml

