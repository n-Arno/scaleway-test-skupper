#!/bin/bash

echo "--- Cleanup in preprod"
KUBECONFIG=$(pwd)/kubeconfig-skupper-preprod.yaml skupper delete
KUBECONFIG=$(pwd)/kubeconfig-skupper-preprod.yaml kubectl delete svc chatbot
KUBECONFIG=$(pwd)/kubeconfig-skupper-preprod.yaml kubectl delete -f chatbot.yaml
KUBECONFIG=$(pwd)/kubeconfig-skupper-preprod.yaml kubectl config set-context --current --namespace default
KUBECONFIG=$(pwd)/kubeconfig-skupper-preprod.yaml kubectl delete ns preprod

echo "--- Cleanup in prod"
KUBECONFIG=$(pwd)/kubeconfig-skupper-prod.yaml skupper delete
KUBECONFIG=$(pwd)/kubeconfig-skupper-prod.yaml kubectl delete svc ollama
KUBECONFIG=$(pwd)/kubeconfig-skupper-prod.yaml kubectl config set-context --current --namespace default
KUBECONFIG=$(pwd)/kubeconfig-skupper-prod.yaml kubectl delete ns prod

rm -f *.token
