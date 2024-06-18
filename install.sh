#!/bin/bash

echo "--- Setup in preprod"
KUBECONFIG=$(pwd)/kubeconfig-skupper-preprod.yaml kubectl create ns preprod
KUBECONFIG=$(pwd)/kubeconfig-skupper-preprod.yaml kubectl config set-context --current --namespace preprod
KUBECONFIG=$(pwd)/kubeconfig-skupper-preprod.yaml skupper init --ingress loadbalancer --console-ingress none
KUBECONFIG=$(pwd)/kubeconfig-skupper-preprod.yaml skupper token create ./preprod.token

echo "--- Setup in prod"
KUBECONFIG=$(pwd)/kubeconfig-skupper-prod.yaml kubectl create ns prod
KUBECONFIG=$(pwd)/kubeconfig-skupper-prod.yaml kubectl config set-context --current --namespace prod
KUBECONFIG=$(pwd)/kubeconfig-skupper-prod.yaml skupper init --ingress none --console-ingress none
KUBECONFIG=$(pwd)/kubeconfig-skupper-prod.yaml skupper link create ./preprod.token

echo "--- Building prod GPU service"
KUBECONFIG=$(pwd)/kubeconfig-skupper-prod.yaml kubectl apply -f ollama.yaml
KUBECONFIG=$(pwd)/kubeconfig-skupper-prod.yaml kubectl rollout status deployment ollama

echo "--- Expose prod GPU service to other cluster"
KUBECONFIG=$(pwd)/kubeconfig-skupper-prod.yaml skupper expose deployment ollama --port 11434

echo "--- Show exposed GPU service in preprod"
KUBECONFIG=$(pwd)/kubeconfig-skupper-preprod.yaml kubectl get svc ollama

echo "--- Building preprod chatbot service"
KUBECONFIG=$(pwd)/kubeconfig-skupper-preprod.yaml kubectl apply -f chatbot.yaml
KUBECONFIG=$(pwd)/kubeconfig-skupper-preprod.yaml kubectl rollout status deployment chatbot

echo "--- Exposing preprod chatbot service via loadbalancer"
KUBECONFIG=$(pwd)/kubeconfig-skupper-preprod.yaml kubectl expose deployment chatbot --port 8080 --type LoadBalancer

echo "--- Waiting for external IP"
sleep 40

echo "--- Show exposed chatbot service"
KUBECONFIG=$(pwd)/kubeconfig-skupper-preprod.yaml kubectl get svc chatbot
