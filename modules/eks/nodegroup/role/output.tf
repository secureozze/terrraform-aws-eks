output "eksNodeGroupRoleArn" {
  description = "nodegroup role arn"
  value       = aws_iam_role.eksNodeGroupRole.arn
}