resource "kubernetes_namespace" "staging" {
  metadata {
    name = "staging"
  }
}

resource "kubernetes_namespace" "production" {
  metadata {
    name = "production"
  }
}
