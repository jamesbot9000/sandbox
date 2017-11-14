#!/bin/bash

kubectl delete -f ../kube-config/extensions/carbon-c-relay.yaml    ; kubectl delete hpa/carbon-relay ; kubectl delete rc/carbon-relay ; rm -rf terraform.tfstate* ; rm -rf *plan


