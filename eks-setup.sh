#!/bin/bash
# Task 2: Create EKS cluster with namespace fss-clu, RBAC, and deploy k8s-manifests

eksctl create cluster \
  --name fss-cluster \
  --region ap-south-2 \
  --nodegroup-name fss-nodes \
  --node-type c7i-flex.large \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 3 \
  --managed

aws eks update-kubeconfig --name fss-cluster --region ap-south-2

kubectl create namespace fss-clu
kubectl create namespace argocd

kubectl create serviceaccount fss-sa -n fss-clu

kubectl create clusterrolebinding fss-admin \
  --clusterrole=cluster-admin \
  --serviceaccount=fss-clu:fss-sa

# Enable OIDC for EBS CSI Driver (from Notes file)
eksctl utils associate-iam-oidc-provider \
  --region ap-south-2 \
  --cluster fss-cluster \
  --approve

kubectl apply -f k8s-manifests/

kubectl get nodes
kubectl get pods -n fss-clu
kubectl get svc -n fss-clu
