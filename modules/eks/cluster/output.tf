output "clusterName" {
  description = "cluster name"
  value       = aws_eks_cluster.eksCluster.name
}

output "clusterEndpoint" {
  description = "cluster endpoint"
  value       = aws_eks_cluster.eksCluster.endpoint
}

output "clusterCaCertificate" {
  description = "cluster ca certificate"
  value       = aws_eks_cluster.eksCluster.certificate_authority[0].data
}

output "clusterToken" {
  value = data.aws_eks_cluster_auth.eksClusterAuth.token
}