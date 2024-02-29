resource "aws_eip" "eipNatGw" {
  count = var.create ? 1 : 0
  tags = {
    Name = "${var.name}-eip"
  }
}

resource "aws_nat_gateway" "natGw" {
  count         = var.create ? 1 : 0
  allocation_id = aws_eip.eipNatGw[count.index].id
  subnet_id     = var.subnetId
  tags = {
    Name = var.name
  }
}