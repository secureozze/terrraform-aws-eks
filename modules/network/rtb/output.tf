output "rtbId" {
  description = "rtb id"
  value       = var.create ? aws_route_table.eksRtb[0].id : null
}