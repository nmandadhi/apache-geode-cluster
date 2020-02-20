#!/bin/bash

address=$(kubectl get svc geode -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
if [[ $address == "" ]]; then
  address=$(kubectl get svc geode -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
  if [[ $address == "" ]]; then
    echo "External IP is not yet available, try in sometime ..."
    exit 1
  fi
fi
port=$(kubectl get svc geode -o jsonpath='{.spec.ports[?(@.name == "http")].port}')

gfsh -e "start pulse --url=http://$address:$port/pulse"
gfsh -e "connect --use-http=true --url=http://$address:$port/geode-mgmt/v1"
