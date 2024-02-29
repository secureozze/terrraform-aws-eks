resource "aws_security_group" "ingressTerraformSg" {
  name        = "${var.name}-ingressTerraformSg"
  description = "For Terraform SG"
  vpc_id      = var.vpcId
  tags = {
    Name = "${var.name}-ingressTerraformSg"
  }
}

resource "aws_security_group_rule" "ingressTerraformSgRule" {
  security_group_id = aws_security_group.ingressTerraformSg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  prefix_list_ids   = ["pl-030ad375b6e273f91"]
}