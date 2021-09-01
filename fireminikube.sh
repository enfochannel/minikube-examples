#!/bin/sh

echo "Welcome to minikube - 🔥 Let's fire it!"

minikube start \
--cpus=2 \
--memory=1990 \
--driver=docker \
--vm=true

#--driver=hyperkit (useful for nginx-ingress controller)

minikube docker-env

echo "Enabling addon: metrics server"

minikube addons enable metrics-server

`eval $(minikube docker-env)`

`eval $(minikube -p minikube docker-env)`


echo "Done! Ready to roll!"
