resource "aws_route_table" "eksRtb" {
  count = var.create ? 1 : 0
  vpc_id = var.vpcId
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gwId
  }
  tags = {
    Name = var.name
  }
}