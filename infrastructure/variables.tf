variable "argocd_version" {
  description = "version of the Argo CD Helm chart to be installed"
  type        = string
  default     = "8.0.9"
}

variable "metrics_server_version" {
  description = "version of the metrics server helm chart to be installed"
  type        = string
  default     = "3.12.2"
}

