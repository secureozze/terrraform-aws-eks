resource "aws_internet_gateway" "eksIgw" {
  vpc_id = var.vpcId
  tags = {
    Name = var.name
  }
}