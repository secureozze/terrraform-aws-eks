output "subnetId" {
  description = "subnet Id"
  value = var.create ? aws_subnet.eksSubnet[0].id : null
}