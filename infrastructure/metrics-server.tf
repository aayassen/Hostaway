resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  namespace  = "kube-system"
  chart      = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  version    = var.metrics_server_version

  values = [
    yamlencode({
      args = [
        "--kubelet-insecure-tls",
        "--kubelet-preferred-address-types=InternalIP,Hostname,InternalDNS,ExternalDNS,ExternalIP"
      ]
    })
  ]
}
