resource "aws_subnet" "eksSubnet" {
  count = var.create ? 1 : 0
  vpc_id                  = var.vpcId
  cidr_block              = var.cidrBlock
  map_public_ip_on_launch = var.isPublic
  availability_zone       = var.az
  tags = {
    Name = var.name
  }
}

resource "aws_route_table_association" "eksRtbAssoiation" {
  count = var.create ? 1 : 0
  subnet_id      = aws_subnet.eksSubnet[0].id
  route_table_id = var.rtbId
}