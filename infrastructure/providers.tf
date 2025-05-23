terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.8.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "hostaway"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "hostaway"
  }
}

