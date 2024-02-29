resource "aws_vpc" "eksVpc" {
  cidr_block = var.cidrBlock

  tags = {
    Name = var.name
  }
}