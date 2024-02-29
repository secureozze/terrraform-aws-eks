resource "aws_eks_node_group" "nodeGroup" {
  cluster_name    = var.clusterName
  node_group_name = var.nodegroupName
  node_role_arn   = var.eksNodeGroupRoleArn
  subnet_ids      = var.subnetIds

  instance_types = ["t3.xlarge"]
  capacity_type  = "SPOT"

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  dynamic "remote_access" {
    for_each = var.isPublic ? [1] : [0]
    content {
      ec2_ssh_key               = var.keyPairName
    }
  }
}