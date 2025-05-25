#!/bin/bash

CLUSTER_NAME="hostaway"
DRIVER="docker" 
NODES=3

if minikube profile list | grep -q "$CLUSTER_NAME"; then
  echo "✅ Minikube cluster '$CLUSTER_NAME' already exists. Skipping creation."
else
  echo "Starting a Minikube cluster with the name $CLUSTER_NAME using the driver $DRIVER with $NODES Nodes..."
  minikube start --profile $CLUSTER_NAME --driver $DRIVER --addons ingress --addons ingress-dns 
fi
minikube status --profile="$CLUSTER_NAME" 

echo "🏗️🏗️ creating cluster components using Terraform" 

cd infrastructure && tofu init && tofu plan && tofu apply -auto-approve
cd "../"

eval $(minikube docker-env --profile $CLUSTER_NAME)
echo "⚙️⚙️⚙️ Building staging docker image for hostaway application"
docker build -f ./hostaway-app/Dockerfile -t amralaayassen/hostaway-app:1.0.0 ./hostaway-app

if [ $? -ne 0 ]; then
  echo "❌ Docker build failed."
  exit 1
fi


echo "⚙️⚙️⚙️ Building production docker image for hostaway application"
docker build -f ./hostaway-app/Dockerfile -t amralaayassen/hostaway-app:prod-1.0.0 ./hostaway-app

if [ $? -ne 0 ]; then
  echo "❌ Docker build failed."
  exit 1
fi

echo "⚙️⚙️⚙️ Loading docker images inside minikube cluster"

docker push amralaayassen/hostaway-app:1.0.0 && docker push amralaayassen/hostaway-app:prod-1.0.0

if [ $? -ne 0 ]; then
  echo "❌ Failed to load images into the cluster"
  exit 1
fi

echo "applying application set manifest"
kubectl apply -f ./k8s-manifests/hostaway-appset.yaml -n argocd

if [ $? -ne 0 ]; then
  echo "❌ Failed to apply argocd manifest to the cluster"
  exit 1
else
  echo "✅ Applied argocd manifests to the cluster"
fi

echo "You setup is ready ✅ , Please login into the cluster and port-forward to argocd to see the Hostaway applications"

echo "kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "initial argocd login credentials are admin: $(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 --decode)"
echo "You can access argocd at https://localhost:8080"
