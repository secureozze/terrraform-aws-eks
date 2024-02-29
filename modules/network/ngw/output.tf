output "natGwId" {
  value = var.create ? aws_nat_gateway.natGw[0].id : null
}