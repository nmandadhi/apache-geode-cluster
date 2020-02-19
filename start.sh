#!/bin/bash

address=$(kubectl get svc locator-public -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
if [[ $address == "" ]]; then
  address=$(kubectl get svc locator-public -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
  if [[ $address == "" ]]; then
    echo "External IP is not yet available, try in sometime ..."
    exit 1
  fi
fi
port=$(kubectl get svc locator-public -o jsonpath='{.spec.ports[?(@.name == "http")].port}')

cat <<EOF
gfsh
connect --use-http=true --url=http://$address:$port/geode-mgmt/v1
start pulse --url=http://$address:$port/pulse
EOF
