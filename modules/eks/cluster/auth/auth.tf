provider "kubernetes" {
  host                   = var.clusterEndpoint
  cluster_ca_certificate = base64decode(var.clusterCaCertificate)
  # token                  = var.clusterToken
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command = "aws"
    args = [ "eks", "get-token", "--cluster-name", var.clusterName ]
  }
}

resource "kubernetes_config_map_v1" "awsAuthCm" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = local.aws_auth_data
}