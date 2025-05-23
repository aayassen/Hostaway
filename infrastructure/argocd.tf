resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = kubernetes_namespace.argocd.metadata[0].name
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  version          = var.argocd_version
  create_namespace = false

  values = [
    file("${path.module}/helm_values/argocd_values.yaml")
  ]
  depends_on = [ kubernetes_namespace.argocd ]
}
