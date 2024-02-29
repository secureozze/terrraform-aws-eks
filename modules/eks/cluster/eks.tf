resource "aws_eks_cluster" "eksCluster" {
  name     = var.name
  version  = var.clusterVersion
  role_arn = aws_iam_role.eksClusterRole.arn

  vpc_config {
    subnet_ids         = var.subnetIds
    security_group_ids = [aws_security_group.ingressTerraformSg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eksClusterRolePolicy,
    aws_iam_role_policy_attachment.eksVpcResourceController
  ]

}

data "aws_eks_cluster_auth" "eksClusterAuth" {
  name = var.name

  depends_on = [
    aws_eks_cluster.eksCluster
  ]
}